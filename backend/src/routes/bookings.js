const express = require('express');
const { body, query, param } = require('express-validator');
const {
  createBooking,
  getBookings,
  getBookingById,
  updateBookingStatus,
  cancelBooking,
  getUpcomingBookings,
  getBookingStats,
  addBookingReview
} = require('../controllers/bookingController');
const { authenticate, authorize } = require('../middleware/auth');
const { handleValidationErrors, validateObjectId } = require('../middleware/validation');

const router = express.Router();

// Validation rules for booking creation
const createBookingValidation = [
  body('activityId')
    .notEmpty()
    .withMessage('Activity ID is required')
    .isMongoId()
    .withMessage('Invalid activity ID'),
  
  // Booking date validation
  body('bookingDate.start')
    .notEmpty()
    .withMessage('Start date is required')
    .isISO8601()
    .withMessage('Start date must be a valid ISO date')
    .custom((value) => {
      const startDate = new Date(value);
      const now = new Date();
      if (startDate <= now) {
        throw new Error('Start date must be in the future');
      }
      return true;
    }),
  
  body('bookingDate.end')
    .notEmpty()
    .withMessage('End date is required')
    .isISO8601()
    .withMessage('End date must be a valid ISO date')
    .custom((value, { req }) => {
      const startDate = new Date(req.body.bookingDate.start);
      const endDate = new Date(value);
      if (endDate <= startDate) {
        throw new Error('End date must be after start date');
      }
      return true;
    }),
  
  // Participants validation
  body('participants.adults')
    .notEmpty()
    .withMessage('Number of adults is required')
    .isInt({ min: 1 })
    .withMessage('At least one adult is required'),
  
  body('participants.children')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Children count must be a non-negative number'),
  
  // Client info validation
  body('clientInfo.name')
    .notEmpty()
    .withMessage('Client name is required')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Name must be between 2 and 100 characters'),
  
  body('clientInfo.email')
    .notEmpty()
    .withMessage('Client email is required')
    .isEmail()
    .withMessage('Must be a valid email address')
    .normalizeEmail(),
  
  body('clientInfo.phone')
    .notEmpty()
    .withMessage('Client phone is required')
    .trim()
    .isLength({ min: 8, max: 20 })
    .withMessage('Phone must be between 8 and 20 characters'),
  
  body('clientInfo.emergencyContact.name')
    .optional()
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Emergency contact name must be between 2 and 100 characters'),
  
  body('clientInfo.emergencyContact.phone')
    .optional()
    .trim()
    .isLength({ min: 8, max: 20 })
    .withMessage('Emergency contact phone must be between 8 and 20 characters'),
  
  body('clientInfo.specialRequests')
    .optional()
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Special requests cannot exceed 1000 characters'),
  
  body('clientInfo.dietaryRequirements')
    .optional()
    .isArray()
    .withMessage('Dietary requirements must be an array'),
  
  body('clientInfo.accessibilityNeeds')
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage('Accessibility needs cannot exceed 500 characters'),
  
  // Meeting point validation
  body('meetingPoint.location')
    .notEmpty()
    .withMessage('Meeting point location is required')
    .trim()
    .isLength({ min: 5, max: 200 })
    .withMessage('Meeting point location must be between 5 and 200 characters'),
  
  body('meetingPoint.coordinates.lat')
    .optional()
    .isFloat({ min: -90, max: 90 })
    .withMessage('Latitude must be between -90 and 90'),
  
  body('meetingPoint.coordinates.lng')
    .optional()
    .isFloat({ min: -180, max: 180 })
    .withMessage('Longitude must be between -180 and 180'),
  
  body('meetingPoint.instructions')
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage('Meeting point instructions cannot exceed 500 characters'),
  
  // Client notes validation
  body('clientNotes')
    .optional()
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Client notes cannot exceed 1000 characters'),
  
  // Extras validation
  body('extras')
    .optional()
    .isArray()
    .withMessage('Extras must be an array'),
  
  body('extras.*.name')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('Extra name must be between 1 and 100 characters'),
  
  body('extras.*.amount')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Extra amount must be a positive number'),
  
  body('extras.*.quantity')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Extra quantity must be at least 1')
];

