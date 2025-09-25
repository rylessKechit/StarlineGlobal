// Path: starlane_mobile/starlane_client/lib/features/client/screens/service_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/service.dart';

// Repositories et BLoCs
import '../repositories/service_repository.dart';
import '../bloc/service_bloc.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceId;
  
  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(
        serviceRepository: context.read<ServiceRepository>(),
      )..add(ServiceDetailRequested(serviceId: serviceId)),
      child: _ServiceDetailsView(serviceId: serviceId),
    );
  }
}

class _ServiceDetailsView extends StatefulWidget {
  final String serviceId;
  
  const _ServiceDetailsView({required this.serviceId});

  @override
  State<_ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<_ServiceDetailsView> {
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  bool _isBookmarked = false;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return _buildLoadingState();
          } else if (state is ServiceDetailLoaded) {
            return _buildServiceDetails(state.service);
          } else if (state is ServiceError) {
            return _buildErrorState(state.message);
          }
          return _buildErrorState('État inconnu');
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: StarlaneColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: StarlaneColors.textPrimary,
          ),
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.primary),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      backgroundColor: StarlaneColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: StarlaneColors.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: StarlaneColors.error,
              ),
              SizedBox(height: 16.h),
              Text(
                'Erreur',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: StarlaneColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  context.read<ServiceBloc>().add(
                    ServiceDetailRequested(serviceId: widget.serviceId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: StarlaneColors.primary,
                  foregroundColor: StarlaneColors.white,
                ),
                child: Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDetails(Service service) {
    return CustomScrollView(
      slivers: [
        // AppBar avec image en background
        _buildSliverAppBar(service),
        
        // Contenu principal
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Informations principales - SANS ESPACEMENT
              _buildServiceHeader(service),
              
              // Description
              _buildDescriptionSection(service),
              
              // Features
              if (service.features?.isNotEmpty == true)
                _buildFeaturesSection(service.features!),
              
              // Contact / Réservation
              _buildActionSection(service),
              
              // Espacement final
              SizedBox(height: 32.h), // RÉDUIT de 100.h à 32.h
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Service service) {
    final images = service.images?.where((img) => img.url.isNotEmpty).toList() ?? [];
    final hasImages = images.isNotEmpty;
    
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: StarlaneColors.white,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: StarlaneColors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: StarlaneColors.textPrimary,
            size: 20.sp,
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: StarlaneColors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarked ? 'Ajouté aux favoris' : 'Retiré des favoris',
                  ),
                  backgroundColor: StarlaneColors.success,
                ),
              );
            },
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? StarlaneColors.primary : StarlaneColors.textPrimary,
              size: 20.sp,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: hasImages ? _buildImageGallery(images) : _buildPlaceholderImage(service),
      ),
    );
  }

  Widget _buildImageGallery(List<ServiceImage> images) {
    return Stack(
      children: [
        PageView.builder(
          controller: _imageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            final image = images[index];
            return CachedNetworkImage(
              imageUrl: image.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: StarlaneColors.gray200,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.primary),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => _buildPlaceholderImage(null),
            );
          },
        ),
        
        // Indicateurs de page
        if (images.length > 1)
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                final index = entry.key;
                final isActive = index == _currentImageIndex;
                
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: isActive ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? StarlaneColors.white 
                        : StarlaneColors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }).toList(),
            ),
          ),
        
        // Overlay gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage(Service? service) {
    return Container(
      color: StarlaneColors.gray100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond_outlined,
              size: 64.sp,
              color: StarlaneColors.primary,
            ),
            if (service != null) ...[
              SizedBox(height: 16.h),
              Text(
                service.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: StarlaneColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHeader(Service service) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.w), // PADDING TOP RÉDUIT
      color: StarlaneColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Catégorie
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: StarlaneColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              _getCategoryLabel(service.category),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: StarlaneColors.primary,
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Titre
          Text(
            service.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
              height: 1.2,
            ),
          ),
          
          if (service.shortDescription != null) ...[
            SizedBox(height: 8.h),
            Text(
              service.shortDescription!,
              style: TextStyle(
                fontSize: 16.sp,
                color: StarlaneColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
          
          SizedBox(height: 16.h),
          
          // Tags
          if (service.tags?.isNotEmpty == true)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: service.tags!.map((tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: StarlaneColors.gray100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: StarlaneColors.textSecondary,
                  ),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(Service service) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 0.h), // RÉDUIT de 8.h à 4.h
      padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 20.w), // PADDING TOP RÉDUIT
      color: StarlaneColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          Text(
            service.description,
            style: TextStyle(
              fontSize: 16.sp,
              color: StarlaneColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(List<String> features) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h), // RÉDUIT de 8.h à 4.h
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.w), // PADDING TOP RÉDUIT
      color: StarlaneColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Caractéristiques',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          ...features.map((feature) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: StarlaneColors.success,
                  size: 20.sp,
                ),
                
                SizedBox(width: 12.w),
                
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: StarlaneColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildActionSection(Service service) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h), // RÉDUIT de 8.h à 4.h
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h), // PADDING BOTTOM RÉDUIT
      color: StarlaneColors.white,
      child: Column(
        children: [
          // Bouton principal de réservation
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                _handleContactRequest(service); // CHANGÉ - même action pour les deux boutons
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: StarlaneColors.primary,
                foregroundColor: StarlaneColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.diamond,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Réserver ce service VIP',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Bouton secondaire de contact
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: () {
                _handleContactRequest(service);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: StarlaneColors.textPrimary,
                side: BorderSide(color: StarlaneColors.gray300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Nous contacter', // CHANGÉ POUR LES SERVICES
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthodes utilitaires
  String _getCategoryLabel(String category) {
    switch (category) {
      case 'airTravel':
        return 'Air Travel';
      case 'transport':
        return 'Transport';
      case 'realEstate':
        return 'Real Estate';
      case 'corporate':
        return 'Corporate';
      case 'luxury':
        return 'Luxury';
      case 'concierge':
        return 'Concierge';
      default:
        return category.toUpperCase();
    }
  }

  void _handleContactRequest(Service service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demande de service "${service.title}" - À implémenter'),
        backgroundColor: StarlaneColors.primary,
        action: SnackBarAction(
          label: 'OK',
          textColor: StarlaneColors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}