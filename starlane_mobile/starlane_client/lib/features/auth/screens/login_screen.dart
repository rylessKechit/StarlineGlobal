import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/starlane_colors.dart';
import '../../../data/models/user.dart';
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: UserRole.client, // Toujours client pour cette app
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: StarlaneColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                _buildBody(),
                if (state is AuthLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      height: MediaQuery.of(context).size.height, // Prendre toute la hauteur
      decoration: const BoxDecoration(
        gradient: StarlaneColors.premiumGradient,
      ),
      child: SafeArea(
        bottom: false, // Pas de SafeArea en bas
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildLoginCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: 400.w,
        minHeight: MediaQuery.of(context).size.height * 0.7, // Au moins 70% de la hauteur
      ),
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: StarlaneColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: StarlaneColors.luxuryShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildEmailField(),
            SizedBox(height: 16.h),
            _buildPasswordField(),
            SizedBox(height: 16.h),
            _buildRememberMeRow(),
            SizedBox(height: 32.h),
            _buildLoginButton(),
            SizedBox(height: 20.h),
            _buildDivider(),
            SizedBox(height: 20.h),
            _buildSignUpLink(),
            SizedBox(height: 20.h), // Espace en bas pour éviter les coupures
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: const BoxDecoration(
            gradient: StarlaneColors.luxuryGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.diamond_rounded,
            size: 40.sp,
            color: StarlaneColors.white,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Connexion',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy900,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Accédez à vos services de luxe',
          style: TextStyle(
            fontSize: 16.sp,
            color: StarlaneColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'votre@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        filled: true,
        fillColor: StarlaneColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: StarlaneColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: StarlaneColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: StarlaneColors.gold500, width: 2),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Email requis';
        if (!value!.contains('@')) return 'Email invalide';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        filled: true,
        fillColor: StarlaneColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: StarlaneColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: StarlaneColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: StarlaneColors.gold500, width: 2),
        ),
      ),
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Mot de passe requis';
        if (value!.length < 6) return 'Au moins 6 caractères';
        return null;
      },
      onFieldSubmitted: (_) => _handleLogin(),
    );
  }

  Widget _buildRememberMeRow() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) => setState(() => _rememberMe = value ?? false),
              activeColor: StarlaneColors.gold500,
            ),
            Expanded(
              child: Text(
                'Se souvenir de moi',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: StarlaneColors.gray600,
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // TODO: Implement forgot password
            },
            child: Text(
              'Mot de passe oublié ?',
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.gold600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: StarlaneColors.gold500,
        foregroundColor: StarlaneColors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
      ),
      child: Text(
        'Se connecter',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'ou',
            style: TextStyle(
              color: StarlaneColors.gray500,
              fontSize: 14.sp,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ? ',
          style: TextStyle(
            color: StarlaneColors.gray600,
            fontSize: 14.sp,
          ),
        ),
        TextButton(
          onPressed: () => context.go('/register'),
          child: Text(
            'S\'inscrire',
            style: TextStyle(
              color: StarlaneColors.gold600,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}