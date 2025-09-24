import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/activity.dart';
import '../bloc/activity_bloc.dart';

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
          
          // BlocBuilder pour les vraies données
          BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, state) {
              if (state is ActivityLoading) {
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
              
              if (state is ActivityError) {
                return Container(
                  height: 100.h,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              if (state is ActivityFeaturedLoaded) {
                final featuredActivities = state.activities;
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: featuredActivities.length,
                  itemBuilder: (context, index) {
                    final activity = featuredActivities[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 6.h),
                      child: _buildServiceCard(activity),
                    );
                  },
                );
              }
              
              // État par défaut - charge les données
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ActivityBloc>()
                    .add(ActivityFeaturedLoadRequested());
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

  Widget _buildServiceCard(Activity activity) {
    // Icône selon la catégorie
    IconData getIconForCategory(ActivityCategory category) {
      switch (category) {
        case ActivityCategory.airTravel:
          return Icons.flight;
        case ActivityCategory.transport:
          return Icons.directions_car;
        case ActivityCategory.realEstate:
          return Icons.home;
        case ActivityCategory.corporate:
          return Icons.business;
        case ActivityCategory.lifestyle:
          return Icons.spa;
        case ActivityCategory.events:
          return Icons.event;
        default:
          return Icons.star;
      }
    }

    // Couleur selon la catégorie
    Color getColorForCategory(ActivityCategory category) {
      switch (category) {
        case ActivityCategory.airTravel:
          return StarlaneColors.navy500;
        case ActivityCategory.transport:
          return StarlaneColors.emerald500;
        case ActivityCategory.realEstate:
          return StarlaneColors.gold500;
        case ActivityCategory.corporate:
          return StarlaneColors.purple500;
        case ActivityCategory.lifestyle:
          return StarlaneColors.pink500;
        case ActivityCategory.events:
          return StarlaneColors.blue500;
        default:
          return StarlaneColors.gray500;
      }
    }

    // Formater le prix - VERSION SIMPLIFIÉE
    String formatPrice() {
      // Prix simple par défaut
      return '${activity.price.toInt()}€';
    }

    return StarlaneCard(
      onTap: () => onServiceTap(activity.id),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Icône
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: getColorForCategory(activity.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              getIconForCategory(activity.category),
              color: getColorForCategory(activity.category),
              size: 22.sp,
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.navy700,
                        ),
                      ),
                    ),
                    Text(
                      formatPrice(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: StarlaneColors.gold600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  activity.category.displayName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: getColorForCategory(activity.category),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: StarlaneColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          SizedBox(width: 8.w),
          
          // Flèche
          Icon(
            Icons.arrow_forward_ios,
            size: 14.sp,
            color: StarlaneColors.gray400,
          ),
        ],
      ),
    );
  }
}