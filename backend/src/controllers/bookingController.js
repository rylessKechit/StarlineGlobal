const Booking = require('../models/Booking');
const Activity = require('../models/Activity');
const User = require('../models/User');

// Create new booking
const createBooking = async (req, res) => {
  try {
    const {
      activityId,
      bookingDate,
      participants,
      clientInfo,
      meetingPoint,
      clientNotes,
      extras
    } = req.body;

    // Validate required fields
    if (!activityId || !bookingDate || !participants || !clientInfo || !meetingPoint) {
      return res.status(400).json({
        success: false,
        message: 'Activity ID, booking date, participants, client info, and meeting point are required'
      });
    }

    // Validate ObjectId
    if (!activityId.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid activity ID'
      });
    }

    // Find activity
    const activity = await Activity.findById(activityId).populate('providerId');

    if (!activity) {
      return res.status(404).json({
        success: false,
        message: 'Activity not found'
      });
    }

    // Check if activity is active and available
    if (activity.status !== 'active') {
      return res.status(400).json({
        success: false,
        message: 'Activity is not currently available for booking'
      });
    }

    // Validate booking dates
    const startDate = new Date(bookingDate.start);
    const endDate = new Date(bookingDate.end);
    const now = new Date();

    if (startDate < now) {
      return res.status(400).json({
        success: false,
        message: 'Booking date cannot be in the past'
      });
    }

    if (endDate <= startDate) {
      return res.status(400).json({
        success: false,
        message: 'End date must be after start date'
      });
    }

    // Check advance booking requirement
    const hoursInAdvance = (startDate - now) / (1000 * 60 * 60);
    if (hoursInAdvance < activity.availability.advanceBooking) {
      return res.status(400).json({
        success: false,
        message: `This activity requires at least ${activity.availability.advanceBooking} hours advance booking`
      });
    }

    // Validate participants
    if (!participants.adults || participants.adults < 1) {
      return res.status(400).json({
        success: false,
        message: 'At least one adult participant is required'
      });
    }

    const totalParticipants = participants.adults + (participants.children || 0);
    if (totalParticipants < activity.capacity.min || totalParticipants > activity.capacity.max) {
      return res.status(400).json({
        success: false,
        message: `Number of participants must be between ${activity.capacity.min} and ${activity.capacity.max}`
      });
    }

    // Check availability for the requested dates
    const isAvailable = activity.isAvailableForDates(startDate, endDate);
    if (!isAvailable) {
      return res.status(400).json({
        success: false,
        message: 'Activity is not available for the selected dates'
      });
    }

    // Check for conflicting bookings
    const conflictingBookings = await Booking.findByDateRange(startDate, endDate, {
      activityId: activityId,
      status: { $in: ['confirmed', 'in_progress'] }
    });

    if (conflictingBookings.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Activity is already booked for the selected time period'
      });
    }

    // Calculate duration
    const durationHours = Math.ceil((endDate - startDate) / (1000 * 60 * 60));
    const duration = {
      value: durationHours,
      unit: 'hours'
    };

    // Calculate pricing
    let baseAmount = activity.pricing.basePrice;
    
    // Adjust pricing based on price type
    switch(activity.pricing.priceType) {
      case 'per_hour':
        baseAmount = baseAmount * durationHours;
        break;
      case 'per_day':
        const days = Math.ceil(durationHours / 24);
        baseAmount = baseAmount * days;
        break;
      case 'per_person':
        baseAmount = baseAmount * totalParticipants;
        break;
    }

    const pricing = {
      baseAmount,
      extras: extras || [],
      discounts: [],
      taxes: {
        rate: 20, // Default VAT rate
        amount: 0
      },
      subtotal: baseAmount,
      totalAmount: baseAmount,
      currency: activity.pricing.currency
    };

    // Create booking data
    const bookingData = {
      clientId: req.user._id,
      providerId: activity.providerId._id,
      activityId: activityId,
      bookingDate: {
        start: startDate,
        end: endDate
      },
      duration,
      participants: {
        adults: participants.adults,
        children: participants.children || 0,
        total: totalParticipants
      },
      pricing,
      clientInfo: {
        name: clientInfo.name.trim(),
        email: clientInfo.email.toLowerCase().trim(),
        phone: clientInfo.phone.trim(),
        emergencyContact: clientInfo.emergencyContact,
        specialRequests: clientInfo.specialRequests,
        dietaryRequirements: clientInfo.dietaryRequirements || [],
        accessibilityNeeds: clientInfo.accessibilityNeeds
      },
      meetingPoint: {
        location: meetingPoint.location.trim(),
        coordinates: meetingPoint.coordinates,
        instructions: meetingPoint.instructions,
        contactPerson: meetingPoint.contactPerson
      },
      clientNotes: clientNotes?.trim(),
      status: 'pending',
      payment: {
        status: 'pending'
      }
    };

    // Create booking
    const booking = new Booking(bookingData);
    await booking.save();

    // Update activity statistics
    await Activity.findByIdAndUpdate(activityId, {
      $inc: { 'stats.bookings.total': 1 }
    });

    // Populate for response
    await booking.populate([
      { path: 'activityId', select: 'title images location pricing' },
      { path: 'providerId', select: 'name email phone companyName' }
    ]);

    res.status(201).json({
      success: true,
      message: 'Booking created successfully',
      data: {
        booking
      }
    });

  } catch (error) {
    console.error('Create booking error:', error);

    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: messages
      });
    }

    res.status(500).json({
      success: false,
      message: 'Server error while creating booking'
    });
  }
};

