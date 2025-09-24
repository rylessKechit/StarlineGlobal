import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../features/auth/bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      appBar: AppBar(
        title: Text(
          'Mon Profil',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy900,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Logout
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            icon: Icon(
              Icons.logout,
              color: StarlaneColors.error,
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Avatar et infos utilisateur
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: StarlaneColors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: StarlaneColors.navy100,
                          child: Text(
                            state.user.name.isNotEmpty 
                                ? state.user.name[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: StarlaneColors.navy600,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.user.name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: StarlaneColors.navy900,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          state.user.email,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: StarlaneColors.gray600,
                          ),
                        ),
                        if (state.user.phone != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            state.user.phone!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: StarlaneColors.gray600,
                            ),
                          ),
                        ],
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: StarlaneColors.gold100,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            state.user.role.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: StarlaneColors.gold700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Options du menu
                  Container(
                    decoration: BoxDecoration(
                      color: StarlaneColors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Modifier le profil',
                          onTap: () {
                            // TODO: Ouvrir modal d'édition
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Édition du profil - À implémenter'),
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Paramètres de notifications - À implémenter'),
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.security_outlined,
                          title: 'Sécurité',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Paramètres de sécurité - À implémenter'),
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Aide et support',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Support client - À implémenter'),
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Se déconnecter',
                          textColor: StarlaneColors.error,
                          onTap: () {
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Version
                  Text(
                    'Starlane Global v1.0.0',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: StarlaneColors.gray500,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? StarlaneColors.gray600,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: textColor ?? StarlaneColors.navy900,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: StarlaneColors.gray400,
      ),
      onTap: onTap,
    );
  }
  
  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: StarlaneColors.gray200,
      indent: 56.w,
    );
  }
}