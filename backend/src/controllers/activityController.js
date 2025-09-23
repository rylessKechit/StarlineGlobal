const Activity = require('../models/Activity');
const User = require('../models/User');
const { validateEmail } = require('../middleware/validation');

// Create new activity
const createActivity = async (req, res) => {
  try {
    const {
      title, description, shortDescription, category, subCategory, tags,
      location, pricing, capacity, duration, availability, images, videos,
      features, amenities, requirements, seo
    } = req.body;

    // Validate required fields
    if (!title || !description || !category || !location || !pricing) {
      return res.status(400).json({
        success: false,
        message: 'Title, description, category, location, and pricing are required'
      });
    }

    // Validate user is a provider
    if (req.user.role !== 'prestataire' && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Only providers can create activities'
      });
    }

    // Validate category
    const validCategories = ['realEstate', 'airTravel', 'transport', 'lifestyle', 'events', 'security', 'corporate'];
    if (!validCategories.includes(category)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid category specified'
      });
    }

    // Validate location structure
    if (!location.city || !location.country) {
      return res.status(400).json({
        success: false,
        message: 'City and country are required in location'
      });
    }

    // Validate pricing structure
    if (!pricing.basePrice || pricing.basePrice < 0) {
      return res.status(400).json({
        success: false,
        message: 'Valid base price is required'
      });
    }

    // Validate capacity
    if (!capacity || !capacity.max || capacity.max < 1) {
      return res.status(400).json({
        success: false,
        message: 'Valid maximum capacity is required'
      });
    }

    // Validate duration
    if (!duration || !duration.value || duration.value < 0) {
      return res.status(400).json({
        success: false,
        message: 'Valid duration is required'
      });
    }

    // Create activity data
    const activityData = {
      title: title.trim(),
      description: description.trim(),
      shortDescription: shortDescription?.trim(),
      category,
      subCategory: subCategory?.trim(),
      tags: tags || [],
      providerId: req.user._id,
      providerName: req.user.name,
      companyName: req.user.companyName,
      location,
      pricing,
      capacity: {
        min: capacity.min || 1,
        max: capacity.max
      },
      duration,
      availability: availability || { isActive: true },
      images: images || [],
      videos: videos || [],
      features: features || [],
      amenities: amenities || [],
      requirements: requirements || {},
      seo: seo || {},
      status: 'draft' // Always start as draft
    };

    // Create new activity
    const activity = new Activity(activityData);
    await activity.save();

    res.status(201).json({
      success: true,
      message: 'Activity created successfully',
      data: {
        activity
      }
    });

  } catch (error) {
    console.error('Create activity error:', error);

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
      message: 'Server error while creating activity'
    });
  }
};

// Get all activities with filtering and pagination
const getActivities = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      category,
      status,
      providerId,
      city,
      country,
      minPrice,
      maxPrice,
      featured,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // Build query
    const query = {};

    // Status filter - default to active for non-admin users
    if (req.user.role === 'admin') {
      if (status) query.status = status;
    } else if (req.user.role === 'prestataire') {
      // Providers can see their own activities in any status
      query.providerId = req.user._id;
      if (status) query.status = status;
    } else {
      // Clients can only see active activities
      query.status = 'active';
    }

    // Other filters
    if (category) query.category = category;
    if (providerId && req.user.role === 'admin') query.providerId = providerId;
    if (city) query['location.city'] = new RegExp(city, 'i');
    if (country) query['location.country'] = new RegExp(country, 'i');
    if (featured !== undefined) query.featured = featured === 'true';

    // Price range filter
    if (minPrice || maxPrice) {
      query['pricing.basePrice'] = {};
      if (minPrice) query['pricing.basePrice'].$gte = parseFloat(minPrice);
      if (maxPrice) query['pricing.basePrice'].$lte = parseFloat(maxPrice);
    }

    // Search functionality
    if (search) {
      query.$or = [
        { title: new RegExp(search, 'i') },
        { description: new RegExp(search, 'i') },
        { 'location.city': new RegExp(search, 'i') },
        { tags: new RegExp(search, 'i') }
      ];
    }

    // Pagination
    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    // Sort options
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'asc' ? 1 : -1;

    // Execute query with pagination
    const [activities, totalActivities] = await Promise.all([
      Activity.find(query)
        .populate('providerId', 'name email companyName rating')
        .sort(sortOptions)
        .skip(skip)
        .limit(limitNumber)
        .lean(),
      Activity.countDocuments(query)
    ]);

    // Calculate pagination info
    const totalPages = Math.ceil(totalActivities / limitNumber);
    const hasNext = pageNumber < totalPages;
    const hasPrev = pageNumber > 1;

    res.status(200).json({
      success: true,
      data: {
        activities,
        pagination: {
          currentPage: pageNumber,
          totalPages,
          totalActivities,
          hasNext,
          hasPrev,
          limit: limitNumber
        }
      }
    });

  } catch (error) {
    console.error('Get activities error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching activities'
    });
  }
};

