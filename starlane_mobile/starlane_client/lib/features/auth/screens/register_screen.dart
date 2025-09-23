import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/starlane_colors.dart';
import '../../../data/models/user.dart';
import '../bloc/auth_bloc.dart';

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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
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
      _showErrorSnackBar('Vous devez accepter les termes et conditions');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
          role: UserRole.client, // Toujours client pour cette app
          location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
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
      decoration: const BoxDecoration(
        gradient: StarlaneColors.premiumGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildRegisterCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400.w),
      margin: EdgeInsets.symmetric(horizontal: 0.w),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildNameField(),
            SizedBox(height: 16.h),
            _buildEmailField(),
            SizedBox(height: 16.h),
            _buildPasswordField(),
            SizedBox(height: 16.h),
            _buildConfirmPasswordField(),
            SizedBox(height: 16.h),
            _buildPhoneField(),
            SizedBox(height: 16.h),
            _buildLocationField(),
            SizedBox(height: 20.h),
            _buildTermsCheckbox(),
            SizedBox(height: 24.h),
            _buildRegisterButton(),
            SizedBox(height: 16.h),
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 70.w,
          height: 70.w,
          decoration: const BoxDecoration(
            gradient: StarlaneColors.luxuryGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.diamond_rounded,
            size: 35.sp,
            color: StarlaneColors.white,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Créer un compte',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy900,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Rejoignez l\'univers du luxe',
          style: TextStyle(
            fontSize: 15.sp,
            color: StarlaneColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nom complet',
        hintText: 'Jean Dupont',
        prefixIcon: const Icon(Icons.person_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Nom requis';
        if (value!.length < 2) return 'Nom trop court';
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'votre@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Mot de passe requis';
        if (value!.length < 6) return 'Au moins 6 caractères';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirmer le mot de passe',
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Confirmation requise';
        if (value != _passwordController.text) return 'Mots de passe différents';
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Téléphone (optionnel)',
        hintText: '+33 6 12 34 56 78',
        prefixIcon: const Icon(Icons.phone_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Ville (optionnel)',
        hintText: 'Paris, France',
        prefixIcon: const Icon(Icons.location_on_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleRegister(),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) => setState(() => _acceptTerms = value ?? false),
          activeColor: StarlaneColors.gold500,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13.sp,
                  color: StarlaneColors.gray600,
                ),
                children: [
                  const TextSpan(text: 'J\'accepte les '),
                  TextSpan(
                    text: 'termes et conditions',
                    style: TextStyle(
                      color: StarlaneColors.gold600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: ' et la '),
                  TextSpan(
                    text: 'politique de confidentialité',
                    style: TextStyle(
                      color: StarlaneColors.gold600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _handleRegister,
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
        'Créer mon compte',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte ? ',
          style: TextStyle(
            color: StarlaneColors.gray600,
            fontSize: 14.sp,
          ),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(
            'Se connecter',
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