// Get all bookings with filtering and pagination
const getBookings = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      status,
      clientId,
      providerId,
      activityId,
      startDate,
      endDate,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // Build query based on user role
    let query = {};

    if (req.user.role === 'client') {
      query.clientId = req.user._id;
    } else if (req.user.role === 'prestataire') {
      query.providerId = req.user._id;
    }
    // Admin can see all bookings

    // Apply filters
    if (status) query.status = status;
    if (clientId && req.user.role === 'admin') query.clientId = clientId;
    if (providerId && req.user.role === 'admin') query.providerId = providerId;
    if (activityId) query.activityId = activityId;

    // Date range filter
    if (startDate || endDate) {
      query['bookingDate.start'] = {};
      if (startDate) query['bookingDate.start'].$gte = new Date(startDate);
      if (endDate) query['bookingDate.start'].$lte = new Date(endDate);
    }

    // Pagination
    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    // Sort options
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'asc' ? 1 : -1;

    // Execute query with pagination
    const [bookings, totalBookings] = await Promise.all([
      Booking.find(query)
        .populate('clientId', 'name email phone')
        .populate('providerId', 'name email phone companyName')
        .populate('activityId', 'title images location category')
        .sort(sortOptions)
        .skip(skip)
        .limit(limitNumber)
        .lean(),
      Booking.countDocuments(query)
    ]);

    // Calculate pagination info
    const totalPages = Math.ceil(totalBookings / limitNumber);
    const hasNext = pageNumber < totalPages;
    const hasPrev = pageNumber > 1;

    res.status(200).json({
      success: true,
      data: {
        bookings,
        pagination: {
          currentPage: pageNumber,
          totalPages,
          totalBookings,
          hasNext,
          hasPrev,
          limit: limitNumber
        }
      }
    });

  } catch (error) {
    console.error('Get bookings error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching bookings'
    });
  }
};

// Get single booking by ID
const getBookingById = async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid booking ID'
      });
    }

    const booking = await Booking.findById(id)
      .populate('clientId', 'name email phone')
      .populate('providerId', 'name email phone companyName')
      .populate('activityId', 'title description images location pricing')
      .lean();

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found'
      });
    }

    // Check access permissions
    const canAccess = 
      req.user.role === 'admin' ||
      booking.clientId._id.toString() === req.user._id.toString() ||
      booking.providerId._id.toString() === req.user._id.toString();

    if (!canAccess) {
      return res.status(403).json({
        success: false,
        message: 'Access denied to this booking'
      });
    }

    res.status(200).json({
      success: true,
      data: {
        booking
      }
    });

  } catch (error) {
    console.error('Get booking by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching booking'
    });
  }
};

