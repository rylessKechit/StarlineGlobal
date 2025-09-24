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

// Get all activities with filtering and pagination - CORRECTED VERSION
const getActivities = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      category,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc',
      city,
      minPrice,
      maxPrice
    } = req.query;

    // Build query
    let query = { status: 'active' };

    // Category filter
    if (category) {
      query.category = category;
    }

    // City filter
    if (city) {
      query['location.city'] = new RegExp(city, 'i');
    }

    // Price range filter
    if (minPrice || maxPrice) {
      query['pricing.basePrice'] = {};
      if (minPrice) query['pricing.basePrice'].$gte = parseFloat(minPrice);
      if (maxPrice) query['pricing.basePrice'].$lte = parseFloat(maxPrice);
    }

    // Search filter
    if (search) {
      query.$or = [
        { title: new RegExp(search, 'i') },
        { description: new RegExp(search, 'i') },
        { 'location.city': new RegExp(search, 'i') },
        { tags: { $in: [new RegExp(search, 'i')] } }
      ];
    }

    // Pagination
    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    // Sort options
    let sortOptions = {};
    switch (sortBy) {
      case 'price':
        sortOptions['pricing.basePrice'] = sortOrder === 'desc' ? -1 : 1;
        break;
      case 'rating':
        sortOptions['stats.rating.average'] = -1;
        break;
      case 'popularity':
        sortOptions['stats.views'] = -1;
        break;
      case 'newest':
        sortOptions.createdAt = -1;
        break;
      default:
        sortOptions.createdAt = sortOrder === 'desc' ? -1 : 1;
    }

    // Execute query with population
    const [activities, totalActivities] = await Promise.all([
      Activity.find(query)
        .populate('providerId', 'name email companyName rating')
        .sort(sortOptions)
        .skip(skip)
        .limit(limitNumber)
        .lean(),
      Activity.countDocuments(query)
    ]);

    // CRITICAL FIX: Enrich activities with all required fields
    const enrichedActivities = activities.map(activity => ({
      ...activity,
      // Ensure all required fields are present
      status: activity.status || 'active',
      createdAt: activity.createdAt || new Date().toISOString(),
      updatedAt: activity.updatedAt || new Date().toISOString(),
      // Ensure nested field compatibility
      availability: activity.availability || { isActive: true },
      capacity: activity.capacity || { min: 1, max: 10 },
      stats: activity.stats || { 
        views: 0, 
        rating: { average: 0, count: 0 }, 
        bookings: { total: 0 } 
      },
      images: activity.images || [],
      features: activity.features || [],
      tags: activity.tags || [],
      // Ensure pricing has proper default values
      pricing: {
        basePrice: activity.pricing?.basePrice || 0,
        currency: activity.pricing?.currency || 'EUR',
        priceType: activity.pricing?.priceType || 'fixed',
        ...activity.pricing
      }
    }));

    // Calculate pagination
    const totalPages = Math.ceil(totalActivities / limitNumber);

    res.status(200).json({
      success: true,
      data: {
        activities: enrichedActivities,
        pagination: {
          currentPage: pageNumber,
          totalPages,
          totalActivities,
          hasNext: pageNumber < totalPages,
          hasPrev: pageNumber > 1,
          limit: limitNumber
        }
      },
      message: 'Activities retrieved successfully'
    });

  } catch (error) {
    console.error('Get activities error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching activities'
    });
  }
};

// Get activity by ID - ALSO CORRECTED
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
      .populate('providerId', 'name email companyName rating phone')
      .lean();

    if (!activity) {
      return res.status(404).json({
        success: false,
        message: 'Activity not found'
      });
    }

    // Check if activity is accessible
    if (activity.status === 'deleted' || activity.status === 'suspended') {
      return res.status(404).json({
        success: false,
        message: 'Activity not found'
      });
    }

    // Enrich single activity as well
    const enrichedActivity = {
      ...activity,
      status: activity.status || 'active',
      createdAt: activity.createdAt || new Date().toISOString(),
      updatedAt: activity.updatedAt || new Date().toISOString(),
      availability: activity.availability || { isActive: true },
      capacity: activity.capacity || { min: 1, max: 10 },
      stats: activity.stats || { 
        views: 0, 
        rating: { average: 0, count: 0 }, 
        bookings: { total: 0 } 
      },
      images: activity.images || [],
      features: activity.features || [],
      tags: activity.tags || [],
      pricing: {
        basePrice: activity.pricing?.basePrice || 0,
        currency: activity.pricing?.currency || 'EUR',
        priceType: activity.pricing?.priceType || 'fixed',
        ...activity.pricing
      }
    };

    // Increment views (without awaiting to not slow down response)
    Activity.findByIdAndUpdate(id, { $inc: { 'stats.views': 1 } }).catch(console.error);

    res.status(200).json({
      success: true,
      data: { activity: enrichedActivity },
      message: 'Activity retrieved successfully'
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
      activity.providerId.toString() === req.user._id.toString();

    if (!canUpdate) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. You can only modify your own activities.'
      });
    }

    // Remove fields that shouldn't be updated directly
    delete updates.providerId;
    delete updates.providerName;
    delete updates.stats;
    delete updates.createdAt;

    // Update the activity
    Object.assign(activity, updates);
    activity.updatedAt = new Date();

    await activity.save();

    res.status(200).json({
      success: true,
      message: 'Activity updated successfully',
      data: { activity }
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
      activity.providerId.toString() === req.user._id.toString();

    if (!canDelete) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. You can only delete your own activities.'
      });
    }

    // Soft delete by changing status
    activity.status = 'deleted';
    activity.updatedAt = new Date();
    await activity.save();

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

// Toggle activity status (active/paused)
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
      activity.providerId.toString() === req.user._id.toString();

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

// Search activities
const searchActivities = async (req, res) => {
  try {
    const {
      query: searchQuery,
      category,
      city,
      minPrice,
      maxPrice,
      page = 1,
      limit = 20,
      sortBy = 'relevance'
    } = req.query;

    if (!searchQuery || searchQuery.trim().length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Search query is required'
      });
    }

    // Build search query
    let query = {
      status: 'active',
      $or: [
        { $text: { $search: searchQuery } },
        { title: new RegExp(searchQuery, 'i') },
        { description: new RegExp(searchQuery, 'i') },
        { tags: { $in: [new RegExp(searchQuery, 'i')] } }
      ]
    };

    // Apply filters
    if (category) query.category = category;
    if (city) query['location.city'] = new RegExp(city, 'i');
    if (minPrice) query['pricing.basePrice'] = { ...query['pricing.basePrice'], $gte: parseFloat(minPrice) };
    if (maxPrice) query['pricing.basePrice'] = { ...query['pricing.basePrice'], $lte: parseFloat(maxPrice) };

    // Pagination
    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    // Sort options
    let sortOptions = {};
    if (sortBy === 'price') {
      sortOptions['pricing.basePrice'] = 1;
    } else if (sortBy === 'rating') {
      sortOptions['stats.rating.average'] = -1;
    } else if (sortBy === 'newest') {
      sortOptions.createdAt = -1;
    } else {
      // Default: relevance (text score)
      sortOptions = { score: { $meta: 'textScore' } };
    }

    const [activities, totalActivities] = await Promise.all([
      Activity.find(query)
        .populate('providerId', 'name email companyName rating')
        .sort(sortOptions)
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
    console.error('Search activities error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while searching activities'
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