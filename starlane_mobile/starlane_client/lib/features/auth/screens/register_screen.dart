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
  final _companyNameController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  UserRole _selectedRole = UserRole.client;
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
    _companyNameController.dispose();
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
          phone: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
          role: _selectedRole,
          location: _locationController.text.trim().isEmpty 
            ? null 
            : _locationController.text.trim(),
          companyName: _selectedRole == UserRole.prestataire
            ? _companyNameController.text.trim().isEmpty 
              ? null 
              : _companyNameController.text.trim()
            : null,
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
              child: Container(
                decoration: const BoxDecoration(
                  gradient: StarlaneColors.diversityGradient,
                ),
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildRegisterCard(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegisterCard() {
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
            SizedBox(height: 24.h),
            _buildRoleSelector(),
            SizedBox(height: 20.h),
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
            if (_selectedRole == UserRole.prestataire) ...[
              SizedBox(height: 16.h),
              _buildCompanyNameField(),
            ],
            SizedBox(height: 20.h),
            _buildTermsCheckbox(),
            SizedBox(height: 24.h),
            _buildRegisterButton(),
            SizedBox(height: 16.h),
            _buildSignInLink(),
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
            gradient: StarlaneColors.diversityGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add_rounded,
            size: 35.sp,
            color: StarlaneColors.white,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Créer un compte',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy900,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Rejoignez la communauté Starlane',
          style: TextStyle(
            fontSize: 14.sp,
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

  Widget _buildNameField() {
    return StarlaneTextField(
      controller: _nameController,
      label: 'Nom complet',
      prefixIcon: Icons.person_outlined,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Veuillez saisir votre nom';
        }
        if (value.trim().length < 2) {
          return 'Le nom doit contenir au moins 2 caractères';
        }
        return null;
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
          return 'Veuillez saisir un mot de passe';
        }
        if (value.length < 6) {
          return 'Le mot de passe doit contenir au moins 6 caractères';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return StarlaneTextField(
      controller: _confirmPasswordController,
      label: 'Confirmer le mot de passe',
      obscureText: _obscureConfirmPassword,
      prefixIcon: Icons.lock_outlined,
      suffixIcon: _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
      onSuffixIconPressed: () {
        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez confirmer votre mot de passe';
        }
        if (value != _passwordController.text) {
          return 'Les mots de passe ne correspondent pas';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return StarlaneTextField(
      controller: _phoneController,
      label: 'Téléphone (optionnel)',
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone_outlined,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.length < 10) {
            return 'Veuillez saisir un numéro valide';
          }
        }
        return null;
      },
    );
  }

  Widget _buildLocationField() {
    return StarlaneTextField(
      controller: _locationController,
      label: 'Localisation (optionnel)',
      prefixIcon: Icons.location_on_outlined,
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 2) {
          return 'La localisation doit contenir au moins 2 caractères';
        }
        return null;
      },
    );
  }

  Widget _buildCompanyNameField() {
    return StarlaneTextField(
      controller: _companyNameController,
      label: 'Nom de l\'entreprise',
      prefixIcon: Icons.business_outlined,
      validator: (value) {
        if (_selectedRole == UserRole.prestataire) {
          if (value == null || value.trim().isEmpty) {
            return 'Veuillez saisir le nom de votre entreprise';
          }
          if (value.trim().length < 2) {
            return 'Le nom doit contenir au moins 2 caractères';
          }
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() => _acceptTerms = value ?? false);
          },
          activeColor: StarlaneColors.emerald500,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: StarlaneColors.gray700,
                  ),
                  children: [
                    const TextSpan(text: 'J\'accepte les '),
                    TextSpan(
                      text: 'termes et conditions',
                      style: TextStyle(
                        color: StarlaneColors.emerald600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: TextStyle(
                        color: StarlaneColors.emerald600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return StarlaneButton(
      text: 'Créer mon compte',
      onPressed: _handleRegister,
      variant: StarlaneButtonVariant.secondary,
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte ? ',
          style: TextStyle(
            fontSize: 14.sp,
            color: StarlaneColors.gray600,
          ),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
          ),
          child: Text(
            'Se connecter',
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.emerald600,
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