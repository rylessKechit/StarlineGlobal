import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Core
import 'core/theme/starlane_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: StarlaneColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const StarlaneClientApp());
}

class StarlaneClientApp extends StatelessWidget {
  const StarlaneClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Starlane Global',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            fontFamily: 'SF Pro Display',
          ),
          routerConfig: _router,
        );
      },
    );
  }
}

// Configuration du routeur avec Shell Route
final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    
    // Shell Route pour la navigation bottom
    ShellRoute(
      builder: (context, state, child) => MainNavigation(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

// Navigation Bottom principale
class MainNavigation extends StatefulWidget {
  final Widget child;
  
  const MainNavigation({super.key, required this.child});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<NavigationItem> _navItems = [
    NavigationItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home,
      label: 'Accueil',
      route: '/home',
    ),
    NavigationItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Explorer',
      route: '/explore',
    ),
    NavigationItem(
      icon: Icons.bookmark_border_rounded,
      activeIcon: Icons.bookmark_rounded,
      label: 'Réservations',
      route: '/bookings',
    ),
    NavigationItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      route: '/profile',
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

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

// Splash Screen (inchangé)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

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
              Container(
                width: 120.w,
                height: 120.w,
                decoration: const BoxDecoration(
                  color: StarlaneColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.diamond_rounded,
                  size: 60.sp,
                  color: StarlaneColors.gold500,
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'STARLANE GLOBAL',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.white,
                  letterSpacing: 3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Luxury Services Platform',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: StarlaneColors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 32.h),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Login Screen (inchangé)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: StarlaneColors.premiumGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: const BoxDecoration(
                      color: StarlaneColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.diamond_rounded,
                      size: 40.sp,
                      color: StarlaneColors.gold500,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Bienvenue',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: StarlaneColors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Connectez-vous à votre espace premium',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: StarlaneColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48.h),
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: StarlaneColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: StarlaneColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mot de passe',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: StarlaneColors.gold500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: StarlaneColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Home Screen amélioré
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> services = const [
    {'title': 'Immobilier', 'icon': Icons.home, 'color': StarlaneColors.gold500},
    {'title': 'Aviation', 'icon': Icons.flight, 'color': StarlaneColors.navy500},
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            backgroundColor: StarlaneColors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'STARLANE GLOBAL',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.gray900,
                  letterSpacing: 1,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header Premium
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: StarlaneColors.luxuryGradient,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: StarlaneColors.cardShadow,
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
                              'Services Premium',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Découvrez des expériences de luxe exceptionnelles, conçues pour célébrer la diversité.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: StarlaneColors.white,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                
                // Section Services
                Text(
                  'Nos Services',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: StarlaneColors.gray900,
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
                    childAspectRatio: 1.0,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return GestureDetector(
                      onTap: () {
                        // Animation de feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${service['title']} sélectionné'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: service['color'],
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: StarlaneColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: StarlaneColors.cardShadow,
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
                            SizedBox(height: 4.h),
                            Text(
                              service['subtitle'] ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: StarlaneColors.gray600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 100.h), // Espace pour bottom nav
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// Écrans des autres onglets
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
              SizedBox(height: 8.h),
              Text(
                'Découvrez nos services de luxe',
                style: TextStyle(
                  fontSize: 16.sp,
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
          gradient: StarlaneColors.nightGradient,
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
                'Mes Réservations',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Gérez vos expériences de luxe',
                style: TextStyle(
                  fontSize: 16.sp,
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
          gradient: StarlaneColors.luxuryGradient,
        ),
        child: Center(
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
                'Mon Profil',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Gérez votre compte premium',
                style: TextStyle(
                  fontSize: 16.sp,
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