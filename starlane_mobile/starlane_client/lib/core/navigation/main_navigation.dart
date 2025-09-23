import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../theme/starlane_colors.dart';
import '../router/route_paths.dart';
import 'navigation_item.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  
  const MainNavigation({super.key, required this.child});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<NavigationItem> _navItems = const [
    NavigationItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home,
      label: 'Accueil',
      route: RoutePaths.home,
    ),
    NavigationItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Explorer',
      route: RoutePaths.explore,
    ),
    NavigationItem(
      icon: Icons.bookmark_border_rounded,
      activeIcon: Icons.bookmark_rounded,
      label: 'Réservations',
      route: RoutePaths.bookings,
    ),
    NavigationItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      route: RoutePaths.profile,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    final newIndex = _navItems.indexWhere((item) => item.route == location);
    if (newIndex != -1) {
      setState(() => _currentIndex = newIndex);
    }
  }

  void _onTap(int index) {
    if (index != _currentIndex) {
      context.go(_navItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: StarlaneColors.white,
          boxShadow: [
            BoxShadow(
              color: StarlaneColors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _currentIndex;

                return GestureDetector(
                  onTap: () => _onTap(index),
                  behavior: HitTestBehavior.translucent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? StarlaneColors.gold100 : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            key: ValueKey('${item.label}_$isSelected'),
                            color: isSelected ? StarlaneColors.gold600 : StarlaneColors.gray500,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected ? StarlaneColors.gold700 : StarlaneColors.gray500,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}