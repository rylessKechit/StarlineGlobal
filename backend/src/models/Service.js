const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
  // Basic Info
  name: {
    type: String,
    required: [true, 'Service name is required'],
    trim: true,
    maxlength: [100, 'Service name cannot be more than 100 characters']
  },
  description: {
    type: String,
    required: [true, 'Service description is required'],
    trim: true,
    maxlength: [500, 'Description cannot be more than 500 characters']
  },
  shortDescription: {
    type: String,
    trim: true,
    maxlength: [150, 'Short description cannot be more than 150 characters']
  },
  
  // Category
  category: {
    type: String,
    enum: {
      values: ['airTravel', 'transport', 'realEstate', 'corporate'],
      message: 'Invalid service category'
    },
    required: [true, 'Service category is required']
  },
  
  // Service Details
  serviceType: {
    type: String,
    required: [true, 'Service type is required'],
    trim: true
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
      enum: ['fixed', 'per_hour', 'per_day', 'custom'],
      default: 'fixed'
    },
    isCustomQuote: {
      type: Boolean,
      default: false
    }
  },
  
  // Media
  icon: {
    type: String,
    required: [true, 'Service icon is required']
  },
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
  
  // Features & Details
  features: [{
    type: String,
    trim: true
  }],
  included: [{
    type: String,
    trim: true
  }],
  
  // Status & Display
  isActive: {
    type: Boolean,
    default: true
  },
  isFeatured: {
    type: Boolean,
    default: false
  },
  priority: {
    type: Number,
    default: 0
  },
  
  // Service Specific Fields
  serviceDetails: {
    // Pour Air Travel
    airTravelType: {
      type: String,
      enum: ['meetGreet', 'jetReservation', 'lounge']
    },
    
    // Pour Transport  
    transportType: {
      type: String,
      enum: ['miseDisposition', 'chauffeurVip']
    },
    
    // Pour Real Estate
    realEstateType: {
      type: String,
      enum: ['achat', 'location']
    },
    
    // Pour Corporate
    corporateType: {
      type: String,
      enum: ['evenement']
    }
  },
  
  // Statistics
  stats: {
    orders: {
      type: Number,
      default: 0
    },
    revenue: {
      type: Number,
      default: 0
    }
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes
serviceSchema.index({ category: 1, isActive: 1 });
serviceSchema.index({ isFeatured: 1, priority: -1 });
serviceSchema.index({ createdAt: -1 });

// Virtual pour le prix formaté
serviceSchema.virtual('formattedPrice').get(function() {
  const { basePrice, currency, priceType, isCustomQuote } = this.pricing;
  
  if (isCustomQuote) {
    return 'Sur devis';
  }
  
  const symbols = { EUR: '€', USD: '$', GBP: '£' };
  const symbol = symbols[currency] || currency;
  
  let suffix = '';
  switch(priceType) {
    case 'per_hour': suffix = '/h'; break;
    case 'per_day': suffix = '/jour'; break;
    case 'fixed': suffix = ''; break;
    default: suffix = '';
  }
  
  return `${basePrice}${symbol}${suffix}`;
});

// Static method to get featured services
serviceSchema.statics.getFeatured = function() {
  return this.find({ 
    isFeatured: true, 
    isActive: true 
  }).sort({ priority: -1, createdAt: -1 });
};

// Static method to get by category
serviceSchema.statics.getByCategory = function(category) {
  return this.find({ 
    category: category, 
    isActive: true 
  }).sort({ priority: -1, name: 1 });
};

module.exports = mongoose.model('Service', serviceSchema);