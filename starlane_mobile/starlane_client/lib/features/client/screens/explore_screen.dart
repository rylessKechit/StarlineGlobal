// lib/features/client/screens/explore_screen.dart
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
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  
  @override
  void initState() {
    super.initState();
    _loadActivities();
    
    // ✅ Listener pour sticky header
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
            // ✅ HEADER STICKY avec animation
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

  // ✅ NOUVEAU: Header sticky
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
          
          // ✅ CORRECTION: Description avec AnimatedSize au lieu d'AnimatedContainer
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
          
          SizedBox(height: _isScrolled ? 12.h : 20.h),
          
          // Search bar plus compacte
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: StarlaneColors.gray50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: StarlaneColors.gray200,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Rechercher une activité...',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: StarlaneColors.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.sp,
                  color: StarlaneColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: StarlaneColors.primary,
      ),
    );
  }

  Widget _buildLoadedState(List<Activity> activities) {
    if (activities.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
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
            'Une erreur est survenue',
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
      controller: _scrollController, // ✅ Ajout du controller
      padding: EdgeInsets.all(16.w), // ✅ Padding réduit
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h), // ✅ Margin réduite
      decoration: BoxDecoration(
        color: StarlaneColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: StarlaneColors.gray200, // ✅ Bordure ajoutée
          width: 1,
        ),
        boxShadow: [
          // ✅ Ombre plus accentuée
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 6),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Image plus petite
          Container(
            height: 160.h, // ✅ Réduit de 200h à 160h
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
                  _buildActivityImage(activity),
                  
                  // ✅ Badge catégorie avec couleurs matching
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h), // ✅ Plus compact
                      decoration: BoxDecoration(
                        color: _getCategoryColor(activity.category).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16.r), // ✅ Plus arrondi
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getCategoryDisplayName(activity.category),
                        style: TextStyle(
                          fontSize: 11.sp, // ✅ Police plus petite
                          fontWeight: FontWeight.w600,
                          color: StarlaneColors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Badge rating si disponible
                  if (activity.rating > 0)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h), // ✅ Plus compact
                        decoration: BoxDecoration(
                          color: StarlaneColors.gold500,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 10.sp, // ✅ Icône plus petite
                              color: StarlaneColors.white,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              activity.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 9.sp, // ✅ Texte plus petit
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.white,
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
          
          // Contenu blanc plus compact
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w), // ✅ Padding réduit de 16 à 14
            decoration: BoxDecoration(
              color: StarlaneColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
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
                              fontSize: 17.sp, // ✅ Légèrement réduit
                              fontWeight: FontWeight.bold,
                              color: StarlaneColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3.h), // ✅ Espacement réduit
                          Text(
                            'Proposé par ${activity.providerName}',
                            style: TextStyle(
                              fontSize: 13.sp, // ✅ Légèrement réduit
                              color: StarlaneColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h), // ✅ Espacement réduit
                
                // Description
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 13.sp, // ✅ Légèrement réduit
                    color: StarlaneColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2, // ✅ Réduit à 2 lignes
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h), // ✅ Espacement réduit
                
                // Info bottom
                Row(
                  children: [
                    // Location
                    Icon(
                      Icons.location_on_outlined,
                      size: 15.sp, // ✅ Icône plus petite
                      color: StarlaneColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        '${activity.city}, ${activity.country}',
                        style: TextStyle(
                          fontSize: 13.sp, // ✅ Texte plus petit
                          color: StarlaneColors.textSecondary,
                        ),
                      ),
                    ),
                    // Prix
                    Text(
                      '${activity.price.toStringAsFixed(0)}${_getCurrencySymbol(activity.currency)}',
                      style: TextStyle(
                        fontSize: 17.sp, // ✅ Légèrement réduit
                        fontWeight: FontWeight.bold,
                        color: StarlaneColors.gold500,
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

  // ✅ NOUVELLE FONCTION: Couleurs matching avec home screen
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'airTravel':
        return const Color(0xFF3B82F6); // Bleu comme sur home screen
      case 'transport':
        return const Color(0xFF10B981); // Vert émeraude
      case 'realEstate':
        return const Color(0xFFF59E0B); // Orange/ambre
      case 'corporate':
        return const Color(0xFF8B5CF6); // Violet
      case 'lifestyle':
        return const Color(0xFFEF4444); // Rouge
      case 'events':
        return const Color(0xFF06B6D4); // Cyan
      case 'security':
        return const Color(0xFF6B7280); // Gris
      default:
        return StarlaneColors.navy500;
    }
  }

  // Gestion sécurisée des images
  Widget _buildActivityImage(Activity activity) {
    final imageUrl = activity.primaryImageUrl;
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
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
        errorWidget: (context, url, error) => _buildDefaultCategoryImage(activity.category),
      );
    } else {
      return _buildDefaultCategoryImage(activity.category);
    }
  }

  // Image par défaut basée sur la catégorie
  Widget _buildDefaultCategoryImage(String category) {
    return Container(
      color: _getCategoryColor(category).withOpacity(0.1),
      child: Center(
        child: Icon(
          _getCategoryIcon(category),
          size: 40.sp, // ✅ Icône plus petite
          color: _getCategoryColor(category),
        ),
      ),
    );
  }

  // Fonction pour obtenir l'icône de catégorie
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'realEstate':
        return Icons.home_outlined;
      case 'airTravel':
        return Icons.flight_outlined;
      case 'transport':
        return Icons.directions_car_outlined;
      case 'corporate':
        return Icons.business_outlined;
      case 'lifestyle':
        return Icons.spa_outlined;
      case 'events':
        return Icons.event_outlined;
      case 'security':
        return Icons.security_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  // Fonction pour le nom d'affichage des catégories
  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'realEstate':
        return 'Immobilier';
      case 'airTravel':
        return 'Aviation Privée';
      case 'transport':
        return 'Transport';
      case 'corporate':
        return 'Corporate';
      case 'lifestyle':
        return 'Lifestyle';
      case 'events':
        return 'Événements';
      case 'security':
        return 'Sécurité';
      default:
        return 'Autre';
    }
  }

  // Fonction pour le symbole de devise
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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose(); // ✅ Dispose du controller
    super.dispose();
  }
}