const express = require('express');
const { body, query, param } = require('express-validator');
const {
  createActivity,
  getActivities,
  getActivityById,
  updateActivity,
  deleteActivity,
  toggleActivityStatus,
  getProviderActivities,
  searchActivities,
  getActivityStats
} = require('../controllers/activityController');
const { authenticate, authorize, optionalAuth } = require('../middleware/auth');
const { handleValidationErrors, validateObjectId } = require('../middleware/validation');

const router = express.Router();

// Validation rules for activity creation
const createActivityValidation = [
  body('title')
    .trim()
    .notEmpty()
    .withMessage('Title is required')
    .isLength({ min: 3, max: 200 })
    .withMessage('Title must be between 3 and 200 characters'),
  
  body('description')
    .trim()
    .notEmpty()
    .withMessage('Description is required')
    .isLength({ min: 10, max: 2000 })
    .withMessage('Description must be between 10 and 2000 characters'),
  
  body('shortDescription')
    .optional()
    .trim()
    .isLength({ max: 300 })
    .withMessage('Short description cannot exceed 300 characters'),
  
  body('category')
    .notEmpty()
    .withMessage('Category is required')
    .isIn(['realEstate', 'airTravel', 'transport', 'lifestyle', 'events', 'security', 'corporate'])
    .withMessage('Invalid category'),
  
  body('subCategory')
    .optional()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Sub-category cannot exceed 100 characters'),
  
  body('tags')
    .optional()
    .isArray()
    .withMessage('Tags must be an array'),
  
  body('tags.*')
    .optional()
    .trim()
    .isLength({ min: 1, max: 50 })
    .withMessage('Each tag must be between 1 and 50 characters'),
  
  // Location validation
  body('location.city')
    .notEmpty()
    .withMessage('City is required')
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('City must be between 1 and 100 characters'),
  
  body('location.country')
    .notEmpty()
    .withMessage('Country is required')
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('Country must be between 1 and 100 characters'),
  
  body('location.address')
    .optional()
    .trim()
    .isLength({ max: 200 })
    .withMessage('Address cannot exceed 200 characters'),
  
  body('location.coordinates.lat')
    .optional()
    .isFloat({ min: -90, max: 90 })
    .withMessage('Latitude must be between -90 and 90'),
  
  body('location.coordinates.lng')
    .optional()
    .isFloat({ min: -180, max: 180 })
    .withMessage('Longitude must be between -180 and 180'),
  
  // Pricing validation
  body('pricing.basePrice')
    .notEmpty()
    .withMessage('Base price is required')
    .isFloat({ min: 0 })
    .withMessage('Base price must be a positive number'),
  
  body('pricing.currency')
    .optional()
    .isIn(['EUR', 'USD', 'GBP'])
    .withMessage('Currency must be EUR, USD, or GBP'),
  
  body('pricing.priceType')
    .optional()
    .isIn(['fixed', 'per_hour', 'per_day', 'per_person', 'custom'])
    .withMessage('Invalid price type'),
  
  body('pricing.priceDetails')
    .optional()
    .trim()
    .isLength({ max: 300 })
    .withMessage('Price details cannot exceed 300 characters'),
  
  // Capacity validation
  body('capacity.min')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Minimum capacity must be at least 1'),
  
  body('capacity.max')
    .notEmpty()
    .withMessage('Maximum capacity is required')
    .isInt({ min: 1 })
    .withMessage('Maximum capacity must be at least 1'),
  
  // Duration validation
  body('duration.value')
    .notEmpty()
    .withMessage('Duration value is required')
    .isFloat({ min: 0.5 })
    .withMessage('Duration must be at least 0.5'),
  
  body('duration.unit')
    .optional()
    .isIn(['hours', 'days', 'weeks'])
    .withMessage('Duration unit must be hours, days, or weeks'),
  
  // Features validation
  body('features')
    .optional()
    .isArray()
    .withMessage('Features must be an array'),
  
  body('features.*')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('Each feature must be between 1 and 100 characters')
];

// Validation rules for activity updates
const updateActivityValidation = [
  body('title')
    .optional()
    .trim()
    .isLength({ min: 3, max: 200 })
    .withMessage('Title must be between 3 and 200 characters'),
  
  body('description')
    .optional()
    .trim()
    .isLength({ min: 10, max: 2000 })
    .withMessage('Description must be between 10 and 2000 characters'),
  
  body('shortDescription')
    .optional()
    .trim()
    .isLength({ max: 300 })
    .withMessage('Short description cannot exceed 300 characters'),
  
  body('category')
    .optional()
    .isIn(['realEstate', 'airTravel', 'transport', 'lifestyle', 'events', 'security', 'corporate'])
    .withMessage('Invalid category'),
  
  body('status')
    .optional()
    .isIn(['draft', 'pending', 'active', 'paused', 'rejected', 'archived'])
    .withMessage('Invalid status'),
  
  body('pricing.basePrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Base price must be a positive number'),
  
  body('capacity.max')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Maximum capacity must be at least 1'),
  
  body('duration.value')
    .optional()
    .isFloat({ min: 0.5 })
    .withMessage('Duration must be at least 0.5'),
  
  body('featured')
    .optional()
    .isBoolean()
    .withMessage('Featured must be a boolean value'),
  
  body('priority')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Priority must be a non-negative integer')
];

