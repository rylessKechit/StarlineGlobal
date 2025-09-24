const express = require('express');
const router = express.Router();
const { query, body, param } = require('express-validator');
const {
  getServices,
  getFeaturedServices,
  getServiceById,
  createService,
  updateService,
  deleteService
} = require('../controllers/serviceController');
const { authenticate, authorize, optionalAuth } = require('../middleware/auth');
const { handleValidationErrors, validateObjectId } = require('../middleware/validation');

// Validation rules
const getServicesValidation = [
  query('category')
    .optional()
    .isIn(['airTravel', 'transport', 'realEstate', 'corporate'])
    .withMessage('Invalid category'),
  
  query('featured')
    .optional()
    .isIn(['true', 'false'])
    .withMessage('Featured must be true or false'),
  
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  
  query('limit')
    .optional()
    .isInt({ min: 1, max: 50 })
    .withMessage('Limit must be between 1 and 50')
];

const createServiceValidation = [
  body('name')
    .trim()
    .notEmpty()
    .withMessage('Service name is required')
    .isLength({ min: 2, max: 100 })
    .withMessage('Service name must be between 2 and 100 characters'),
  
  body('description')
    .trim()
    .notEmpty()
    .withMessage('Description is required')
    .isLength({ min: 10, max: 500 })
    .withMessage('Description must be between 10 and 500 characters'),
  
  body('category')
    .notEmpty()
    .withMessage('Category is required')
    .isIn(['airTravel', 'transport', 'realEstate', 'corporate'])
    .withMessage('Invalid category'),
  
  body('serviceType')
    .trim()
    .notEmpty()
    .withMessage('Service type is required'),
  
  body('pricing.basePrice')
    .isFloat({ min: 0 })
    .withMessage('Base price must be a positive number'),
  
  body('icon')
    .notEmpty()
    .withMessage('Service icon is required')
];

// @route   GET /api/services
// @desc    Get all services with filtering
// @access  Public
router.get('/', 
  getServicesValidation, 
  handleValidationErrors, 
  getServices
);

// @route   GET /api/services/featured
// @desc    Get featured services
// @access  Public
router.get('/featured', getFeaturedServices);

// @route   GET /api/services/:id
// @desc    Get single service by ID
// @access  Public
router.get('/:id', 
  validateObjectId('id'),
  getServiceById
);

// @route   POST /api/services
// @desc    Create new service (Admin only)
// @access  Private (Admin)
router.post('/', 
  authenticate, 
  authorize(['admin']),
  createServiceValidation, 
  handleValidationErrors, 
  createService
);

// @route   PUT /api/services/:id
// @desc    Update service (Admin only)
// @access  Private (Admin)
router.put('/:id', 
  authenticate,
  authorize(['admin']),
  validateObjectId('id'),
  createServiceValidation, 
  handleValidationErrors,
  updateService
);

// @route   DELETE /api/services/:id
// @desc    Delete service (Admin only)
// @access  Private (Admin)
router.delete('/:id', 
  authenticate,
  authorize(['admin']),
  validateObjectId('id'),
  deleteService
);

module.exports = router;