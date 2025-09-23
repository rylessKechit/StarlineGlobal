import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../core/router/route_paths.dart';
import '../../../shared/widgets/starlane_widgets.dart';

// Feature imports
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../data/models/user.dart';
import '../../../data/models/activity.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<Map<String, dynamic>> _categories = [
    {
      'category': 'realEstate',
      'title': 'Immobilier',
      'subtitle': 'Propriétés de luxe',
      'icon': Icons.home_rounded,
      'color': StarlaneColors.gold500,
      'gradient': const LinearGradient(
        colors: [StarlaneColors.gold400, StarlaneColors.gold600],
      ),
    },
    {
      'category': 'transport',
      'title': 'Transport',
      'subtitle': 'VIP & Privé',
      'icon': Icons.directions_car_rounded,
      'color': StarlaneColors.emerald500,
      'gradient': const LinearGradient(
        colors: [StarlaneColors.emerald400, StarlaneColors.emerald600],
      ),
    },
    {
      'category': 'airTravel',
      'title': 'Aviation',
      'subtitle': 'Jets privés',
      'icon': Icons.flight_rounded,
      'color': StarlaneColors.navy500,
      'gradient': const LinearGradient(
        colors: [StarlaneColors.navy400, StarlaneColors.navy600],
      ),
    },
    {
      'category': 'lifestyle',
      'title': 'Lifestyle',
      'subtitle': 'Spa & Bien-être',
      'icon': Icons.spa_rounded,
      'color': StarlaneColors.purple500,
      'gradient': const LinearGradient(
        colors: [StarlaneColors.purple400, StarlaneColors.purple600],
      ),
    },
    {
      'category': 'events',
      'title': 'Événements',
      'subtitle': 'Célébrations privées',
      'icon': Icons.celebration_rounded,
      'color': StarlaneColors.gold600,
      'gradient': const LinearGradient(
        colors: [StarlaneColors.gold500, StarlaneColors.gold700],
      ),
    },
    {
      'category': 'security',
      'title': 'Sécurité',
      'subtitle': 'Protection VIP',
      'icon': Icons.security_rounded,
      'color': StarlaneColors.navy600,
      'gradient': const LinearGradient(
        colors: [StarlaneColors.navy500, StarlaneColors.navy700],
      ),
    },
  ];

  // Mock data pour les activités populaires - En attendant l'API
  final List<Map<String, dynamic>> _popularActivities = [
    {
      'id': '1',
      'title': 'Weekend Grand Prix Monaco',
      'location': 'Monaco',
      'price': 2500.0,
      'currency': 'EUR',
      'rating': 4.9,
      'reviews': 127,
      'image': 'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?w=400',
      'category': 'events',
      'featured': true,
    },
    {
      'id': '2',
      'title': 'Yacht Party Privé',
      'location': 'Saint-Tropez',
      'price': 1800.0,
      'currency': 'EUR',
      'rating': 4.8,
      'reviews': 89,
      'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'category': 'lifestyle',
      'featured': true,
    },
    {
      'id': '3',
      'title': 'Jet Privé Paris-Londres',
      'location': 'Multi-villes',
      'price': 3200.0,
      'currency': 'EUR',
      'rating': 5.0,
      'reviews': 203,
      'image': 'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=400',
      'category': 'airTravel',
      'featured': false,
    },
    {
      'id': '4',
      'title': 'Château privé Bordeaux',
      'location': 'Bordeaux',
      'price': 4500.0,
      'currency': 'EUR',
      'rating': 4.9,
      'reviews': 56,
      'image': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400',
      'category': 'realEstate',
      'featured': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      8, // Augmenté pour plus d'éléments
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.1 + (index * 0.08),
            0.6 + (index * 0.08),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      8,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.1 + (index * 0.08),
            0.6 + (index * 0.08),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCategoryTap(String category) {
    // TODO: Navigator vers la page de catégorie avec filtrage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catégorie $category - À implémenter'),
        backgroundColor: StarlaneColors.gold500,
      ),
    );
  }

  void _onActivityTap(Map<String, dynamic> activity) {
    // TODO: Navigator vers la page de détail de l'activité
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails de "${activity['title']}" - À implémenter'),
        backgroundColor: StarlaneColors.emerald500,
      ),
    );
  }

  void _onSearchTap() {
    // TODO: Navigator vers la page de recherche
    context.go(RoutePaths.explore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          
          return CustomScrollView(
            slivers: [
              // App Bar avec gradient et informations utilisateur
              SliverAppBar(
                expandedHeight: 220.h,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          StarlaneColors.navy800,
                          StarlaneColors.navy600,
                          StarlaneColors.gold700,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: SlideTransition(
                          position: _slideAnimations[0],
                          child: FadeTransition(
                            opacity: _fadeAnimations[0],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Header avec salutation et avatar
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user != null 
                                              ? 'Bonjour ${user.name.split(' ').first} 👋'
                                              : 'Bonjour 👋',
                                            style: TextStyle(
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.bold,
                                              color: StarlaneColors.white,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Découvrez nos services de luxe',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: StarlaneColors.gold300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Avatar utilisateur
                                    GestureDetector(
                                      onTap: () => context.go(RoutePaths.profile),
                                      child: Container(
                                        width: 50.w,
                                        height: 50.w,
                                        decoration: BoxDecoration(
                                          color: StarlaneColors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: StarlaneColors.gold400,
                                            width: 2,
                                          ),
                                        ),
                                        child: user?.avatar != null 
                                          ? ClipOval(
                                              child: StarlaneImage(
                                                imageUrl: user!.avatar!,
                                                width: 50.w,
                                                height: 50.w,
                                              ),
                                            )
                                          : Icon(
                                              Icons.person_rounded,
                                              color: StarlaneColors.white,
                                              size: 24.sp,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 24.h),
                                
                                // Barre de recherche
                                GestureDetector(
                                  onTap: _onSearchTap,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: StarlaneColors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: StarlaneColors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search_rounded,
                                          color: StarlaneColors.gray500,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          'Rechercher un service...',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: StarlaneColors.gray500,
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
                      ),
                    ),
                  ),
                ),
              ),
              
              // Contenu principal
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Catégories
                      SlideTransition(
                        position: _slideAnimations[1],
                        child: FadeTransition(
                          opacity: _fadeAnimations[1],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nos Services',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: StarlaneColors.navy700,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Explorez nos catégories de services premium',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: StarlaneColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Grid des catégories
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          
                          return SlideTransition(
                            position: _slideAnimations[index + 2],
                            child: FadeTransition(
                              opacity: _fadeAnimations[index + 2],
                              child: StarlaneCard(
                                onTap: () => _onCategoryTap(category['category']),
                                padding: EdgeInsets.all(16.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: category['gradient'],
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          category['icon'],
                                          color: StarlaneColors.white,
                                          size: 32.sp,
                                        ),
                                        const Spacer(),
                                        Text(
                                          category['title'],
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: StarlaneColors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          category['subtitle'],
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: StarlaneColors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 32.h),
                      
                      // Section Activités Populaires
                      SlideTransition(
                        position: _slideAnimations[7],
                        child: FadeTransition(
                          opacity: _fadeAnimations[7],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Activités Populaires',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: StarlaneColors.navy700,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Les plus demandées cette semaine',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: StarlaneColors.gray600,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => context.go(RoutePaths.explore),
                                child: Text(
                                  'Voir tout',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: StarlaneColors.gold600,
                                    fontWeight: FontWeight.w600,
                                  ),
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
              
              // Liste horizontale des activités populaires
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 280.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 24.w, right: 24.w),
                    itemCount: _popularActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _popularActivities[index];
                      
                      return SlideTransition(
                        position: _slideAnimations[(index % _slideAnimations.length)],
                        child: FadeTransition(
                          opacity: _fadeAnimations[(index % _fadeAnimations.length)],
                          child: Container(
                            width: 250.w,
                            margin: EdgeInsets.only(
                              right: index < _popularActivities.length - 1 ? 16.w : 0,
                            ),
                            child: StarlaneCard(
                              onTap: () => _onActivityTap(activity),
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image avec badge featured
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.r),
                                    ),
                                    child: Stack(
                                      children: [
                                        StarlaneImage(
                                          imageUrl: activity['image'],
                                          width: double.infinity,
                                          height: 160.h,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16.r),
                                          ),
                                        ),
                                        if (activity['featured'] == true)
                                          Positioned(
                                            top: 12.h,
                                            left: 12.w,
                                            child: StarlaneBadge(
                                              text: 'Populaire',
                                              backgroundColor: StarlaneColors.gold500,
                                              textColor: StarlaneColors.white,
                                              icon: Icons.star_rounded,
                                            ),
                                          ),
                                        Positioned(
                                          top: 12.h,
                                          right: 12.w,
                                          child: Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: StarlaneColors.white.withOpacity(0.9),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.favorite_border_rounded,
                                              color: StarlaneColors.gray700,
                                              size: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Informations de l'activité
                                  Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activity['title'],
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: StarlaneColors.navy700,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: StarlaneColors.gray500,
                                              size: 14.sp,
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Text(
                                                activity['location'],
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: StarlaneColors.gray500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            StarlaneRating(
                                              rating: activity['rating'].toDouble(),
                                              size: 14,
                                              showRating: true,
                                            ),
                                            Text(
                                              '(${activity['reviews']} avis)',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: StarlaneColors.gray500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${activity['price'].toInt()}',
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: StarlaneColors.gold600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '€',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: StarlaneColors.gold600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: StarlaneColors.gold100,
                                                borderRadius: BorderRadius.circular(20.r),
                                              ),
                                              child: Text(
                                                'Réserver',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: StarlaneColors.gold700,
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Espace final
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
            ],
          );
        },
      ),
    );
  }
}