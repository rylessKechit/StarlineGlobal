import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/service.dart';
import '../repositories/service_repository.dart';
import '../bloc/service_bloc.dart';

class FeaturedServicesSection extends StatelessWidget {
  final Function(Service)? onServiceTap;

  const FeaturedServicesSection({
    super.key,
    this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(
        serviceRepository: context.read<ServiceRepository>(),
      )..add(ServiceFeaturedLoadRequested()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de section
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 20.h),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: StarlaneColors.gold600,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Services Premium',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: StarlaneColors.navy900,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Navigation vers ServicesScreen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Navigation vers Services - À implémenter'),
                        backgroundColor: StarlaneColors.gold600,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Voir tous',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: StarlaneColors.gold600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Liste des services
          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return _buildLoadingState();
              } else if (state is ServiceFeaturedLoaded) {
                if (state.services.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildServicesList(state.services);
              } else if (state is ServiceError) {
                return _buildErrorState();
              }
              
              return _buildEmptyState();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 250.w,
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: StarlaneColors.gray100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: StarlaneShimmer(),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: StarlaneColors.gray50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: StarlaneColors.gray200,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.miscellaneous_services_outlined,
              size: 48.sp,
              color: StarlaneColors.textSecondary,
            ),
            SizedBox(height: 12.h),
            Text(
              'Services bientôt disponibles',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: StarlaneColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Nos services premium arrivent prochainement',
              style: TextStyle(
                fontSize: 12.sp,
                color: StarlaneColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 200.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: StarlaneColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: StarlaneColors.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: StarlaneColors.error,
            ),
            SizedBox(height: 12.h),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: StarlaneColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Impossible de charger les services',
              style: TextStyle(
                fontSize: 12.sp,
                color: StarlaneColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(List<Service> services) {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(service);
        },
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
      width: 250.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: StarlaneColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: StarlaneColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: StarlaneColors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onServiceTap?.call(service),
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du service
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.r),
                ),
                child: _buildServiceImage(service),
              ),
            ),
            
            // Contenu
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge catégorie
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: getColorForServiceCategory(service.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getIconForServiceCategory(service.category),
                            size: 12.sp,
                            color: getColorForServiceCategory(service.category),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            getServiceCategoryDisplayName(service.category),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: getColorForServiceCategory(service.category),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Nom du service
                    Expanded(
                      child: Text(
                        service.title, // CORRIGÉ - utilisation de title au lieu de name
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.navy900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Description
                    if (service.shortDescription != null) // CORRIGÉ - utilisation de shortDescription
                      Expanded(
                        flex: 2,
                        child: Text(
                          service.shortDescription!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: StarlaneColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    
                    SizedBox(height: 12.h),
                    
                    // Prix et statut
                    Row(
                      children: [
                        if (service.pricing != null && service.pricing!.basePrice > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: StarlaneColors.gold100,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '${service.pricing!.basePrice.toStringAsFixed(0)} ${_getCurrencySymbol(service.pricing!.currency)}', // CORRIGÉ - prix formaté manuellement
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: StarlaneColors.gold700,
                              ),
                            ),
                          ),
                        
                        const Spacer(),
                        
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12.sp,
                          color: StarlaneColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImage(Service service) {
    if (service.images != null && service.images!.isNotEmpty) {
      final primaryImage = service.images!.firstWhere(
        (img) => img.isPrimary,
        orElse: () => service.images!.first,
      );
      
      return CachedNetworkImage(
        imageUrl: primaryImage.url,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: StarlaneColors.gray100,
          child: StarlaneShimmer(),
        ),
        errorWidget: (context, url, error) => _buildDefaultServiceImage(service.category),
      );
    } else {
      return _buildDefaultServiceImage(service.category);
    }
  }

  Widget _buildDefaultServiceImage(String category) {
    return Container(
      color: getColorForServiceCategory(category).withOpacity(0.1),
      child: Center(
        child: Icon(
          getIconForServiceCategory(category),
          size: 32.sp,
          color: getColorForServiceCategory(category),
        ),
      ),
    );
  }

  // HELPER METHODS CORRIGES - travaillent avec String au lieu d'enum
  IconData getIconForServiceCategory(String category) {
    switch (category) {
      case 'concierge':
        return Icons.support_agent_outlined;
      case 'luxury':
        return Icons.diamond_outlined;
      case 'travel':
        return Icons.travel_explore_outlined;
      case 'lifestyle':
        return Icons.spa_outlined;
      case 'business':
        return Icons.business_center_outlined;
      case 'security':
        return Icons.security_outlined;
      default:
        return Icons.miscellaneous_services_outlined;
    }
  }

  Color getColorForServiceCategory(String category) {
    switch (category) {
      case 'concierge':
        return StarlaneColors.gold600;
      case 'luxury':
        return StarlaneColors.purple600;
      case 'travel':
        return StarlaneColors.navy600;
      case 'lifestyle':
        return StarlaneColors.emerald600;
      case 'business':
        return StarlaneColors.gray700;
      case 'security':
        return StarlaneColors.error;
      default:
        return StarlaneColors.primary;
    }
  }

  String getServiceCategoryDisplayName(String category) {
    switch (category) {
      case 'concierge':
        return 'Conciergerie';
      case 'luxury':
        return 'Luxe';
      case 'travel':
        return 'Voyage';
      case 'lifestyle':
        return 'Lifestyle';
      case 'business':
        return 'Business';
      case 'security':
        return 'Sécurité';
      default:
        return 'Service';
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      default:
        return currency;
    }
  }
}