// Get single activity by ID
const getActivityById = async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid activity ID'
      });
    }

    const activity = await Activity.findById(id)
      .populate('providerId', 'name email phone companyName location rating reviewsCount')
      .lean();

    if (!activity) {
      return res.status(404).json({
        success: false,
        message: 'Activity not found'
      });
    }

    // Check access permissions
    const canAccess = 
      activity.status === 'active' || // Public access to active
      req.user.role === 'admin' || // Admin can see all
      (req.user.role === 'prestataire' && activity.providerId._id.toString() === req.user._id.toString()); // Provider can see own

    if (!canAccess) {
      return res.status(403).json({
        success: false,
        message: 'Access denied to this activity'
      });
    }

    // Increment view count if it's a public view (not owner/admin)
    if (activity.status === 'active' && req.user._id.toString() !== activity.providerId._id.toString()) {
      await Activity.findByIdAndUpdate(id, { $inc: { 'stats.views': 1 } });
    }

    res.status(200).json({
      success: true,
      data: {
        activity
      }
    });

  } catch (error) {
    console.error('Get activity by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching activity'
    });
  }
};

// Update activity
const updateActivity = async (req, res) => {
  try {
    const { id } = req.params;
    const updates = req.body;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid activity ID'
      });
    }

    // Find activity
    const activity = await Activity.findById(id);

    if (!activity) {
      return res.status(404).json({
        success: false,
        message: 'Activity not found'
      });
    }

    // Check permissions
    const canUpdate = 
      req.user.role === 'admin' ||
      (req.user.role === 'prestataire' && activity.providerId.toString() === req.user._id.toString());

    if (!canUpdate) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. You can only update your own activities.'
      });
    }

    // Validate category if provided
    if (updates.category) {
      const validCategories = ['realEstate', 'airTravel', 'transport', 'lifestyle', 'events', 'security', 'corporate'];
      if (!validCategories.includes(updates.category)) {
        return res.status(400).json({
          success: false,
          message: 'Invalid category specified'
        });
      }
    }

    // Validate status updates (only admin can approve/reject)
    if (updates.status && updates.status !== activity.status) {
      if (req.user.role !== 'admin' && !['draft', 'pending'].includes(updates.status)) {
        return res.status(403).json({
          success: false,
          message: 'Only admins can change activity status to active, paused, or rejected'
        });
      }
    }

    // Update allowed fields
    const allowedUpdates = [
      'title', 'description', 'shortDescription', 'category', 'subCategory', 'tags',
      'location', 'pricing', 'capacity', 'duration', 'availability', 'images', 'videos',
      'features', 'amenities', 'requirements', 'seo'
    ];

    // Admin can update status and featured
    if (req.user.role === 'admin') {
      allowedUpdates.push('status', 'featured', 'priority', 'moderationNotes');
    }

    // Apply updates
    allowedUpdates.forEach(field => {
      if (updates[field] !== undefined) {
        activity[field] = updates[field];
      }
    });

    // Save updated activity
    await activity.save();

    // Populate for response
    await activity.populate('providerId', 'name email companyName');

    res.status(200).json({
      success: true,
      message: 'Activity updated successfully',
      data: {
        activity
      }
    });

  } catch (error) {
    console.error('Update activity error:', error);

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
      message: 'Server error while updating activity'
    });
  }
};

// Delete activity
const deleteActivity = async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid activity ID'
      });
    }

    // Find activity
    const activity = await Activity.findById(id);

    if (!activity) {
      return res.status(404).json({
        success: false,
        message: 'Activity not found'
      });
    }

    // Check permissions
    const canDelete = 
      req.user.role === 'admin' ||
      (req.user.role === 'prestataire' && activity.providerId.toString() === req.user._id.toString());

    if (!canDelete) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. You can only delete your own activities.'
      });
    }

    // Check if activity has active bookings
    const Booking = require('../models/Booking');
    const activeBookings = await Booking.countDocuments({
      activityId: id,
      status: { $in: ['pending', 'confirmed', 'in_progress'] }
    });

    if (activeBookings > 0) {
      return res.status(400).json({
        success: false,
        message: 'Cannot delete activity with active bookings. Please cancel or complete them first.'
      });
    }

    // Delete activity
    await Activity.findByIdAndDelete(id);

    res.status(200).json({
      success: true,
      message: 'Activity deleted successfully'
    });

  } catch (error) {
    console.error('Delete activity error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while deleting activity'
    });
  }
};