// Validation for query parameters
const getActivitiesValidation = [
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  
  query('limit')
    .optional()
    .isInt({ min: 1, max: 50 })
    .withMessage('Limit must be between 1 and 50'),
  
  query('category')
    .optional()
    .isIn(['realEstate', 'airTravel', 'transport', 'lifestyle', 'events', 'security', 'corporate'])
    .withMessage('Invalid category'),
  
  query('status')
    .optional()
    .isIn(['draft', 'pending', 'active', 'paused', 'rejected', 'archived'])
    .withMessage('Invalid status'),
  
  query('minPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Minimum price must be a positive number'),
  
  query('maxPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Maximum price must be a positive number'),
  
  query('featured')
    .optional()
    .isIn(['true', 'false'])
    .withMessage('Featured must be true or false'),
  
  query('search')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('Search term must be between 1 and 100 characters'),
  
  query('sortBy')
    .optional()
    .isIn(['createdAt', 'title', 'pricing.basePrice', 'stats.rating.average', 'stats.views'])
    .withMessage('Invalid sort field'),
  
  query('sortOrder')
    .optional()
    .isIn(['asc', 'desc'])
    .withMessage('Sort order must be asc or desc')
];

// Search validation
const searchActivitiesValidation = [
  query('q')
    .notEmpty()
    .withMessage('Search term is required')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Search term must be between 2 and 100 characters'),
  
  query('category')
    .optional()
    .isIn(['realEstate', 'airTravel', 'transport', 'lifestyle', 'events', 'security', 'corporate'])
    .withMessage('Invalid category'),
  
  query('city')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('City must be between 1 and 100 characters'),
  
  query('minPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Minimum price must be a positive number'),
  
  query('maxPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Maximum price must be a positive number'),
  
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  
  query('limit')
    .optional()
    .isInt({ min: 1, max: 50 })
    .withMessage('Limit must be between 1 and 50')
];

// @route   POST /api/activities
// @desc    Create new activity
// @access  Private (Providers only)
router.post('/', 
  authenticate, 
  authorize(['prestataire', 'admin']),
  createActivityValidation, 
  handleValidationErrors, 
  createActivity
);

// @route   GET /api/activities
// @desc    Get all activities with filtering and pagination
// @access  Public/Private (different data based on auth)
router.get('/', 
  optionalAuth,
  getActivitiesValidation, 
  handleValidationErrors, 
  getActivities
);

// @route   GET /api/activities/search
// @desc    Search activities
// @access  Public
router.get('/search', 
  searchActivitiesValidation, 
  handleValidationErrors, 
  searchActivities
);

// @route   GET /api/activities/stats
// @desc    Get activity statistics
// @access  Private (Providers and Admin)
router.get('/stats', 
  authenticate, 
  authorize(['prestataire', 'admin']), 
  getActivityStats
);

// @route   GET /api/activities/provider/:providerId
// @desc    Get activities by provider
// @access  Private (Owner or Admin)
router.get('/provider/:providerId', 
  authenticate,
  param('providerId').isMongoId().withMessage('Invalid provider ID'),
  handleValidationErrors,
  getProviderActivities
);

// @route   GET /api/activities/featured
// @desc    Get featured activities
// @access  Public
router.get('/featured', 
  async (req, res) => {
    try {
      const featuredActivities = await Activity.find({ 
        featured: true, 
        status: 'active' 
      })
        .populate('providerId', 'name email companyName')
        .sort({ priority: -1, createdAt: -1 })
        .limit(10)
        .lean();

      res.status(200).json({
        success: true,
        data: featuredActivities,
        message: 'Featured activities retrieved successfully'
      });

    } catch (error) {
      console.error('Get featured activities error:', error);
      res.status(500).json({
        success: false,
        message: 'Server error while fetching featured activities'
      });
    }
  }
);

// @route   GET /api/activities/:id
// @desc    Get single activity by ID
// @access  Public/Private
router.get('/:id', 
  optionalAuth,
  validateObjectId('id'),
  getActivityById
);

// @route   PUT /api/activities/:id
// @desc    Update activity
// @access  Private (Owner or Admin)
router.put('/:id', 
  authenticate,
  validateObjectId('id'),
  updateActivityValidation, 
  handleValidationErrors,
  updateActivity
);

// @route   PATCH /api/activities/:id/toggle-status
// @desc    Toggle activity status (active/paused)
// @access  Private (Owner or Admin)
router.patch('/:id/toggle-status', 
  authenticate,
  validateObjectId('id'),
  toggleActivityStatus
);

// @route   DELETE /api/activities/:id
// @desc    Delete activity
// @access  Private (Owner or Admin)
router.delete('/:id', 
  authenticate,
  validateObjectId('id'),
  deleteActivity
);

module.exports = router;