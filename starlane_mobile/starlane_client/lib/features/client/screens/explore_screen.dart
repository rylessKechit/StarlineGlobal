// Path: starlane_mobile/starlane_client/lib/features/client/screens/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/activity.dart';
import '../repositories/activity_repository.dart';
import '../bloc/activity_bloc.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityBloc(
        activityRepository: context.read<ActivityRepository>(),
      )..add(ActivityLoadRequested()),
      child: const _ExploreScreenView(),
    );
  }
}

class _ExploreScreenView extends StatefulWidget {
  const _ExploreScreenView();

  @override
  State<_ExploreScreenView> createState() => _ExploreScreenViewState();
}

class _ExploreScreenViewState extends State<_ExploreScreenView> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    context.read<ActivityBloc>().add(ActivityLoadRequested());
  }

  void _onSearchChanged(String value) {
    // Recherche avec debounce
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == value) {
        if (value.isNotEmpty) {
          context.read<ActivityBloc>().add(ActivitySearchRequested(query: value));
        } else {
          context.read<ActivityBloc>().add(ActivityLoadRequested());
        }
      }
    });
  }

  void _onRefresh() {
    context.read<ActivityBloc>().add(ActivityLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec recherche
            _buildHeader(),
            
            // Contenu principal
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _onRefresh(),
                color: StarlaneColors.navy500,
                child: BlocBuilder<ActivityBloc, ActivityState>(
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return _buildLoadingState();
                    }
                    
                    if (state is ActivityError) {
                      return _buildErrorState(state.message);
                    }
                    
                    if (state is ActivityLoaded) {
                      if (state.activities.isEmpty) {
                        return _buildEmptyState();
                      }
                      return _buildActivitiesList(state.activities);
                    }
                    
                    if (state is ActivityFeaturedLoaded) {
                      if (state.activities.isEmpty) {
                        return _buildEmptyState();
                      }
                      return _buildActivitiesList(state.activities);
                    }
                    
                    return _buildEmptyState();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: StarlaneColors.white,
        boxShadow: StarlaneColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Text(
            'Explorer',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Découvrez les activités de nos prestataires partenaires',
            style: TextStyle(
              fontSize: 16.sp,
              color: StarlaneColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          
          // Barre de recherche
          StarlaneTextField(
            controller: _searchController,
            hintText: 'Rechercher une activité...',
            prefixIcon: Icons.search,
            onChanged: _onSearchChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(List<Activity> activities) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: StarlaneColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: StarlaneColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de l'activité
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Stack(
                children: [
                  // Image principale
                  activity.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: activity.images.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: StarlaneColors.gray200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: StarlaneColors.navy500,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: StarlaneColors.navy100,
                            child: Center(
                              child: Icon(
                                _getCategoryIcon(activity.category),
                                size: 48.sp,
                                color: StarlaneColors.navy500,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: StarlaneColors.navy100,
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(activity.category.name),
                              size: 48.sp,
                              color: StarlaneColors.navy500,
                            ),
                          ),
                        ),
                  
                  // Badge catégorie
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: StarlaneColors.navy500.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child:                       Text(
                        ActivityCategory.fromString(activity.category).displayName,
                        style: TextStyle(
                          color: StarlaneColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Rating badge si disponible
                  if (activity.reviewsCount > 0)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: StarlaneColors.orange500.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.sp,
                              color: StarlaneColors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              activity.rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: StarlaneColors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Contenu
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre et provider
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: StarlaneColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Proposé par ${activity.providerName}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: StarlaneColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Description
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: StarlaneColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                
                // Info bottom
                Row(
                  children: [
                    // Location
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: StarlaneColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        '${activity.city}, ${activity.country}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: StarlaneColors.textSecondary,
                        ),
                      ),
                    ),
                    
                    // Duration si disponible
                    if (activity.duration > 0) ...[
                      Icon(
                        Icons.access_time_outlined,
                        size: 16.sp,
                        color: StarlaneColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${activity.duration} min',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: StarlaneColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 16.w),
                    ],
                    
                    // Prix
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: StarlaneColors.navy500,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${activity.price.toInt()}€',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 300.h,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: StarlaneColors.gray200,
            borderRadius: BorderRadius.circular(16.r),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
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
              'Erreur lors du chargement',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: StarlaneColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            StarlaneButton(
              text: 'Réessayer',
              onPressed: _onRefresh,
              style: StarlaneButtonStyle.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 80.sp,
              color: StarlaneColors.gray400,
            ),
            SizedBox(height: 24.h),
            Text(
              'Aucune activité disponible',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: StarlaneColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Nos prestataires partenaires ajoutent régulièrement de nouvelles activités premium.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            StarlaneButton(
              text: 'Actualiser',
              onPressed: _onRefresh,
              style: StarlaneButtonStyle.primary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'realEstate': return Icons.home;
      case 'airTravel': return Icons.flight;
      case 'transport': return Icons.directions_car;
      case 'lifestyle': return Icons.spa;
      case 'events': return Icons.event;
      case 'security': return Icons.security;
      case 'corporate': return Icons.business;
      default: return Icons.category;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}