// Validation for status updates
const updateBookingStatusValidation = [
  body('status')
    .notEmpty()
    .withMessage('Status is required')
    .isIn(['pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'refunded'])
    .withMessage('Invalid booking status'),
  
  body('notes')
    .optional()
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Notes cannot exceed 1000 characters')
];

// Validation for cancellation
const cancelBookingValidation = [
  body('reason')
    .optional()
    .trim()
    .isLength({ min: 1, max: 500 })
    .withMessage('Reason must be between 1 and 500 characters'),
  
  body('refundRequested')
    .optional()
    .isBoolean()
    .withMessage('Refund requested must be a boolean value')
];

// Validation for review
const addReviewValidation = [
  body('rating')
    .notEmpty()
    .withMessage('Rating is required')
    .isInt({ min: 1, max: 5 })
    .withMessage('Rating must be between 1 and 5'),
  
  body('comment')
    .optional()
    .trim()
    .isLength({ min: 1, max: 1000 })
    .withMessage('Comment must be between 1 and 1000 characters')
];

// Validation for query parameters
const getBookingsValidation = [
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  
  query('limit')
    .optional()
    .isInt({ min: 1, max: 50 })
    .withMessage('Limit must be between 1 and 50'),
  
  query('status')
    .optional()
    .isIn(['pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'refunded'])
    .withMessage('Invalid status'),
  
  query('clientId')
    .optional()
    .isMongoId()
    .withMessage('Invalid client ID'),
  
  query('providerId')
    .optional()
    .isMongoId()
    .withMessage('Invalid provider ID'),
  
  query('activityId')
    .optional()
    .isMongoId()
    .withMessage('Invalid activity ID'),
  
  query('startDate')
    .optional()
    .isISO8601()
    .withMessage('Start date must be a valid ISO date'),
  
  query('endDate')
    .optional()
    .isISO8601()
    .withMessage('End date must be a valid ISO date'),
  
  query('sortBy')
    .optional()
    .isIn(['createdAt', 'bookingDate.start', 'pricing.totalAmount', 'status'])
    .withMessage('Invalid sort field'),
  
  query('sortOrder')
    .optional()
    .isIn(['asc', 'desc'])
    .withMessage('Sort order must be asc or desc')
];

// Validation for upcoming bookings query
const getUpcomingValidation = [
  query('limit')
    .optional()
    .isInt({ min: 1, max: 20 })
    .withMessage('Limit must be between 1 and 20')
];

// @route   POST /api/bookings
// @desc    Create new booking
// @access  Private (Clients and Admin)
router.post('/', 
  authenticate, 
  authorize(['client', 'admin']),
  createBookingValidation, 
  handleValidationErrors, 
  createBooking
);

// @route   GET /api/bookings
// @desc    Get all bookings with filtering and pagination
// @access  Private
router.get('/', 
  authenticate,
  getBookingsValidation, 
  handleValidationErrors, 
  getBookings
);

// @route   GET /api/bookings/upcoming
// @desc    Get upcoming bookings for user
// @access  Private
router.get('/upcoming', 
  authenticate,
  getUpcomingValidation,
  handleValidationErrors,
  getUpcomingBookings
);

// @route   GET /api/bookings/stats
// @desc    Get booking statistics
// @access  Private
router.get('/stats', 
  authenticate, 
  getBookingStats
);

// @route   GET /api/bookings/:id
// @desc    Get single booking by ID
// @access  Private (Owner, Provider, or Admin)
router.get('/:id', 
  authenticate,
  validateObjectId('id'),
  getBookingById
);

// @route   PATCH /api/bookings/:id/status
// @desc    Update booking status
// @access  Private (Provider, Client for cancellation, or Admin)
router.patch('/:id/status', 
  authenticate,
  validateObjectId('id'),
  updateBookingStatusValidation, 
  handleValidationErrors,
  updateBookingStatus
);

// @route   PATCH /api/bookings/:id/cancel
// @desc    Cancel booking
// @access  Private (Client, Provider, or Admin)
router.patch('/:id/cancel', 
  authenticate,
  validateObjectId('id'),
  cancelBookingValidation, 
  handleValidationErrors,
  cancelBooking
);

// @route   POST /api/bookings/:id/review
// @desc    Add review to completed booking
// @access  Private (Client or Provider)
router.post('/:id/review', 
  authenticate,
  validateObjectId('id'),
  addReviewValidation, 
  handleValidationErrors,
  addBookingReview
);

module.exports = router;