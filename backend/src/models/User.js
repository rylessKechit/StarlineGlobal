const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  // Basic Info
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true,
    maxlength: [100, 'Name cannot be more than 100 characters']
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    match: [
      /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      'Please enter a valid email'
    ]
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [6, 'Password must be at least 6 characters'],
    select: false // Don't include password in queries by default
  },
  phone: {
    type: String,
    trim: true,
    maxlength: [20, 'Phone number cannot be more than 20 characters']
  },
  
  // Role & Status
  role: {
    type: String,
    enum: {
      values: ['client', 'prestataire', 'admin'],
      message: 'Role must be either client, prestataire, or admin'
    },
    default: 'client'
  },
  status: {
    type: String,
    enum: {
      values: ['active', 'pending', 'suspended', 'inactive'],
      message: 'Status must be active, pending, suspended, or inactive'
    },
    default: 'pending'
  },
  
  // Profile
  avatar: {
    type: String,
    default: null
  },
  location: {
    type: String,
    trim: true
  },
  
  // Client specific fields
  totalSpent: {
    type: Number,
    default: 0,
    min: [0, 'Total spent cannot be negative']
  },
  favoriteDriver: {
    type: String,
    trim: true
  },
  
  // Provider specific fields
  companyName: {
    type: String,
    trim: true,
    maxlength: [150, 'Company name cannot be more than 150 characters']
  },
  totalRevenue: {
    type: Number,
    default: 0,
    min: [0, 'Total revenue cannot be negative']
  },
  rating: {
    type: Number,
    default: 0,
    min: [0, 'Rating cannot be less than 0'],
    max: [5, 'Rating cannot be more than 5']
  },
  reviewsCount: {
    type: Number,
    default: 0,
    min: [0, 'Reviews count cannot be negative']
  },
  
  // Statistics
  totalBookings: {
    type: Number,
    default: 0,
    min: [0, 'Total bookings cannot be negative']
  },
  
  // Verification & Security
  emailVerified: {
    type: Boolean,
    default: false
  },
  verificationToken: String,
  resetPasswordToken: String,
  resetPasswordExpires: Date,
  lastLogin: {
    type: Date,
    default: null
  },
  
  // Metadata
  memberSince: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes for performance
userSchema.index({ email: 1 });
userSchema.index({ role: 1, status: 1 });
userSchema.index({ createdAt: -1 });

// Virtual for full profile
userSchema.virtual('isProvider').get(function() {
  return this.role === 'prestataire';
});

userSchema.virtual('isClient').get(function() {
  return this.role === 'client';
});

userSchema.virtual('isAdmin').get(function() {
  return this.role === 'admin';
});

// Pre-save middleware to hash password
userSchema.pre('save', async function(next) {
  // Only hash password if it has been modified
  if (!this.isModified('password')) {
    return next();
  }
  
  try {
    // Hash password with cost of 12
    this.password = await bcrypt.hash(this.password, 12);
    next();
  } catch (error) {
    next(error);
  }
});

// Method to compare password
userSchema.methods.comparePassword = async function(candidatePassword) {
  try {
    return await bcrypt.compare(candidatePassword, this.password);
  } catch (error) {
    throw new Error('Password comparison failed');
  }
};

// Method to get public profile (without sensitive data)
userSchema.methods.getPublicProfile = function() {
  const user = this.toObject();
  delete user.password;
  delete user.verificationToken;
  delete user.resetPasswordToken;
  delete user.resetPasswordExpires;
  return user;
};

// Static method to find user by email
userSchema.statics.findByEmail = function(email) {
  return this.findOne({ email: email.toLowerCase() });
};

// Pre-remove middleware to clean up related data
userSchema.pre('remove', async function(next) {
  // Here you can add cleanup logic for related documents
  // Example: await this.model('Booking').deleteMany({ userId: this._id });
  next();
});

module.exports = mongoose.model('User', userSchema);