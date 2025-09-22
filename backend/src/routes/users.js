const express = require('express');
const { body, query } = require('express-validator');
const {
  getAllUsers,
  getUserById,
  updateUser,
  toggleUserStatus,
  deleteUser,
  getUserStats
} = require('../controllers/userController');
const { authenticate, authorize, authorizeOwnerOrAdmin } = require('../middleware/auth');
const { handleValidationErrors, validateObjectId } = require('../middleware/validation');

const router = express.Router();

// Validation rules for user updates
const updateUserValidation = [
  body('name')
    .optional()
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Name must be between 2 and 100 characters'),
  
  body('email')
    .optional()
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address'),
  
  body('phone')
    .optional()
    .isMobilePhone('any')
    .withMessage('Please provide a valid phone number'),
  
  body('role')
    .optional()
    .isIn(['client', 'prestataire', 'admin'])
    .withMessage('Role must be client, prestataire, or admin'),
  
  body('status')
    .optional()
    .isIn(['active', 'pending', 'suspended', 'inactive'])
    .withMessage('Status must be active, pending, suspended, or inactive'),
  
  body('location')
    .optional()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Location cannot be more than 100 characters'),
  
  body('companyName')
    .optional()
    .trim()
    .isLength({ max: 150 })
    .withMessage('Company name cannot be more than 150 characters')
];

// Validation rules for query parameters
const getUsersQueryValidation = [
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit must be between 1 and 100'),
  
  query('role')
    .optional()
    .isIn(['client', 'prestataire', 'admin'])
    .withMessage('Role must be client, prestataire, or admin'),
  
  query('status')
    .optional()
    .isIn(['active', 'pending', 'suspended', 'inactive'])
    .withMessage('Status must be active, pending, suspended, or inactive'),
  
  query('search')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('Search term must be between 1 and 100 characters')
];

// @route   GET /api/users
// @desc    Get all users with filtering and pagination
// @access  Private (Admin only)
router.get('/', 
  authenticate, 
  authorize('admin'), 
  getUsersQueryValidation, 
  handleValidationErrors, 
  getAllUsers
);

// @route   GET /api/users/stats
// @desc    Get user statistics
// @access  Private (Admin only)
router.get('/stats', 
  authenticate, 
  authorize('admin'), 
  getUserStats
);

// @route   GET /api/users/:id
// @desc    Get user by ID
// @access  Private (Owner or Admin)
router.get('/:id', 
  authenticate, 
  validateObjectId('id'),
  authorizeOwnerOrAdmin, 
  getUserById
);

// @route   PUT /api/users/:id
// @desc    Update user
// @access  Private (Admin only for role/status changes, Owner for profile)
router.put('/:id', 
  authenticate, 
  validateObjectId('id'),
  updateUserValidation, 
  handleValidationErrors,
  // Custom middleware to check permissions based on what's being updated
  (req, res, next) => {
    const { role, status } = req.body;
    
    // If changing role or status, require admin privileges
    if (role || status) {
      if (req.user.role !== 'admin') {
        return res.status(403).json({
          success: false,
          message: 'Admin privileges required to change role or status'
        });
      }
    } else {
      // For profile updates, allow owner or admin
      const userId = req.params.id;
      if (req.user.role !== 'admin' && req.user._id.toString() !== userId) {
        return res.status(403).json({
          success: false,
          message: 'Access denied. You can only update your own profile.'
        });
      }
    }
    
    next();
  },
  updateUser
);

// @route   PATCH /api/users/:id/toggle-status
// @desc    Toggle user status (active/suspended)
// @access  Private (Admin only)
router.patch('/:id/toggle-status', 
  authenticate, 
  authorize('admin'),
  validateObjectId('id'),
  toggleUserStatus
);

// @route   DELETE /api/users/:id
// @desc    Delete user
// @access  Private (Admin only)
router.delete('/:id', 
  authenticate, 
  authorize('admin'),
  validateObjectId('id'),
  deleteUser
);

module.exports = router;