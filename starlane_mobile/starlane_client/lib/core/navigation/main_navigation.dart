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
      icon: Icons.home_outlined,
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
      icon: Icons.diamond_outlined, // ICÔNE VIP/PREMIUM
      activeIcon: Icons.diamond,     // ICÔNE VIP/PREMIUM ACTIVE
      label: 'Services VIP',
      route: RoutePaths.services,
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
              color: StarlaneColors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 84.h,
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _currentIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTap(index),
                    behavior: HitTestBehavior.translucent,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        // Effet spécial pour Services VIP
                        color: isSelected 
                            ? (index == 2 // Index des Services VIP
                                ? StarlaneColors.gold100.withOpacity(0.9)
                                : StarlaneColors.gold100.withOpacity(0.8))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        // Gradient pour Services VIP sélectionné
                        gradient: isSelected && index == 2
                            ? LinearGradient(
                                colors: [
                                  StarlaneColors.gold100,
                                  StarlaneColors.gold50,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône avec taille fixe et effet VIP
                          SizedBox(
                            height: 28.h,
                            width: 28.w,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isSelected ? item.activeIcon : item.icon,
                                key: ValueKey('${item.label}_$isSelected'),
                                color: isSelected 
                                    ? (index == 2 // Services VIP
                                        ? StarlaneColors.gold700 
                                        : StarlaneColors.gold600)
                                    : StarlaneColors.gray500,
                                size: 24.sp,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 4.h),
                          
                          // Label avec taille fixe
                          SizedBox(
                            height: 16.h,
                            child: Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected 
                                    ? (index == 2 // Services VIP
                                        ? StarlaneColors.gold700 
                                        : StarlaneColors.gold700)
                                    : StarlaneColors.gray500,
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
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