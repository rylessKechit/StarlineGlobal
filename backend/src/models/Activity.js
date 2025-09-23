const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema({
  // Basic Info
  title: {
    type: String,
    required: [true, 'Activity title is required'],
    trim: true,
    maxlength: [200, 'Title cannot be more than 200 characters']
  },
  description: {
    type: String,
    required: [true, 'Activity description is required'],
    trim: true,
    maxlength: [2000, 'Description cannot be more than 2000 characters']
  },
  shortDescription: {
    type: String,
    trim: true,
    maxlength: [300, 'Short description cannot be more than 300 characters']
  },
  
  // Category & Type
  category: {
    type: String,
    enum: {
      values: ['realEstate', 'airTravel', 'transport', 'lifestyle', 'events', 'security', 'corporate'],
      message: 'Invalid activity category'
    },
    required: [true, 'Activity category is required']
  },
  subCategory: {
    type: String,
    trim: true
  },
  tags: [{
    type: String,
    trim: true
  }],
  
  // Provider Info
  providerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Provider is required']
  },
  providerName: {
    type: String,
    required: true
  },
  companyName: {
    type: String,
    trim: true
  },
  
  // Location
  location: {
    city: {
      type: String,
      required: [true, 'City is required'],
      trim: true
    },
    country: {
      type: String,
      required: [true, 'Country is required'],
      trim: true
    },
    address: {
      type: String,
      trim: true
    },
    coordinates: {
      lat: Number,
      lng: Number
    }
  },
  
  // Pricing
  pricing: {
    basePrice: {
      type: Number,
      required: [true, 'Base price is required'],
      min: [0, 'Price cannot be negative']
    },
    currency: {
      type: String,
      default: 'EUR',
      enum: ['EUR', 'USD', 'GBP']
    },
    priceType: {
      type: String,
      enum: ['fixed', 'per_hour', 'per_day', 'per_person', 'custom'],
      default: 'fixed'
    },
    priceDetails: {
      type: String,
      trim: true
    }
  },
  
  // Capacity & Duration
  capacity: {
    min: {
      type: Number,
      default: 1,
      min: [1, 'Minimum capacity must be at least 1']
    },
    max: {
      type: Number,
      required: [true, 'Maximum capacity is required'],
      min: [1, 'Maximum capacity must be at least 1']
    }
  },
  duration: {
    value: {
      type: Number,
      required: [true, 'Duration value is required']
    },
    unit: {
      type: String,
      enum: ['hours', 'days', 'weeks'],
      default: 'hours'
    }
  },
  
  // Availability
  availability: {
    isActive: {
      type: Boolean,
      default: true
    },
    schedule: {
      monday: { available: Boolean, hours: String },
      tuesday: { available: Boolean, hours: String },
      wednesday: { available: Boolean, hours: String },
      thursday: { available: Boolean, hours: String },
      friday: { available: Boolean, hours: String },
      saturday: { available: Boolean, hours: String },
      sunday: { available: Boolean, hours: String }
    },
    blackoutDates: [{
      start: Date,
      end: Date,
      reason: String
    }],
    advanceBooking: {
      type: Number,
      default: 24 // hours in advance required
    }
  },
  
  // Media
  images: [{
    url: {
      type: String,
      required: true
    },
    alt: String,
    isPrimary: {
      type: Boolean,
      default: false
    }
  }],
  videos: [{
    url: String,
    title: String,
    duration: Number
  }],
  
  // Features & Amenities
  features: [{
    type: String,
    trim: true
  }],
  amenities: [{
    name: String,
    included: {
      type: Boolean,
      default: true
    },
    additionalCost: Number
  }],
  
  // Requirements & Restrictions
  requirements: {
    ageRestriction: {
      min: Number,
      max: Number
    },
    skills: [{
      name: String,
      level: {
        type: String,
        enum: ['beginner', 'intermediate', 'advanced']
      }
    }],
    equipment: [{
      name: String,
      provided: Boolean,
      required: Boolean
    }],
    dress_code: String,
    medical: String
  },
  
  // Status & Moderation
  status: {
    type: String,
    enum: {
      values: ['draft', 'pending', 'active', 'paused', 'rejected', 'archived'],
      message: 'Invalid activity status'
    },
    default: 'draft'
  },
  moderationNotes: [{
    note: String,
    by: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    date: {
      type: Date,
      default: Date.now
    }
  }],
  
  // Statistics
  stats: {
    views: {
      type: Number,
      default: 0
    },
    bookings: {
      total: {
        type: Number,
        default: 0
      },
      completed: {
        type: Number,
        default: 0
      },
      cancelled: {
        type: Number,
        default: 0
      }
    },
    rating: {
      average: {
        type: Number,
        default: 0,
        min: 0,
        max: 5
      },
      count: {
        type: Number,
        default: 0
      }
    },
    revenue: {
      total: {
        type: Number,
        default: 0
      },
      thisMonth: {
        type: Number,
        default: 0
      }
    }
  },
  
  // SEO & Marketing
  seo: {
    metaTitle: String,
    metaDescription: String,
    keywords: [String]
  },
  featured: {
    type: Boolean,
    default: false
  },
  priority: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes for performance
activitySchema.index({ providerId: 1, status: 1 });
activitySchema.index({ category: 1, status: 1 });
activitySchema.index({ 'location.city': 1, 'location.country': 1 });
activitySchema.index({ 'pricing.basePrice': 1 });
activitySchema.index({ featured: 1, priority: -1 });
activitySchema.index({ createdAt: -1 });
activitySchema.index({ 'stats.rating.average': -1 });

// Text search index
activitySchema.index({
  title: 'text',
  description: 'text',
  'location.city': 'text',
  tags: 'text'
});

// Virtual for primary image
activitySchema.virtual('primaryImage').get(function() {
  const primaryImg = this.images.find(img => img.isPrimary);
  return primaryImg || (this.images.length > 0 ? this.images[0] : null);
});

// Virtual for availability status
activitySchema.virtual('isAvailable').get(function() {
  return this.status === 'active' && this.availability.isActive;
});

// Virtual for formatted price
activitySchema.virtual('formattedPrice').get(function() {
  const { basePrice, currency, priceType } = this.pricing;
  const symbols = { EUR: '€', USD: '$', GBP: '£' };
  const symbol = symbols[currency] || currency;
  
  let suffix = '';
  switch(priceType) {
    case 'per_hour': suffix = '/h'; break;
    case 'per_day': suffix = '/jour'; break;
    case 'per_person': suffix = '/pers'; break;
  }
  
  return `${basePrice}${symbol}${suffix}`;
});

// Method to increment views
activitySchema.methods.incrementViews = function() {
  this.stats.views += 1;
  return this.save();
};

// Method to update rating
activitySchema.methods.updateRating = function(newRating) {
  const { average, count } = this.stats.rating;
  const newCount = count + 1;
  const newAverage = ((average * count) + newRating) / newCount;
  
  this.stats.rating.average = Math.round(newAverage * 10) / 10;
  this.stats.rating.count = newCount;
  
  return this.save();
};

// Method to check availability for a date range
activitySchema.methods.isAvailableForDates = function(startDate, endDate) {
  if (!this.isAvailable) return false;
  
  // Check against blackout dates
  const hasConflict = this.availability.blackoutDates.some(blackout => {
    return (startDate <= blackout.end && endDate >= blackout.start);
  });
  
  return !hasConflict;
};

// Static method to find by category
activitySchema.statics.findByCategory = function(category, options = {}) {
  const query = { category, status: 'active' };
  return this.find(query, null, options);
};

// Static method for search
activitySchema.statics.search = function(searchTerm, filters = {}) {
  const query = {
    $and: [
      { status: 'active' },
      {
        $or: [
          { $text: { $search: searchTerm } },
          { title: new RegExp(searchTerm, 'i') },
          { description: new RegExp(searchTerm, 'i') }
        ]
      }
    ]
  };
  
  // Apply filters
  if (filters.category) query.$and.push({ category: filters.category });
  if (filters.city) query.$and.push({ 'location.city': new RegExp(filters.city, 'i') });
  if (filters.minPrice) query.$and.push({ 'pricing.basePrice': { $gte: filters.minPrice } });
  if (filters.maxPrice) query.$and.push({ 'pricing.basePrice': { $lte: filters.maxPrice } });
  
  return this.find(query);
};

// Pre-save middleware
activitySchema.pre('save', function(next) {
  // Ensure only one primary image
  if (this.images && this.images.length > 0) {
    const primaryImages = this.images.filter(img => img.isPrimary);
    if (primaryImages.length > 1) {
      // Keep only the first one as primary
      this.images.forEach((img, index) => {
        img.isPrimary = index === 0;
      });
    } else if (primaryImages.length === 0) {
      // Set first image as primary
      this.images[0].isPrimary = true;
    }
  }
  
  // Update provider name from User if needed
  if (this.isModified('providerId')) {
    // This will be handled in the controller
  }
  
  next();
});

// Pre-remove middleware
activitySchema.pre('remove', async function(next) {
  // Clean up related bookings, reviews, etc.
  // await this.model('Booking').deleteMany({ activityId: this._id });
  // await this.model('Review').deleteMany({ activityId: this._id });
  next();
});

module.exports = mongoose.model('Activity', activitySchema);