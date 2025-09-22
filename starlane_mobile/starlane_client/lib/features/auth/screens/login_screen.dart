import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/starlane_colors.dart';
import '../../../data/models/user.dart';
import '../../../shared/widgets/starlane_button.dart';
import '../../../shared/widgets/starlane_text_field.dart';
import '../../../shared/widgets/loading_overlay.dart';
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
                context.go('/client');
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
            color: StarlaneColors.white,
            size: 40.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'STARLANE GLOBAL',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy800,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Luxury Services Platform',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: StarlaneColors.gray600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Je suis',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: StarlaneColors.gray700,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: UserRole.values.where((role) => role != UserRole.admin).map((role) {
            final isSelected = _selectedRole == role;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRole = role),
                child: Container(
                  margin: EdgeInsets.only(right: role != UserRole.prestataire ? 8.w : 0),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? StarlaneColors.gold100 : StarlaneColors.gray50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? StarlaneColors.gold500 : StarlaneColors.gray200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        role == UserRole.client ? Icons.person : Icons.business,
                        color: isSelected ? StarlaneColors.gold600 : StarlaneColors.gray500,
                        size: 24.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        role.displayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? StarlaneColors.gold700 : StarlaneColors.gray600,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return StarlaneTextField(
      controller: _emailController,
      label: 'Email',
      hintText: 'votre@email.com',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Email requis';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Email invalide';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return StarlaneTextField(
      controller: _passwordController,
      label: 'Mot de passe',
      hintText: '••••••••',
      prefixIcon: Icons.lock_outlined,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _handleLogin(),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility : Icons.visibility_off,
          color: StarlaneColors.gray500,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Mot de passe requis';
        }
        if (value!.length < 6) {
          return 'Au moins 6 caractères';
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
          onChanged: (value) => setState(() => _rememberMe = value ?? false),
          activeColor: StarlaneColors.gold500,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          'Se souvenir de moi',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: StarlaneColors.gray600,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => context.push('/forgot-password'),
          child: Text(
            'Mot de passe oublié ?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
      onPressed: _handleLogin,
      text: 'Se connecter',
      style: StarlaneButtonStyle.primary,
      size: StarlaneButtonSize.large,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: StarlaneColors.gray200)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'ou',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: StarlaneColors.gray500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: StarlaneColors.gray200)),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: StarlaneColors.gray600,
          ),
        ),
        TextButton(
          onPressed: () => context.push('/register'),
          child: Text(
            'S\'inscrire',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: StarlaneColors.gold600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: StarlaneColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}