import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../core/router/route_paths.dart';
import '../../../shared/widgets/starlane_widgets.dart';

// Feature imports
import '../bloc/auth_bloc.dart';
import '../../../data/models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  late AnimationController _animationController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoAnimation;
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _logoController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _logoController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_acceptTerms) {
      _showSnackBar('Vous devez accepter les termes et conditions', isError: true);
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      // Hide keyboard
      FocusScope.of(context).unfocus();
      
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim().isNotEmpty 
            ? _phoneController.text.trim() 
            : null,
          role: UserRole.client,
          location: _locationController.text.trim().isNotEmpty 
            ? _locationController.text.trim() 
            : null,
        ),
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? StarlaneColors.error : StarlaneColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            _showSnackBar(state.message, isError: true);
          } else if (state is AuthAuthenticated) {
            _showSnackBar('Bienvenue ${state.user.name} ! Votre compte a été créé avec succès.');
            context.go(RoutePaths.home);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                StarlaneColors.emerald900,
                StarlaneColors.emerald700,
                StarlaneColors.gold800,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Bouton retour + Logo
                      SizedBox(
                        height: 200.h,
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            
                            // Bouton retour
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => context.go(RoutePaths.login),
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: StarlaneColors.white,
                                    size: 24.sp,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            
                            // Logo animé
                            Expanded(
                              child: ScaleTransition(
                                scale: _logoAnimation,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            StarlaneColors.gold400,
                                            StarlaneColors.gold600,
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: StarlaneColors.gold500.withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.person_add_rounded,
                                        size: 40.sp,
                                        color: StarlaneColors.white,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Rejoignez',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: StarlaneColors.white,
                                      ),
                                    ),
                                    Text(
                                      'STARLANE GLOBAL',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300,
                                        color: StarlaneColors.gold300,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Formulaire d'inscription
                      Expanded(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              padding: EdgeInsets.all(24.w),
                              decoration: BoxDecoration(
                                color: StarlaneColors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: StarlaneColors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Créer un compte',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: StarlaneColors.navy700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                    SizedBox(height: 20.h),
                                    
                                    // Champ Nom
                                    StarlaneTextField(
                                      controller: _nameController,
                                      label: 'Nom complet',
                                      hintText: 'Jean Dupont',
                                      prefixIcon: Icons.person_outline,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Nom requis';
                                        }
                                        if (value.trim().length < 2) {
                                          return 'Minimum 2 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    SizedBox(height: 12.h),
                                    
                                    // Champ Email
                                    StarlaneTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      hintText: 'votre@email.com',
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email requis';
                                        }
                                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                          return 'Email invalide';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    SizedBox(height: 12.h),
                                    
                                    // Champ Téléphone (optionnel)
                                    StarlaneTextField(
                                      controller: _phoneController,
                                      label: 'Téléphone (optionnel)',
                                      hintText: '+33 1 23 45 67 89',
                                      prefixIcon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          if (value.trim().length < 8) {
                                            return 'Numéro trop court';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    SizedBox(height: 12.h),
                                    
                                    // Champ Mot de passe
                                    StarlaneTextField(
                                      controller: _passwordController,
                                      label: 'Mot de passe',
                                      hintText: 'Minimum 6 caractères',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.next,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                        icon: Icon(
                                          _obscurePassword 
                                            ? Icons.visibility_off_outlined 
                                            : Icons.visibility_outlined,
                                          color: StarlaneColors.gray500,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Mot de passe requis';
                                        }
                                        if (value.length < 6) {
                                          return 'Minimum 6 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    SizedBox(height: 12.h),
                                    
                                    // Champ Confirmation mot de passe
                                    StarlaneTextField(
                                      controller: _confirmPasswordController,
                                      label: 'Confirmer le mot de passe',
                                      hintText: 'Retapez votre mot de passe',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: _obscureConfirmPassword,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _handleRegister(),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirmPassword = !_obscureConfirmPassword;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureConfirmPassword 
                                            ? Icons.visibility_off_outlined 
                                            : Icons.visibility_outlined,
                                          color: StarlaneColors.gray500,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Confirmation requise';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Mots de passe différents';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    SizedBox(height: 16.h),
                                    
                                    // Accepter les termes
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                          height: 20.w,
                                          child: Checkbox(
                                            value: _acceptTerms,
                                            onChanged: (value) {
                                              setState(() {
                                                _acceptTerms = value ?? false;
                                              });
                                            },
                                            activeColor: StarlaneColors.gold500,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: StarlaneColors.gray600,
                                              ),
                                              children: [
                                                const TextSpan(text: 'J\'accepte les '),
                                                TextSpan(
                                                  text: 'Termes et Conditions',
                                                  style: TextStyle(
                                                    color: StarlaneColors.gold600,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                                const TextSpan(text: ' et la '),
                                                TextSpan(
                                                  text: 'Politique de Confidentialité',
                                                  style: TextStyle(
                                                    color: StarlaneColors.gold600,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 20.h),
                                    
                                    // Bouton d'inscription
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        final isLoading = state is AuthLoading;
                                        
                                        return StarlaneButton(
                                          text: 'Créer mon compte',
                                          onPressed: isLoading ? null : _handleRegister,
                                          isLoading: isLoading,
                                          style: StarlaneButtonStyle.primary,
                                        );
                                      },
                                    ),
                                    
                                    SizedBox(height: 16.h),
                                    
                                    // Divider
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: StarlaneColors.gray300,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                                          child: Text(
                                            'ou',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: StarlaneColors.gray500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: StarlaneColors.gray300,
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 12.h),
                                    
                                    // Bouton connexion
                                    StarlaneButton(
                                      text: 'J\'ai déjà un compte',
                                      onPressed: () {
                                        context.go(RoutePaths.login);
                                      },
                                      style: StarlaneButtonStyle.outline,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Footer
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(
                          'Rejoignez des milliers de clients qui font confiance\nà Starlane Global pour leurs services de luxe',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: StarlaneColors.white.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
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
    );
  }
}