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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Contrôleurs pour l'édition du profil
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isEditing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Modifier le profil',
      'subtitle': 'Informations personnelles',
      'icon': Icons.edit_rounded,
      'color': StarlaneColors.emerald500,
      'action': 'edit_profile',
    },
    {
      'title': 'Mes favoris',
      'subtitle': 'Services sauvegardés',
      'icon': Icons.favorite_rounded,
      'color': StarlaneColors.error,
      'action': 'favorites',
    },
    {
      'title': 'Historique des paiements',
      'subtitle': 'Transactions et factures',
      'icon': Icons.payment_rounded,
      'color': StarlaneColors.navy500,
      'action': 'payments',
    },
    {
      'title': 'Notifications',
      'subtitle': 'Préférences de notifications',
      'icon': Icons.notifications_rounded,
      'color': StarlaneColors.gold500,
      'action': 'notifications',
    },
    {
      'title': 'Aide & Support',
      'subtitle': 'Centre d\'aide et contact',
      'icon': Icons.help_rounded,
      'color': StarlaneColors.purple500,
      'action': 'help',
    },
    {
      'title': 'Paramètres',
      'subtitle': 'Sécurité et confidentialité',
      'icon': Icons.settings_rounded,
      'color': StarlaneColors.gray600,
      'action': 'settings',
    },
  ];

  // Mock stats - À remplacer par de vraies données
  final Map<String, dynamic> _userStats = {
    'totalBookings': 12,
    'totalSpent': 15600.0,
    'averageRating': 4.8,
    'memberSince': DateTime(2023, 6, 15),
  };

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
      8,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.08,
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
            index * 0.08,
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initializeControllers(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';
    _locationController.text = user.location ?? '';
  }

  void _toggleEditMode(User? user) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing && user != null) {
        _initializeControllers(user);
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Appel API pour mettre à jour le profil
      context.read<AuthBloc>().add(
        AuthProfileUpdateRequested(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isNotEmpty 
            ? _phoneController.text.trim() 
            : null,
          location: _locationController.text.trim().isNotEmpty 
            ? _locationController.text.trim() 
            : null,
        ),
      );
      
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil mis à jour avec succès'),
          backgroundColor: StarlaneColors.success,
        ),
      );
    }
  }

  void _onMenuItemTap(String action, User? user) {
    switch (action) {
      case 'edit_profile':
        _toggleEditMode(user);
        break;
      case 'favorites':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Favoris - À implémenter'),
            backgroundColor: StarlaneColors.error,
          ),
        );
        break;
      case 'payments':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Historique des paiements - À implémenter'),
            backgroundColor: StarlaneColors.navy500,
          ),
        );
        break;
      case 'notifications':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paramètres de notifications - À implémenter'),
            backgroundColor: StarlaneColors.gold500,
          ),
        );
        break;
      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aide & Support - À implémenter'),
            backgroundColor: StarlaneColors.purple500,
          ),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paramètres - À implémenter'),
            backgroundColor: StarlaneColors.gray600,
          ),
        );
        break;
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Se déconnecter',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy700,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: TextStyle(
            fontSize: 14.sp,
            color: StarlaneColors.gray600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: TextStyle(color: StarlaneColors.gray600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go(RoutePaths.login);
            },
            child: Text(
              'Se déconnecter',
              style: TextStyle(
                color: StarlaneColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: StarlaneColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;

            return CustomScrollView(
              slivers: [
                // App Bar avec profil utilisateur
                SliverAppBar(
                  expandedHeight: 280.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: StarlaneColors.purple500,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            StarlaneColors.purple400,
                            StarlaneColors.purple600,
                            StarlaneColors.navy600,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Avatar
                                  Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: StarlaneColors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: StarlaneColors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: user?.avatar != null
                                      ? ClipOval(
                                          child: StarlaneImage(
                                            imageUrl: user!.avatar!,
                                            width: 100.w,
                                            height: 100.w,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                StarlaneColors.gold400,
                                                StarlaneColors.gold600,
                                              ],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.person_rounded,
                                            size: 50.sp,
                                            color: StarlaneColors.white,
                                          ),
                                        ),
                                  ),
                                  
                                  SizedBox(height: 16.h),
                                  
                                  // Nom utilisateur
                                  Text(
                                    user?.name ?? 'Utilisateur',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: StarlaneColors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  
                                  SizedBox(height: 4.h),
                                  
                                  // Email
                                  Text(
                                    user?.email ?? 'email@exemple.com',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: StarlaneColors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  
                                  SizedBox(height: 8.h),
                                  
                                  // Niveau membre
                                  StarlaneBadge(
                                    text: 'Membre Premium',
                                    backgroundColor: StarlaneColors.gold500,
                                    textColor: StarlaneColors.white,
                                    icon: Icons.star_rounded,
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
                
                // Statistiques utilisateur
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: SlideTransition(
                      position: _slideAnimations[1],
                      child: FadeTransition(
                        opacity: _fadeAnimations[1],
                        child: StarlaneCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mes Statistiques',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: StarlaneColors.navy700,
                                ),
                              ),
                              
                              SizedBox(height: 16.h),
                              
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${_userStats['totalBookings']}',
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            color: StarlaneColors.emerald500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Réservations',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: StarlaneColors.gray600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40.h,
                                    color: StarlaneColors.gray300,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${_userStats['totalSpent'].toInt()}€',
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            color: StarlaneColors.gold500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Dépensé',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: StarlaneColors.gray600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40.h,
                                    color: StarlaneColors.gray300,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              size: 20.sp,
                                              color: StarlaneColors.gold500,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              '${_userStats['averageRating']}',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                                color: StarlaneColors.purple500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Note moyenne',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: StarlaneColors.gray600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Formulaire d'édition ou menu
                _isEditing ? 
                  // Formulaire d'édition
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: SlideTransition(
                        position: _slideAnimations[2],
                        child: FadeTransition(
                          opacity: _fadeAnimations[2],
                          child: StarlaneCard(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Modifier le profil',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: StarlaneColors.navy700,
                                    ),
                                  ),
                                  
                                  SizedBox(height: 20.h),
                                  
                                  StarlaneTextField(
                                    controller: _nameController,
                                    label: 'Nom complet',
                                    prefixIcon: Icons.person_outline,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Nom requis';
                                      }
                                      return null;
                                    },
                                  ),
                                  
                                  SizedBox(height: 16.h),
                                  
                                  StarlaneTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    prefixIcon: Icons.email_outlined,
                                    readOnly: true, // L'email ne peut pas être modifié
                                  ),
                                  
                                  SizedBox(height: 16.h),
                                  
                                  StarlaneTextField(
                                    controller: _phoneController,
                                    label: 'Téléphone',
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  
                                  SizedBox(height: 16.h),
                                  
                                  StarlaneTextField(
                                    controller: _locationController,
                                    label: 'Localisation',
                                    prefixIcon: Icons.location_on_outlined,
                                  ),
                                  
                                  SizedBox(height: 24.h),
                                  
                                  Row(
                                    children: [
                                      Expanded(
                                        child: StarlaneButton(
                                          text: 'Annuler',
                                          onPressed: () => _toggleEditMode(user),
                                          style: StarlaneButtonStyle.outline,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: StarlaneButton(
                                          text: 'Sauvegarder',
                                          onPressed: _saveProfile,
                                          style: StarlaneButtonStyle.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ) :
                  // Menu principal
                  SliverPadding(
                    padding: EdgeInsets.all(20.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = _menuItems[index];
                          
                          return SlideTransition(
                            position: _slideAnimations[index + 2],
                            child: FadeTransition(
                              opacity: _fadeAnimations[index + 2],
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12.h),
                                child: StarlaneCard(
                                  onTap: () => _onMenuItemTap(item['action'], user),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48.w,
                                        height: 48.w,
                                        decoration: BoxDecoration(
                                          color: (item['color'] as Color).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Icon(
                                          item['icon'],
                                          color: item['color'],
                                          size: 24.sp,
                                        ),
                                      ),
                                      
                                      SizedBox(width: 16.w),
                                      
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'],
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: StarlaneColors.navy700,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              item['subtitle'],
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: StarlaneColors.gray500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16.sp,
                                        color: StarlaneColors.gray400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: _menuItems.length,
                      ),
                    ),
                  ),
                
                // Bouton de déconnexion
                if (!_isEditing)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: SlideTransition(
                        position: _slideAnimations[7],
                        child: FadeTransition(
                          opacity: _fadeAnimations[7],
                          child: StarlaneButton(
                            text: 'Se déconnecter',
                            onPressed: _logout,
                            style: StarlaneButtonStyle.outline,
                            icon: Icons.logout_rounded,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Informations de version
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Text(
                          'Starlane Global v1.0.0',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: StarlaneColors.gray500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Services de luxe premium',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: StarlaneColors.gray400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}