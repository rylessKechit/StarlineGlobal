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

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      begin: const Offset(0, 0.2),
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
      FocusScope.of(context).unfocus();
      
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: UserRole.client,
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
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                             MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Spacer flexible pour centrer le contenu
                        const Flexible(flex: 1, child: SizedBox()),
                        
                        // Logo
                        ScaleTransition(
                          scale: _logoAnimation,
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: const BoxDecoration(
                              gradient: StarlaneColors.luxuryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.star,
                              size: 40.sp,
                              color: StarlaneColors.white,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 12.h),
                        
                        // Titre marque
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                'STARLANE',
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  color: StarlaneColors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                'GLOBAL',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: StarlaneColors.gold300,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Carte de connexion
                        SlideTransition(
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
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Titre formulaire
                                    Text(
                                      'Bon retour !',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: StarlaneColors.navy900,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Connectez-vous à votre compte',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: StarlaneColors.gray600,
                                      ),
                                    ),
                                    
                                    SizedBox(height: 24.h),
                                    
                                    // Email
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: StarlaneColors.navy700,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: StarlaneColors.navy900,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'votre@email.com',
                                        hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: StarlaneColors.gray400,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: StarlaneColors.gray400,
                                          size: 20.sp,
                                        ),
                                        filled: true,
                                        fillColor: StarlaneColors.gray50,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: BorderSide(color: StarlaneColors.gray300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: BorderSide(color: StarlaneColors.gray300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: BorderSide(color: StarlaneColors.gold500, width: 2),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Email requis';
                                        }
                                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                                          return 'Email invalide';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    SizedBox(height: 16.h),
                                    
                                    // Mot de passe
                                    Text(
                                      'Mot de passe',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: StarlaneColors.navy700,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: StarlaneColors.navy900,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '••••••••',
                                        hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: StarlaneColors.gray400,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: StarlaneColors.gray400,
                                          size: 20.sp,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() => _obscurePassword = !_obscurePassword);
                                          },
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                            color: StarlaneColors.gray400,
                                            size: 20.sp,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: StarlaneColors.gray50,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: BorderSide(color: StarlaneColors.gray300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: BorderSide(color: StarlaneColors.gray300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                          borderSide: BorderSide(color: StarlaneColors.gold500, width: 2),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Mot de passe requis';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) => _handleLogin(),
                                    ),
                                    
                                    SizedBox(height: 16.h),
                                    
                                    // Bouton de connexion
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 44.h,
                                          child: ElevatedButton(
                                            onPressed: state is AuthLoading ? null : _handleLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: StarlaneColors.gold500,
                                              foregroundColor: StarlaneColors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: state is AuthLoading
                                                ? SizedBox(
                                                    width: 18.w,
                                                    height: 18.w,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.white),
                                                    ),
                                                  )
                                                : Text(
                                                    'Se connecter',
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    
                                    SizedBox(height: 12.h),
                                    
                                    // Bouton créer un compte
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44.h,
                                      child: TextButton(
                                        onPressed: () => context.go(RoutePaths.register),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.r),
                                            side: BorderSide(
                                              color: StarlaneColors.gold500.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Créer un compte',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: StarlaneColors.gold600,
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
                        
                        SizedBox(height: 12.h),
                        
                        // Conditions d'utilisation
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'En vous connectant, vous acceptez nos conditions d\'utilisation',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: StarlaneColors.white.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // Spacer flexible
                        const Flexible(flex: 1, child: SizedBox()),
                      ],
                    ),
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