const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  // References
  clientId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Client is required']
  },
  providerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Provider is required']
  },
  activityId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Activity',
    required: [true, 'Activity is required']
  },
  
  // Booking Details
  bookingNumber: {
    type: String,
    unique: true,
    required: true
  },
  
  // Dates & Time
  bookingDate: {
    start: {
      type: Date,
      required: [true, 'Start date is required']
    },
    end: {
      type: Date,
      required: [true, 'End date is required']
    }
  },
  duration: {
    value: Number,
    unit: {
      type: String,
      enum: ['hours', 'days', 'weeks']
    }
  },
  
  // Participants
  participants: {
    adults: {
      type: Number,
      required: [true, 'Number of adults is required'],
      min: [1, 'At least one adult is required']
    },
    children: {
      type: Number,
      default: 0,
      min: [0, 'Children count cannot be negative']
    },
    total: {
      type: Number,
      required: true
    }
  },
  
  // Pricing & Payment
  pricing: {
    baseAmount: {
      type: Number,
      required: [true, 'Base amount is required'],
      min: [0, 'Amount cannot be negative']
    },
    extras: [{
      name: String,
      amount: Number,
      quantity: {
        type: Number,
        default: 1
      }
    }],
    discounts: [{
      name: String,
      amount: Number,
      type: {
        type: String,
        enum: ['fixed', 'percentage'],
        default: 'fixed'
      }
    }],
    taxes: {
      amount: Number,
      rate: Number // percentage
    },
    subtotal: {
      type: Number,
      required: true
    },
    totalAmount: {
      type: Number,
      required: [true, 'Total amount is required'],
      min: [0, 'Total amount cannot be negative']
    },
    currency: {
      type: String,
      default: 'EUR',
      enum: ['EUR', 'USD', 'GBP']
    }
  },
  
  // Payment Information
  payment: {
    status: {
      type: String,
      enum: ['pending', 'paid', 'partially_paid', 'refunded', 'failed'],
      default: 'pending'
    },
    method: {
      type: String,
      enum: ['card', 'transfer', 'paypal', 'crypto', 'cash']
    },
    transactionId: String,
    paidAmount: {
      type: Number,
      default: 0
    },
    paidAt: Date,
    refundAmount: {
      type: Number,
      default: 0
    },
    refundedAt: Date,
    refundReason: String
  },
  
  // Status & Workflow
  status: {
    type: String,
    enum: {
      values: ['pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'refunded'],
      message: 'Invalid booking status'
    },
    default: 'pending'
  },
  
  // Communication
  clientNotes: {
    type: String,
    trim: true,
    maxlength: [1000, 'Client notes cannot exceed 1000 characters']
  },
  providerNotes: {
    type: String,
    trim: true,
    maxlength: [1000, 'Provider notes cannot exceed 1000 characters']
  },
  adminNotes: {
    type: String,
    trim: true,
    maxlength: [1000, 'Admin notes cannot exceed 1000 characters']
  },
  
  // Client Information
  clientInfo: {
    name: {
      type: String,
      required: true,
      trim: true
    },
    email: {
      type: String,
      required: true,
      lowercase: true
    },
    phone: {
      type: String,
      required: true,
      trim: true
    },
    emergencyContact: {
      name: String,
      phone: String,
      relationship: String
    },
    specialRequests: String,
    dietaryRequirements: [String],
    accessibilityNeeds: String
  },
  
  // Meeting Point & Logistics
  meetingPoint: {
    location: {
      type: String,
      required: true
    },
    coordinates: {
      lat: Number,
      lng: Number
    },
    instructions: String,
    contactPerson: {
      name: String,
      phone: String
    }
  },
  
  // Cancellation
  cancellation: {
    cancelledBy: {
      type: String,
      enum: ['client', 'provider', 'admin']
    },
    cancelledAt: Date,
    reason: String,
    refundPercentage: {
      type: Number,
      min: 0,
      max: 100
    },
    fees: {
      amount: Number,
      description: String
    }
  },
  
  // Timeline & History
  timeline: [{
    action: {
      type: String,
      required: true
    },
    performedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    performedAt: {
      type: Date,
      default: Date.now
    },
    details: String,
    metadata: mongoose.Schema.Types.Mixed
  }],
  
  // Notifications
  notifications: {
    clientReminders: [{
      type: {
        type: String,
        enum: ['24h', '2h', 'custom']
      },
      sentAt: Date,
      message: String
    }],
    providerNotifications: [{
      type: String,
      sentAt: Date,
      message: String
    }]
  },
  
  // Review & Feedback
  review: {
    clientReview: {
      rating: {
        type: Number,
        min: 1,
        max: 5
      },
      comment: String,
      submittedAt: Date
    },
    providerReview: {
      rating: {
        type: Number,
        min: 1,
        max: 5
      },
      comment: String,
      submittedAt: Date
    }
  },
  
  // System Fields
  version: {
    type: Number,
    default: 1
  },
  lastModifiedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes for performance
bookingSchema.index({ clientId: 1, status: 1 });
bookingSchema.index({ providerId: 1, status: 1 });
bookingSchema.index({ activityId: 1 });
bookingSchema.index({ bookingNumber: 1 });
bookingSchema.index({ 'bookingDate.start': 1, 'bookingDate.end': 1 });
bookingSchema.index({ status: 1, createdAt: -1 });
bookingSchema.index({ 'payment.status': 1 });

// Virtual for booking duration in hours
bookingSchema.virtual('durationInHours').get(function() {
  if (this.bookingDate.start && this.bookingDate.end) {
    return Math.ceil((this.bookingDate.end - this.bookingDate.start) / (1000 * 60 * 60));
  }
  return 0;
});

// Virtual for time until booking
bookingSchema.virtual('timeUntilBooking').get(function() {
  if (this.bookingDate.start) {
    return this.bookingDate.start - new Date();
  }
  return null;
});

// Virtual for is upcoming
bookingSchema.virtual('isUpcoming').get(function() {
  return this.bookingDate.start > new Date() && ['confirmed', 'in_progress'].includes(this.status);
});

// Virtual for can be cancelled
bookingSchema.virtual('canBeCancelled').get(function() {
  const hoursUntilBooking = this.timeUntilBooking / (1000 * 60 * 60);
  return ['pending', 'confirmed'].includes(this.status) && hoursUntilBooking > 24;
});

// Virtual for formatted total
bookingSchema.virtual('formattedTotal').get(function() {
  const symbols = { EUR: '€', USD: '$', GBP: '£' };
  const symbol = symbols[this.pricing.currency] || this.pricing.currency;
  return `${this.pricing.totalAmount}${symbol}`;
});

// Pre-save middleware to generate booking number
bookingSchema.pre('save', async function(next) {
  if (this.isNew) {
    // Generate booking number: BK-YYYY-NNNNNN
    const year = new Date().getFullYear();
    const lastBooking = await this.constructor.findOne(
      { bookingNumber: new RegExp(`^BK-${year}-`) },
      {},
      { sort: { bookingNumber: -1 } }
    );
    
    let nextNumber = 1;
    if (lastBooking && lastBooking.bookingNumber) {
      const lastNumber = parseInt(lastBooking.bookingNumber.split('-')[2]);
      nextNumber = lastNumber + 1;
    }
    
    this.bookingNumber = `BK-${year}-${nextNumber.toString().padStart(6, '0')}`;
    
    // Calculate total participants
    this.participants.total = this.participants.adults + this.participants.children;
    
    // Add initial timeline entry
    this.timeline.push({
      action: 'booking_created',
      performedBy: this.clientId,
      details: 'Booking created by client'
    });
  }
  
  // Calculate subtotal and total if modified
  if (this.isModified('pricing')) {
    this.calculateTotals();
  }
  
  next();
});

// Method to calculate totals
bookingSchema.methods.calculateTotals = function() {
  let subtotal = this.pricing.baseAmount;
  
  // Add extras
  if (this.pricing.extras && this.pricing.extras.length > 0) {
    subtotal += this.pricing.extras.reduce((sum, extra) => {
      return sum + (extra.amount * (extra.quantity || 1));
    }, 0);
  }
  
  // Apply discounts
  if (this.pricing.discounts && this.pricing.discounts.length > 0) {
    this.pricing.discounts.forEach(discount => {
      if (discount.type === 'percentage') {
        subtotal -= (subtotal * discount.amount / 100);
      } else {
        subtotal -= discount.amount;
      }
    });
  }
  
  this.pricing.subtotal = Math.max(0, subtotal);
  
  // Add taxes
  let total = this.pricing.subtotal;
  if (this.pricing.taxes && this.pricing.taxes.rate) {
    this.pricing.taxes.amount = total * (this.pricing.taxes.rate / 100);
    total += this.pricing.taxes.amount;
  }
  
  this.pricing.totalAmount = Math.round(total * 100) / 100; // Round to 2 decimal places
};

// Method to add timeline entry
bookingSchema.methods.addTimelineEntry = function(action, performedBy, details, metadata) {
  this.timeline.push({
    action,
    performedBy,
    details,
    metadata,
    performedAt: new Date()
  });
  return this.save();
};

// Method to update status
bookingSchema.methods.updateStatus = function(newStatus, performedBy, notes) {
  const oldStatus = this.status;
  this.status = newStatus;
  this.lastModifiedBy = performedBy;
  
  this.addTimelineEntry(
    `status_changed_to_${newStatus}`,
    performedBy,
    `Status changed from ${oldStatus} to ${newStatus}`,
    { oldStatus, newStatus, notes }
  );
  
  return this.save();
};

// Method to cancel booking
bookingSchema.methods.cancelBooking = function(cancelledBy, reason, refundPercentage = 0) {
  this.status = 'cancelled';
  this.cancellation = {
    cancelledBy,
    cancelledAt: new Date(),
    reason,
    refundPercentage
  };
  
  if (refundPercentage > 0) {
    const refundAmount = (this.pricing.totalAmount * refundPercentage) / 100;
    this.payment.refundAmount = refundAmount;
  }
  
  this.addTimelineEntry(
    'booking_cancelled',
    cancelledBy,
    `Booking cancelled: ${reason}`,
    { refundPercentage }
  );
  
  return this.save();
};

// Method to confirm booking
bookingSchema.methods.confirmBooking = function(confirmedBy) {
  this.status = 'confirmed';
  this.lastModifiedBy = confirmedBy;
  
  this.addTimelineEntry(
    'booking_confirmed',
    confirmedBy,
    'Booking confirmed by provider'
  );
  
  return this.save();
};

// Static method to find upcoming bookings
bookingSchema.statics.findUpcoming = function(userId, userRole) {
  const userField = userRole === 'client' ? 'clientId' : 'providerId';
  const query = {
    [userField]: userId,
    'bookingDate.start': { $gte: new Date() },
    status: { $in: ['confirmed', 'in_progress'] }
  };
  
  return this.find(query)
    .populate('activityId', 'title images location')
    .populate('clientId', 'name email phone')
    .populate('providerId', 'name email phone companyName')
    .sort({ 'bookingDate.start': 1 });
};

// Static method to find bookings by date range
bookingSchema.statics.findByDateRange = function(startDate, endDate, filters = {}) {
  const query = {
    $or: [
      {
        'bookingDate.start': {
          $gte: startDate,
          $lte: endDate
        }
      },
      {
        'bookingDate.end': {
          $gte: startDate,
          $lte: endDate
        }
      },
      {
        $and: [
          { 'bookingDate.start': { $lte: startDate } },
          { 'bookingDate.end': { $gte: endDate } }
        ]
      }
    ]
  };
  
  // Apply additional filters
  if (filters.status) query.status = filters.status;
  if (filters.providerId) query.providerId = filters.providerId;
  if (filters.clientId) query.clientId = filters.clientId;
  if (filters.activityId) query.activityId = filters.activityId;
  
  return this.find(query);
};

module.exports = mongoose.model('Booking', bookingSchema);