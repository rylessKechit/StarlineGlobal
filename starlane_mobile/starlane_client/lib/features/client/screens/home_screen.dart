import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/starlane_colors.dart';
import '../../../data/models/user.dart';
import '../../../data/models/activity.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../features/auth/bloc/auth_bloc.dart';

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

  final _categories = [
    {
      'category': ActivityCategory.realEstate,
      'icon': Icons.home_rounded,
      'color': StarlaneColors.gold500,
      'gradient': const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFFEED9B)]),
    },
    {
      'category': ActivityCategory.airTravel,
      'icon': Icons.flight_rounded,
      'color': StarlaneColors.navy500,
      'gradient': const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF334155)]),
    },
    {
      'category': ActivityCategory.transport,
      'icon': Icons.directions_car_rounded,
      'color': StarlaneColors.emerald500,
      'gradient': const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF4ADE80)]),
    },
    {
      'category': ActivityCategory.lifestyle,
      'icon': Icons.spa_rounded,
      'color': StarlaneColors.purple500,
      'gradient': const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)]),
    },
    {
      'category': ActivityCategory.events,
      'icon': Icons.celebration_rounded,
      'color': StarlaneColors.gold600,
      'gradient': const LinearGradient(colors: [Color(0xFFCA8A04), Color(0xFFFDE047)]),
    },
    {
      'category': ActivityCategory.corporate,
      'icon': Icons.business_center_rounded,
      'color': StarlaneColors.navy600,
      'gradient': const LinearGradient(colors: [Color(0xFF475569), Color(0xFF94A3B8)]),
    },
  ];

  // Mock data pour les activités populaires
  final _popularActivities = [
    {
      'title': 'Weekend Grand Prix Monaco',
      'location': 'Monaco',
      'price': 2500.0,
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?w=400',
      'category': ActivityCategory.events,
    },
    {
      'title': 'Yacht Party Privé',
      'location': 'Saint-Tropez',
      'price': 1800.0,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'category': ActivityCategory.lifestyle,
    },
    {
      'title': 'Jet Privé Paris-Londres',
      'location': 'Multi-villes',
      'price': 3200.0,
      'rating': 5.0,
      'image': 'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=400',
      'category': ActivityCategory.airTravel,
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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      6,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.1 + (index * 0.1),
            0.6 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      6,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.1 + (index * 0.1),
            0.6 + (index * 0.1),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildWelcomeCard(),
                SizedBox(height: 24.h),
                _buildQuickActions(),
                SizedBox(height: 32.h),
                _buildServicesSection(),
                SizedBox(height: 32.h),
                _buildPopularActivities(),
                SizedBox(height: 100.h), // Bottom navigation space
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        
        return SliverAppBar(
          expandedHeight: 120.h,
          floating: false,
          pinned: true,
          backgroundColor: StarlaneColors.white,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [StarlaneColors.white, StarlaneColors.gray50],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      StarlaneAvatar(
                        imageUrl: user?.avatar,
                        initials: user?.initials ?? '?',
                        size: 48,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Bonjour,',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: StarlaneColors.gray600,
                              ),
                            ),
                            Text(
                              user?.name ?? 'Client',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: StarlaneColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/client/notifications'),
                        icon: Stack(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: StarlaneColors.gray700,
                              size: 28.sp,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: StarlaneColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildWelcomeCard() {
    return FadeTransition(
      opacity: _fadeAnimations[0],
      child: SlideTransition(
        position: _slideAnimations[0],
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: StarlaneColors.premiumGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: StarlaneColors.luxuryShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.diamond_rounded,
                    color: StarlaneColors.white,
                    size: 32.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Expériences Premium',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: StarlaneColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Découvrez des services de luxe exceptionnels, conçus pour célébrer la diversité et redéfinir l\'excellence.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: StarlaneColors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: StarlaneButton(
                      onPressed: () => context.push('/client/explore'),
                      text: 'Explorer',
                      style: StarlaneButtonStyle.secondary,
                      size: StarlaneButtonSize.medium,
                      icon: Icons.explore_rounded,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: StarlaneButton(
                      onPressed: () => context.push('/client/concierge'),
                      text: 'Concierge',
                      style: StarlaneButtonStyle.outline,
                      size: StarlaneButtonSize.medium,
                      icon: Icons.support_agent_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.search_rounded, 'title': 'Rechercher', 'route': '/client/search'},
      {'icon': Icons.bookmark_outline, 'title': 'Favoris', 'route': '/client/favorites'},
      {'icon': Icons.history_rounded, 'title': 'Historique', 'route': '/client/history'},
      {'icon': Icons.support_agent, 'title': 'Support', 'route': '/client/support'},
    ];

    return FadeTransition(
      opacity: _fadeAnimations[1],
      child: SlideTransition(
        position: _slideAnimations[1],
        child: Row(
          children: actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < actions.length - 1 ? 12.w : 0),
                child: StarlaneCard(
                  onTap: () => context.push(action['route'] as String),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: StarlaneColors.gold100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: StarlaneColors.gold600,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        action['title'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: StarlaneColors.gray700,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _fadeAnimations[2],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nos Services',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: StarlaneColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/client/services'),
                child: Text(
                  'Voir tout',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: StarlaneColors.gold600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.1,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final activityCategory = category['category'] as ActivityCategory;
            
            return FadeTransition(
              opacity: _fadeAnimations[(index % _fadeAnimations.length)],
              child: SlideTransition(
                position: _slideAnimations[(index % _slideAnimations.length)],
                child: StarlaneCard(
                  onTap: () => context.push('/client/category/${activityCategory.name}'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: BoxDecoration(
                          gradient: category['gradient'] as LinearGradient,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          color: StarlaneColors.white,
                          size: 32.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        activityCategory.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: StarlaneColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        activityCategory.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: StarlaneColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPopularActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _fadeAnimations[3],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activités Populaires',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: StarlaneColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/client/popular'),
                child: Text(
                  'Voir tout',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: StarlaneColors.gold600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _popularActivities.length,
            itemBuilder: (context, index) {
              final activity = _popularActivities[index];
              
              return FadeTransition(
                opacity: _fadeAnimations[(index + 4) % _fadeAnimations.length],
                child: SlideTransition(
                  position: _slideAnimations[(index + 4) % _slideAnimations.length],
                  child: Container(
                    width: 280.w,
                    margin: EdgeInsets.only(
                      right: index < _popularActivities.length - 1 ? 16.w : 0,
                    ),
                    child: StarlaneCard(
                      onTap: () => context.push('/client/activity/${activity['title']}'),
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                            child: Stack(
                              children: [
                                Container(
                                  height: 160.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: StarlaneColors.luxuryGradient,
                                  ),
                                  child: Icon(
                                    Icons.image_rounded,
                                    color: StarlaneColors.white,
                                    size: 48.sp,
                                  ),
                                ),
                                Positioned(
                                  top: 12.h,
                                  right: 12.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: StarlaneColors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: StarlaneColors.gold500,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          activity['rating'].toString(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: StarlaneColors.gray900,
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
                          // Content
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity['title'] as String,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: StarlaneColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: StarlaneColors.gray500,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        activity['location'] as String,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: StarlaneColors.gray600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '€${(activity['price'] as double).toStringAsFixed(0)}',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: StarlaneColors.gold600,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: StarlaneColors.luxuryGradient,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        'Réserver',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: StarlaneColors.white,
                                          fontWeight: FontWeight.w600,
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
      ],
    );
  }
}