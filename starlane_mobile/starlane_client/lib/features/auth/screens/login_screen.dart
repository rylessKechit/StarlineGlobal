import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/starlane_colors.dart';
import '../../../data/models/user.dart';
import '../../../shared/widgets/starlane_button.dart';
import '../../../shared/widgets/starlane_text_field.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/role_selector.dart';
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
  
  UserRole _selectedRole = UserRole.client;
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
          role: _selectedRole,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Redirection basée sur le rôle
            switch (state.user.role) {
              case UserRole.client:
                context.go('/home');
                break;
              case UserRole.prestataire:
                context.go('/provider');
                break;
              case UserRole.admin:
                context.go('/admin');
                break;
            }
          } else if (state is AuthFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is AuthLoading,
              child: _buildBody(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: StarlaneColors.premiumGradient,
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildLoginCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      constraints: BoxConstraints(maxWidth: 400.w),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: StarlaneColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: StarlaneColors.luxuryShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildRoleSelector(),
            SizedBox(height: 24.h),
            _buildEmailField(),
            SizedBox(height: 16.h),
            _buildPasswordField(),
            SizedBox(height: 16.h),
            _buildRememberMeRow(),
            SizedBox(height: 32.h),
            _buildLoginButton(),
            SizedBox(height: 16.h),
            _buildDivider(),
            SizedBox(height: 16.h),
            _buildSignUpLink(),
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
          'Accédez à votre compte Starlane',
          style: TextStyle(
            fontSize: 16.sp,
            color: StarlaneColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return RoleSelector(
      selectedRole: _selectedRole,
      onRoleChanged: (role) {
        setState(() => _selectedRole = role);
      },
    );
  }

  Widget _buildEmailField() {
    return StarlaneTextField(
      controller: _emailController,
      label: 'Email',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir votre email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Veuillez saisir un email valide';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return StarlaneTextField(
      controller: _passwordController,
      label: 'Mot de passe',
      obscureText: _obscurePassword,
      prefixIcon: Icons.lock_outlined,
      suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
      onSuffixIconPressed: () {
        setState(() => _obscurePassword = !_obscurePassword);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir votre mot de passe';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() => _rememberMe = value ?? false);
          },
          activeColor: StarlaneColors.gold500,
        ),
        Text(
          'Se souvenir de moi',
          style: TextStyle(
            fontSize: 14.sp,
            color: StarlaneColors.gray700,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            // TODO: Navigation vers mot de passe oublié
          },
          child: Text(
            'Mot de passe oublié ?',
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.gold600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return StarlaneButton(
      text: 'Se connecter',
      onPressed: _handleLogin,
      variant: StarlaneButtonVariant.primary,
    );
  }

  Widget _buildDivider() {
    return Row(
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
            'OU',
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.gray500,
              fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ? ',
          style: TextStyle(
            fontSize: 14.sp,
            color: StarlaneColors.gray600,
          ),
        ),
        TextButton(
          onPressed: () {
            context.go('/register');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
          ),
          child: Text(
            'Créer un compte',
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.gold600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: StarlaneColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}