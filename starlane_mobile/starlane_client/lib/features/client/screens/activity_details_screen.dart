// Path: starlane_mobile/starlane_client/lib/features/client/screens/activity_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/activity.dart';

// Repositories et BLoCs
import '../repositories/activity_repository.dart';
import '../bloc/activity_bloc.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final String activityId;
  
  const ActivityDetailsScreen({
    super.key,
    required this.activityId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityBloc(
        activityRepository: context.read<ActivityRepository>(),
      )..add(ActivityDetailRequested(activityId: activityId)),
      child: _ActivityDetailsView(activityId: activityId),
    );
  }
}

class _ActivityDetailsView extends StatefulWidget {
  final String activityId;
  
  const _ActivityDetailsView({required this.activityId});

  @override
  State<_ActivityDetailsView> createState() => _ActivityDetailsViewState();
}

class _ActivityDetailsViewState extends State<_ActivityDetailsView> {
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
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state is ActivityLoading) {
            return _buildLoadingState();
          } else if (state is ActivityDetailLoaded) {
            return _buildActivityDetails(state.activity);
          } else if (state is ActivityError) {
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
                  context.read<ActivityBloc>().add(
                    ActivityDetailRequested(activityId: widget.activityId),
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

  Widget _buildActivityDetails(Activity activity) {
    return CustomScrollView(
      slivers: [
        // AppBar avec image en background
        _buildSliverAppBar(activity),
        
        // Contenu principal
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Informations principales - SANS ESPACEMENT
              _buildActivityHeader(activity),
              
              // Description
              _buildDescriptionSection(activity),
              
              // Pricing - AJOUTÉ POUR LES ACTIVITÉS
              _buildPricingSection(activity),
              
              // Localisation
              _buildLocationSection(activity),
              
              // Features
              if (activity.features.isNotEmpty)
                _buildFeaturesSection(activity.features),
              
              // Provider info
              if (activity.provider != null)
                _buildProviderSection(activity.provider!),
              
              // Contact / Réservation
              _buildActionSection(activity),
              
              // Espacement final
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Activity activity) {
    final images = activity.images.where((img) => img.url.isNotEmpty).toList();
    final hasImages = images.isNotEmpty;
    
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: StarlaneColors.white,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        width: 40.w, // Largeur fixe
        height: 40.w, // Hauteur fixe (carré)
        decoration: BoxDecoration(
          color: StarlaneColors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Center( // Center pour centrer parfaitement
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: StarlaneColors.textPrimary,
              size: 16.sp, // Taille encore plus réduite
            ),
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
        background: hasImages ? _buildImageGallery(images) : _buildPlaceholderImage(activity),
      ),
    );
  }

  Widget _buildImageGallery(List<ActivityImage> images) {
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

  Widget _buildPlaceholderImage(Activity? activity) {
    return Container(
      color: StarlaneColors.gray100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 64.sp,
              color: StarlaneColors.primary,
            ),
            if (activity != null) ...[
              SizedBox(height: 16.h),
              Text(
                activity.title,
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

  Widget _buildActivityHeader(Activity activity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.w),
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
              _getCategoryLabel(activity.category),
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
            activity.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
              height: 1.2,
            ),
          ),
          
          if (activity.shortDescription != null) ...[
            SizedBox(height: 8.h),
            Text(
              activity.shortDescription!,
              style: TextStyle(
                fontSize: 16.sp,
                color: StarlaneColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
          
          SizedBox(height: 16.h),
          
          // Tags
          if (activity.tags.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: activity.tags.map((tag) => Container(
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

  Widget _buildDescriptionSection(Activity activity) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.w),
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
            activity.description,
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

  Widget _buildPricingSection(Activity activity) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.w),
      color: StarlaneColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarification',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: StarlaneColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: StarlaneColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.euro,
                  color: StarlaneColors.primary,
                  size: 24.sp,
                ),
                
                SizedBox(width: 12.w),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: StarlaneColors.textSecondary,
                          ),
                          children: [
                            TextSpan(text: 'À partir de '),
                            TextSpan(
                              text: _formatPrice(activity.pricing),
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (activity.pricing.priceType != 'fixed')
                        Text(
                          _getPriceDescription(activity.pricing),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: StarlaneColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(Activity activity) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.w),
      color: StarlaneColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Localisation',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: StarlaneColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${activity.location.city}, ${activity.location.country}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: StarlaneColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          
          if (activity.location.address != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.place,
                  color: StarlaneColors.gray500,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    activity.location.address!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: StarlaneColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(List<String> features) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.w),
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

  Widget _buildProviderSection(ActivityProvider provider) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.w),
      color: StarlaneColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prestataire',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: StarlaneColors.primary.withOpacity(0.1),
                child: Text(
                  provider.name.isNotEmpty ? provider.name[0].toUpperCase() : 'P',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: StarlaneColors.primary,
                  ),
                ),
              ),
              
              SizedBox(width: 16.w),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: StarlaneColors.textPrimary,
                      ),
                    ),
                    
                    if (provider.companyName != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        provider.companyName!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: StarlaneColors.textSecondary,
                        ),
                      ),
                    ],
                    
                    if (provider.rating != null && provider.rating! > 0) ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            provider.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: StarlaneColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(Activity activity) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      color: StarlaneColors.white,
      child: Column(
        children: [
          // Bouton principal de réservation
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                _handleBookingRequest(activity);
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
                    Icons.event_available,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Réserver cette activité',
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
                _handleContactRequest(activity);
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
                    'Contacter le prestataire',
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
      case 'realEstate':
        return 'Real Estate';
      case 'airTravel':
        return 'Air Travel';
      case 'transport':
        return 'Transport';
      case 'lifestyle':
        return 'Lifestyle';
      case 'events':
        return 'Events';
      case 'security':
        return 'Security';
      case 'corporate':
        return 'Corporate';
      default:
        return category.toUpperCase();
    }
  }

  String _formatPrice(ActivityPricing pricing) {
    final symbols = {'EUR': '€', 'USD': '\$', 'GBP': '£'};
    final symbol = symbols[pricing.currency] ?? pricing.currency;
    
    return '${pricing.basePrice.toStringAsFixed(0)} $symbol';
  }

  String _getPriceDescription(ActivityPricing pricing) {
    final descriptions = {
      'per_hour': 'par heure',
      'per_day': 'par jour',
      'per_week': 'par semaine',
      'per_month': 'par mois',
      'per_person': 'par personne',
      'fixed': 'prix fixe',
    };
    
    return descriptions[pricing.priceType] ?? 'prix fixe';
  }

  void _handleBookingRequest(Activity activity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Réservation pour "${activity.title}" - À implémenter'),
        backgroundColor: StarlaneColors.primary,
        action: SnackBarAction(
          label: 'OK',
          textColor: StarlaneColors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _handleContactRequest(Activity activity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact prestataire pour "${activity.title}" - À implémenter'),
        backgroundColor: StarlaneColors.secondary,
        action: SnackBarAction(
          label: 'OK',
          textColor: StarlaneColors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}