// Toggle activity status (activate/pause)
const toggleActivityStatus = async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId
    if (!id.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid activity ID'
      });
    }

    // Find activity
    const activity = await Activity.findById(id);

    if (!activity) {
      return res.status(404).json({
        success: false,
        message: 'Activity not found'
      });
    }

    // Check permissions
    const canToggle = 
      req.user.role === 'admin' ||
      (req.user.role === 'prestataire' && activity.providerId.toString() === req.user._id.toString());

    if (!canToggle) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. You can only modify your own activities.'
      });
    }

    // Toggle between active and paused (only for approved activities)
    if (activity.status === 'active') {
      activity.status = 'paused';
    } else if (activity.status === 'paused') {
      activity.status = 'active';
    } else {
      return res.status(400).json({
        success: false,
        message: 'Can only toggle status for active or paused activities'
      });
    }

    await activity.save();

    res.status(200).json({
      success: true,
      message: `Activity ${activity.status === 'active' ? 'activated' : 'paused'} successfully`,
      data: {
        activity: {
          _id: activity._id,
          title: activity.title,
          status: activity.status
        }
      }
    });

  } catch (error) {
    console.error('Toggle activity status error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while toggling activity status'
    });
  }
};

// Get activities by provider
const getProviderActivities = async (req, res) => {
  try {
    const { providerId } = req.params;
    const { status, page = 1, limit = 10 } = req.query;

    // Validate ObjectId
    if (!providerId.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid provider ID'
      });
    }

    // Check permissions
    const canView = 
      req.user.role === 'admin' ||
      req.user._id.toString() === providerId;

    if (!canView) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Build query
    const query = { providerId };
    if (status) query.status = status;

    // Pagination
    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    const [activities, totalActivities] = await Promise.all([
      Activity.find(query)
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limitNumber)
        .lean(),
      Activity.countDocuments(query)
    ]);

    // Calculate pagination
    const totalPages = Math.ceil(totalActivities / limitNumber);

    res.status(200).json({
      success: true,
      data: {
        activities,
        pagination: {
          currentPage: pageNumber,
          totalPages,
          totalActivities,
          hasNext: pageNumber < totalPages,
          hasPrev: pageNumber > 1,
          limit: limitNumber
        }
      }
    });

  } catch (error) {
    console.error('Get provider activities error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching provider activities'
    });
  }
};

// Search activities
const searchActivities = async (req, res) => {
  try {
    const { q: searchTerm, category, city, minPrice, maxPrice, page = 1, limit = 10 } = req.query;

    if (!searchTerm) {
      return res.status(400).json({
        success: false,
        message: 'Search term is required'
      });
    }

    // Build filters
    const filters = {};
    if (category) filters.category = category;
    if (city) filters.city = city;
    if (minPrice) filters.minPrice = parseFloat(minPrice);
    if (maxPrice) filters.maxPrice = parseFloat(maxPrice);

    // Pagination
    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    // Search activities
    const activities = await Activity.search(searchTerm, filters)
      .populate('providerId', 'name companyName rating')
      .sort({ 'stats.rating.average': -1, priority: -1 })
      .skip(skip)
      .limit(limitNumber)
      .lean();

    // Count total results
    const totalActivities = await Activity.search(searchTerm, filters).countDocuments();
    const totalPages = Math.ceil(totalActivities / limitNumber);

    res.status(200).json({
      success: true,
      data: {
        activities,
        searchTerm,
        filters,
        pagination: {
          currentPage: pageNumber,
          totalPages,
          totalActivities,
          hasNext: pageNumber < totalPages,
          hasPrev: pageNumber > 1,
          limit: limitNumber
        }
      }
    });

  } catch (error) {
    console.error('Search activities error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while searching activities'
    });
  }
};

// Get activity statistics (for providers/admin)
const getActivityStats = async (req, res) => {
  try {
    let query = {};
    
    // Providers can only see their own stats
    if (req.user.role === 'prestataire') {
      query.providerId = req.user._id;
    }

    const [
      totalActivities,
      activeActivities,
      pendingActivities,
      totalViews,
      avgRating,
      totalBookings
    ] = await Promise.all([
      Activity.countDocuments(query),
      Activity.countDocuments({ ...query, status: 'active' }),
      Activity.countDocuments({ ...query, status: 'pending' }),
      Activity.aggregate([
        { $match: query },
        { $group: { _id: null, total: { $sum: '$stats.views' } } }
      ]),
      Activity.aggregate([
        { $match: { ...query, 'stats.rating.count': { $gt: 0 } } },
        { $group: { _id: null, avg: { $avg: '$stats.rating.average' } } }
      ]),
      Activity.aggregate([
        { $match: query },
        { $group: { _id: null, total: { $sum: '$stats.bookings.total' } } }
      ])
    ]);

    const stats = {
      activities: {
        total: totalActivities,
        active: activeActivities,
        pending: pendingActivities,
        paused: totalActivities - activeActivities - pendingActivities
      },
      performance: {
        totalViews: totalViews[0]?.total || 0,
        averageRating: avgRating[0]?.avg ? Math.round(avgRating[0].avg * 10) / 10 : 0,
        totalBookings: totalBookings[0]?.total || 0
      }
    };

    res.status(200).json({
      success: true,
      data: { stats }
    });

  } catch (error) {
    console.error('Get activity stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching activity statistics'
    });
  }
};

module.exports = {
  createActivity,
  getActivities,
  getActivityById,
  updateActivity,
  deleteActivity,
  toggleActivityStatus,
  getProviderActivities,
  searchActivities,
  getActivityStats
};