// Path: starlane_mobile/starlane_client/lib/features/client/widgets/featured_services_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/service.dart';
import '../bloc/service_bloc.dart';

class FeaturedServicesSection extends StatelessWidget {
  final Function(String serviceId) onServiceTap;

  const FeaturedServicesSection({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services Phares',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: StarlaneColors.navy900,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Nos services les plus demandés',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: StarlaneColors.gray600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigation vers tous les services
                },
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                    color: StarlaneColors.gold600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // BlocBuilder pour les Services au lieu des Activities
          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return Container(
                  height: 200.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        StarlaneColors.gold500,
                      ),
                    ),
                  ),
                );
              }
              
              if (state is ServiceError) {
                return Container(
                  height: 120.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: StarlaneColors.red500,
                          size: 32.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Erreur lors du chargement',
                          style: TextStyle(
                            color: StarlaneColors.red500,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: StarlaneColors.red400,
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ServiceBloc>()
                                .add(ServiceFeaturedLoadRequested());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: StarlaneColors.gold500,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w, 
                              vertical: 8.h,
                            ),
                          ),
                          child: Text(
                            'Réessayer',
                            style: TextStyle(
                              color: StarlaneColors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              if (state is ServiceFeaturedLoaded) {
                final featuredServices = state.services;
                
                if (featuredServices.isEmpty) {
                  return Container(
                    height: 100.h,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: StarlaneColors.gray400,
                            size: 32.sp,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Aucun service phare disponible',
                            style: TextStyle(
                              color: StarlaneColors.gray600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: featuredServices.length,
                  itemBuilder: (context, index) {
                    final service = featuredServices[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: _buildServiceCard(service),
                    );
                  },
                );
              }
              
              // État par défaut - charge les données
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ServiceBloc>()
                    .add(ServiceFeaturedLoadRequested());
              });
              
              return Container(
                height: 200.h,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      StarlaneColors.gold500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    // Icône selon la catégorie
    IconData getIconForCategory(ServiceCategory category) {
      switch (category) {
        case ServiceCategory.airTravel:
          return Icons.flight;
        case ServiceCategory.transport:
          return Icons.directions_car;
        case ServiceCategory.realEstate:
          return Icons.home;
        case ServiceCategory.corporate:
          return Icons.business;
      }
    }

    // Couleur selon la catégorie
    Color getColorForCategory(ServiceCategory category) {
      switch (category) {
        case ServiceCategory.airTravel:
          return StarlaneColors.blue500;
        case ServiceCategory.transport:
          return StarlaneColors.emerald500;
        case ServiceCategory.realEstate:
          return StarlaneColors.purple500;
        case ServiceCategory.corporate:
          return StarlaneColors.orange500;
      }
    }

    return InkWell(
      onTap: () => onServiceTap(service.id),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: StarlaneColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: StarlaneColors.black.withOpacity(0.08),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              // Icône du service
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: getColorForCategory(service.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  getIconForCategory(service.category),
                  color: getColorForCategory(service.category),
                  size: 28.sp,
                ),
              ),
              
              SizedBox(width: 16.w),
              
              // Informations du service
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: StarlaneColors.navy900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    Text(
                      service.displayDescription,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: StarlaneColors.gray600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Catégorie
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: getColorForCategory(service.category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            service.category.displayName,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: getColorForCategory(service.category),
                            ),
                          ),
                        ),
                        
                        // Prix
                        Text(
                          service.formattedPrice,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: StarlaneColors.gold600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Flèche
              Icon(
                Icons.arrow_forward_ios,
                color: StarlaneColors.gray400,
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}