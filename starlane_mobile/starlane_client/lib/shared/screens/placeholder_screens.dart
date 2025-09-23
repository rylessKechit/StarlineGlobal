import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../core/theme/starlane_colors.dart';
import '../../features/auth/bloc/auth_bloc.dart';

/// Temporary placeholder screens - will be replaced with real implementations
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Map<String, dynamic>> get services => const [
    {'title': 'Transport', 'icon': Icons.car_rental, 'color': StarlaneColors.emerald500},
    {'title': 'Corporate', 'icon': Icons.business, 'color': StarlaneColors.purple500},
    {'title': 'Lifestyle', 'icon': Icons.spa, 'color': StarlaneColors.gold600},
    {'title': 'Événements', 'icon': Icons.celebration, 'color': StarlaneColors.navy600},
    {'title': 'Sécurité', 'icon': Icons.security, 'color': StarlaneColors.emerald600},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.h,
                floating: false,
                pinned: true,
                backgroundColor: StarlaneColors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    user != null ? 'Bonjour ${user.name.split(' ').first}' : 'STARLANE GLOBAL',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: StarlaneColors.navy900,
                    ),
                  ),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                      context.go('/login');
                    },
                    icon: Icon(
                      Icons.logout_rounded,
                      color: StarlaneColors.gray600,
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final service = services[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: StarlaneColors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: StarlaneColors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: service['color'],
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Icon(
                                service['icon'],
                                color: StarlaneColors.white,
                                size: 30.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              service['title'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: StarlaneColors.gray900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: services.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: StarlaneColors.diversityGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_rounded,
                size: 80.sp,
                color: StarlaneColors.white,
              ),
              SizedBox(height: 16.h),
              Text(
                'Explorer',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: StarlaneColors.premiumGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_rounded,
                size: 80.sp,
                color: StarlaneColors.white,
              ),
              SizedBox(height: 16.h),
              Text(
                'Réservations',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: StarlaneColors.diversityGradient,
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 80.sp,
                    color: StarlaneColors.white,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    user?.name ?? 'Profil',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: StarlaneColors.white,
                    ),
                  ),
                  if (user != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: StarlaneColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}