// Update booking status
const updateBookingStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes } = req.body;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid booking ID'
      });
    }

    // Validate status
    const validStatuses = ['pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'refunded'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid booking status'
      });
    }

    // Find booking
    const booking = await Booking.findById(id);

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found'
      });
    }

    // Check permissions
    let canUpdate = false;
    
    if (req.user.role === 'admin') {
      canUpdate = true;
    } else if (req.user.role === 'prestataire' && booking.providerId.toString() === req.user._id.toString()) {
      // Providers can confirm/reject bookings and mark as in_progress/completed
      canUpdate = ['confirmed', 'cancelled', 'in_progress', 'completed'].includes(status);
    } else if (req.user.role === 'client' && booking.clientId.toString() === req.user._id.toString()) {
      // Clients can only cancel their own bookings
      canUpdate = status === 'cancelled' && ['pending', 'confirmed'].includes(booking.status);
    }

    if (!canUpdate) {
      return res.status(403).json({
        success: false,
        message: 'Access denied or invalid status transition'
      });
    }

    // Validate status transitions
    const validTransitions = {
      'pending': ['confirmed', 'cancelled'],
      'confirmed': ['in_progress', 'cancelled', 'completed'],
      'in_progress': ['completed', 'cancelled'],
      'completed': ['refunded'],
      'cancelled': ['refunded'],
      'refunded': []
    };

    if (!validTransitions[booking.status].includes(status)) {
      return res.status(400).json({
        success: false,
        message: `Cannot change status from ${booking.status} to ${status}`
      });
    }

    // Update booking status
    await booking.updateStatus(status, req.user._id, notes);

    // Update activity statistics based on status change
    const Activity = require('../models/Activity');
    
    if (status === 'completed') {
      await Activity.findByIdAndUpdate(booking.activityId, {
        $inc: { 
          'stats.bookings.completed': 1,
          'stats.revenue.total': booking.pricing.totalAmount
        }
      });
    } else if (status === 'cancelled') {
      await Activity.findByIdAndUpdate(booking.activityId, {
        $inc: { 'stats.bookings.cancelled': 1 }
      });
    }

    // Populate for response
    await booking.populate([
      { path: 'clientId', select: 'name email phone' },
      { path: 'providerId', select: 'name email phone companyName' },
      { path: 'activityId', select: 'title images location' }
    ]);

    res.status(200).json({
      success: true,
      message: `Booking ${status} successfully`,
      data: {
        booking
      }
    });

  } catch (error) {
    console.error('Update booking status error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while updating booking status'
    });
  }
};

// Cancel booking
const cancelBooking = async (req, res) => {
  try {
    const { id } = req.params;
    const { reason, refundRequested } = req.body;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid booking ID'
      });
    }

    // Find booking
    const booking = await Booking.findById(id);

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found'
      });
    }

    // Check permissions
    const canCancel = 
      req.user.role === 'admin' ||
      booking.clientId.toString() === req.user._id.toString() ||
      booking.providerId.toString() === req.user._id.toString();

    if (!canCancel) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Check if booking can be cancelled
    if (!['pending', 'confirmed'].includes(booking.status)) {
      return res.status(400).json({
        success: false,
        message: 'Booking cannot be cancelled in its current status'
      });
    }

    // Determine who cancelled
    let cancelledBy = 'client';
    if (req.user._id.toString() === booking.providerId.toString()) {
      cancelledBy = 'provider';
    } else if (req.user.role === 'admin') {
      cancelledBy = 'admin';
    }

    // Calculate refund percentage based on cancellation policy
    let refundPercentage = 0;
    const hoursUntilBooking = booking.timeUntilBooking / (1000 * 60 * 60);

    if (cancelledBy === 'provider') {
      // Provider cancellation - full refund
      refundPercentage = 100;
    } else if (cancelledBy === 'client') {
      // Client cancellation - based on timing
      if (hoursUntilBooking > 48) {
        refundPercentage = 90; // 10% cancellation fee
      } else if (hoursUntilBooking > 24) {
        refundPercentage = 50;
      } else {
        refundPercentage = 0; // No refund for last-minute cancellations
      }
    } else {
      // Admin cancellation - case by case
      refundPercentage = 100;
    }

    // Cancel booking
    await booking.cancelBooking(req.user._id, reason || 'No reason provided', refundPercentage);

    // Update activity statistics
    const Activity = require('../models/Activity');
    await Activity.findByIdAndUpdate(booking.activityId, {
      $inc: { 'stats.bookings.cancelled': 1 }
    });

    res.status(200).json({
      success: true,
      message: 'Booking cancelled successfully',
      data: {
        booking: {
          _id: booking._id,
          bookingNumber: booking.bookingNumber,
          status: booking.status,
          cancellation: booking.cancellation
        }
      }
    });

  } catch (error) {
    console.error('Cancel booking error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while cancelling booking'
    });
  }
};

