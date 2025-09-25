// Path: starlane_mobile/starlane_client/lib/features/client/screens/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  
  @override
  void initState() {
    super.initState();
    _loadActivities();
    
    // Listener pour sticky header
    _scrollController.addListener(() {
      final isScrolled = _scrollController.offset > 50;
      if (_isScrolled != isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
    });
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
            // HEADER STICKY avec animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: StarlaneColors.white,
                boxShadow: _isScrolled 
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
              ),
              child: _buildStickyHeader(),
            ),
            
            Expanded(
              child: BlocBuilder<ActivityBloc, ActivityState>(
                builder: (context, state) {
                  if (state is ActivityLoading) {
                    return _buildLoadingState();
                  } else if (state is ActivityLoaded) {
                    return _buildLoadedState(state.activities);
                  } else if (state is ActivityError) {
                    return _buildErrorState(state.message);
                  }
                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header sticky
  Widget _buildStickyHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre toujours visible
          Text(
            'Explorer',
            style: TextStyle(
              fontSize: _isScrolled ? 24.sp : 28.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.textPrimary,
            ),
          ),
          
          // Description avec AnimatedSize
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isScrolled 
              ? const SizedBox.shrink() 
              : Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        'Découvrez les activités de nos prestataires partenaires',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: StarlaneColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
          ),
          
          SizedBox(height: _isScrolled ? 12.h : 16.h),
          
          // Barre de recherche
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: StarlaneColors.gray50,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: StarlaneColors.gray200,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher une activité...',
                hintStyle: TextStyle(
                  color: StarlaneColors.gray500,
                  fontSize: 15.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: StarlaneColors.gray500,
                  size: 20.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              style: TextStyle(
                fontSize: 15.sp,
                color: StarlaneColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.primary),
      ),
    );
  }

  Widget _buildLoadedState(List<Activity> activities) {
    if (activities.isEmpty) {
      return _buildEmptyState();
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        _onRefresh();
      },
      color: StarlaneColors.primary,
      child: _buildActivitiesList(activities),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
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
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
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
            onPressed: _onRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: StarlaneColors.primary,
              foregroundColor: StarlaneColors.white,
            ),
            child: Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 64.sp,
            color: StarlaneColors.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'Aucune activité trouvée',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: StarlaneColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Essayez de modifier vos critères de recherche',
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(List<Activity> activities) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return GestureDetector(
      onTap: () {
        // NAVIGATION VERS ACTIVITYDETAILSSCREEN AJOUTÉE
        context.push('/activity/${activity.id}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: StarlaneColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: StarlaneColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: _buildActivityImage(activity),
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
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'Proposé par ${activity.providerName}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: StarlaneColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  
                  // Description
                  Text(
                    activity.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: StarlaneColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  
                  // Info bottom
                  Row(
                    children: [
                      // Location
                      Icon(
                        Icons.location_on_outlined,
                        size: 15.sp,
                        color: StarlaneColors.gray500,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${activity.location.city}, ${activity.location.country}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: StarlaneColors.gray600,
                        ),
                      ),
                      
                      Spacer(),
                      
                      // Prix
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: StarlaneColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'À partir de ${activity.pricing.basePrice.toStringAsFixed(0)}€',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: StarlaneColors.primary,
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
      ),
    );
  }

  Widget _buildActivityImage(Activity activity) {
    final images = activity.images.where((img) => img.url.isNotEmpty).toList();
    
    if (images.isEmpty) {
      return Container(
        height: 180.h,
        color: StarlaneColors.gray100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_outlined,
                size: 40.sp,
                color: StarlaneColors.gray400,
              ),
              SizedBox(height: 8.h),
              Text(
                activity.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: StarlaneColors.gray600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    final primaryImage = images.firstWhere(
      (img) => img.isPrimary,
      orElse: () => images.first,
    );

    return Container(
      height: 180.h,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: primaryImage.url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: StarlaneColors.gray200,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.primary),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: StarlaneColors.gray100,
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: 40.sp,
              color: StarlaneColors.gray400,
            ),
          ),
        ),
      ),
    );
  }
}