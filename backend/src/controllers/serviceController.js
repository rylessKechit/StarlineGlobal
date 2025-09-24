const Service = require('../models/Service');

// Get all services with filtering
const getServices = async (req, res) => {
  try {
    const {
      category,
      featured,
      page = 1,
      limit = 20
    } = req.query;

    // Build query
    const query = { isActive: true };

    if (category) query.category = category;
    if (featured === 'true') query.isFeatured = true;

    // Pagination
    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    // Execute query
    const [services, totalServices] = await Promise.all([
      Service.find(query)
        .sort({ priority: -1, name: 1 })
        .skip(skip)
        .limit(limitNumber)
        .lean(),
      Service.countDocuments(query)
    ]);

    const totalPages = Math.ceil(totalServices / limitNumber);

    res.status(200).json({
      success: true,
      data: services,
      pagination: {
        currentPage: pageNumber,
        totalPages,
        totalServices,
        hasNext: pageNumber < totalPages,
        hasPrev: pageNumber > 1
      }
    });

  } catch (error) {
    console.error('Get services error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching services'
    });
  }
};

// Get featured services
const getFeaturedServices = async (req, res) => {
  try {
    const featuredServices = await Service.getFeatured().limit(10);

    res.status(200).json({
      success: true,
      data: featuredServices,
      message: 'Featured services retrieved successfully'
    });

  } catch (error) {
    console.error('Get featured services error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching featured services'
    });
  }
};

// Get single service by ID
const getServiceById = async (req, res) => {
  try {
    const { id } = req.params;

    const service = await Service.findById(id);

    if (!service || !service.isActive) {
      return res.status(404).json({
        success: false,
        message: 'Service not found'
      });
    }

    res.status(200).json({
      success: true,
      data: service
    });

  } catch (error) {
    console.error('Get service by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching service'
    });
  }
};

// Create new service (Admin only)
const createService = async (req, res) => {
  try {
    const serviceData = req.body;

    // Create service
    const service = new Service(serviceData);
    await service.save();

    res.status(201).json({
      success: true,
      data: service,
      message: 'Service created successfully'
    });

  } catch (error) {
    console.error('Create service error:', error);
    
    if (error.name === 'ValidationError') {
      const errors = Object.values(error.errors).map(e => e.message);
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        errors
      });
    }

    res.status(500).json({
      success: false,
      message: 'Server error while creating service'
    });
  }
};

// Update service (Admin only)
const updateService = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    const service = await Service.findByIdAndUpdate(
      id,
      updateData,
      { new: true, runValidators: true }
    );

    if (!service) {
      return res.status(404).json({
        success: false,
        message: 'Service not found'
      });
    }

    res.status(200).json({
      success: true,
      data: service,
      message: 'Service updated successfully'
    });

  } catch (error) {
    console.error('Update service error:', error);
    
    if (error.name === 'ValidationError') {
      const errors = Object.values(error.errors).map(e => e.message);
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        errors
      });
    }

    res.status(500).json({
      success: false,
      message: 'Server error while updating service'
    });
  }
};

// Delete service (Admin only)
const deleteService = async (req, res) => {
  try {
    const { id } = req.params;

    // Soft delete - set isActive to false
    const service = await Service.findByIdAndUpdate(
      id,
      { isActive: false },
      { new: true }
    );

    if (!service) {
      return res.status(404).json({
        success: false,
        message: 'Service not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Service deleted successfully'
    });

  } catch (error) {
    console.error('Delete service error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while deleting service'
    });
  }
};

module.exports = {
  getServices,
  getFeaturedServices,
  getServiceById,
  createService,
  updateService,
  deleteService
};