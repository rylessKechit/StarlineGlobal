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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoAnimation;
  
  bool _obscurePassword = true;
  bool _rememberMe = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Hide keyboard
      FocusScope.of(context).unfocus();
      
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
            _showSnackBar('Bienvenue ${state.user.name} !');
            context.go(RoutePaths.home);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                StarlaneColors.navy900,
                StarlaneColors.navy700,
                StarlaneColors.gold900,
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
                      SizedBox(height: 60.h),
                      
                      // Logo animé
                      Expanded(
                        flex: 2,
                        child: ScaleTransition(
                          scale: _logoAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100.w,
                                height: 100.w,
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
                                  Icons.star_rounded,
                                  size: 50.sp,
                                  color: StarlaneColors.white,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'STARLANE',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: StarlaneColors.white,
                                  letterSpacing: 3,
                                ),
                              ),
                              Text(
                                'GLOBAL',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w300,
                                  color: StarlaneColors.gold300,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Formulaire de connexion
                      Expanded(
                        flex: 3,
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
                                      'Bon retour !',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: StarlaneColors.navy700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                    Text(
                                      'Connectez-vous à votre compte',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: StarlaneColors.gray600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                    SizedBox(height: 32.h),
                                    
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
                                    
                                    SizedBox(height: 16.h),
                                    
                                    // Champ Mot de passe
                                    StarlaneTextField(
                                      controller: _passwordController,
                                      label: 'Mot de passe',
                                      hintText: '••••••••',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _handleLogin(),
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
                                    
                                    SizedBox(height: 16.h),
                                    
                                    // Se souvenir de moi & Mot de passe oublié
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 20.w,
                                              height: 20.w,
                                              child: Checkbox(
                                                value: _rememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _rememberMe = value ?? false;
                                                  });
                                                },
                                                activeColor: StarlaneColors.gold500,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'Se souvenir',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: StarlaneColors.gray600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _showSnackBar('Fonctionnalité à venir', isError: true);
                                          },
                                          child: Text(
                                            'Mot de passe oublié ?',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: StarlaneColors.gold600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 24.h),
                                    
                                    // Bouton de connexion
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        final isLoading = state is AuthLoading;
                                        
                                        return StarlaneButton(
                                          text: 'Se connecter',
                                          onPressed: isLoading ? null : _handleLogin,
                                          isLoading: isLoading,
                                          style: StarlaneButtonStyle.primary,
                                        );
                                      },
                                    ),
                                    
                                    SizedBox(height: 24.h),
                                    
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
                                    
                                    SizedBox(height: 16.h),
                                    
                                    // Bouton inscription
                                    StarlaneButton(
                                      text: 'Créer un compte',
                                      onPressed: () {
                                        context.go(RoutePaths.register);
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
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          'En vous connectant, vous acceptez nos\nConditions d\'utilisation et notre Politique de confidentialité',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: StarlaneColors.white.withOpacity(0.7),
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