// Get upcoming bookings
const getUpcomingBookings = async (req, res) => {
  try {
    const { limit = 5 } = req.query;

    // Determine user role and field
    let userRole = 'client';
    if (req.user.role === 'prestataire') {
      userRole = 'provider';
    }

    const upcomingBookings = await Booking.findUpcoming(req.user._id, userRole);

    // Limit results
    const limitedBookings = upcomingBookings.slice(0, parseInt(limit));

    res.status(200).json({
      success: true,
      data: {
        bookings: limitedBookings,
        count: limitedBookings.length
      }
    });

  } catch (error) {
    console.error('Get upcoming bookings error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching upcoming bookings'
    });
  }
};

// Get booking statistics
const getBookingStats = async (req, res) => {
  try {
    let query = {};
    
    // Filter based on user role
    if (req.user.role === 'client') {
      query.clientId = req.user._id;
    } else if (req.user.role === 'prestataire') {
      query.providerId = req.user._id;
    }

    const [
      totalBookings,
      pendingBookings,
      confirmedBookings,
      completedBookings,
      cancelledBookings,
      totalRevenue,
      thisMonthBookings
    ] = await Promise.all([
      Booking.countDocuments(query),
      Booking.countDocuments({ ...query, status: 'pending' }),
      Booking.countDocuments({ ...query, status: 'confirmed' }),
      Booking.countDocuments({ ...query, status: 'completed' }),
      Booking.countDocuments({ ...query, status: 'cancelled' }),
      Booking.aggregate([
        { $match: { ...query, status: 'completed' } },
        { $group: { _id: null, total: { $sum: '$pricing.totalAmount' } } }
      ]),
      Booking.countDocuments({
        ...query,
        createdAt: { 
          $gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
        }
      })
    ]);

    const stats = {
      bookings: {
        total: totalBookings,
        pending: pendingBookings,
        confirmed: confirmedBookings,
        completed: completedBookings,
        cancelled: cancelledBookings,
        thisMonth: thisMonthBookings
      },
      revenue: {
        total: totalRevenue[0]?.total || 0,
        currency: 'EUR'
      }
    };

    res.status(200).json({
      success: true,
      data: { stats }
    });

  } catch (error) {
    console.error('Get booking stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching booking statistics'
    });
  }
};

// Add review to booking
const addBookingReview = async (req, res) => {
  try {
    const { id } = req.params;
    const { rating, comment } = req.body;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid booking ID'
      });
    }

    // Validate rating
    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        message: 'Rating must be between 1 and 5'
      });
    }

    // Find booking
    const booking = await Booking.findById(id);

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found'
      });
    }

    // Check if booking is completed
    if (booking.status !== 'completed') {
      return res.status(400).json({
        success: false,
        message: 'Can only review completed bookings'
      });
    }

    // Determine review type
    let reviewType = null;
    if (req.user._id.toString() === booking.clientId.toString()) {
      reviewType = 'clientReview';
    } else if (req.user._id.toString() === booking.providerId.toString()) {
      reviewType = 'providerReview';
    } else {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Check if review already exists
    if (booking.review[reviewType]) {
      return res.status(400).json({
        success: false,
        message: 'Review already submitted for this booking'
      });
    }

    // Add review
    booking.review[reviewType] = {
      rating,
      comment: comment?.trim(),
      submittedAt: new Date()
    };

    await booking.save();

    // Update activity rating if client review
    if (reviewType === 'clientReview') {
      const activity = await Activity.findById(booking.activityId);
      if (activity) {
        await activity.updateRating(rating);
      }
    }

    res.status(200).json({
      success: true,
      message: 'Review added successfully',
      data: {
        review: booking.review[reviewType]
      }
    });

  } catch (error) {
    console.error('Add booking review error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while adding review'
    });
  }
};

module.exports = {
  createBooking,
  getBookings,
  getBookingById,
  updateBookingStatus,
  cancelBooking,
  getUpcomingBookings,
  getBookingStats,
  addBookingReview
};