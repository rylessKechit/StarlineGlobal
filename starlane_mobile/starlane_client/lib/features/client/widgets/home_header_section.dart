import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../auth/bloc/auth_bloc.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            StarlaneColors.navy900,
            StarlaneColors.navy800,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Top row avec avatar et notifications
          Row(
            children: [
              // User avatar
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return StarlaneAvatar(
                      initials: _getInitials(state.user.name),
                      radius: 22.5, // CORRIGÉ - utilise radius au lieu de size
                      backgroundColor: StarlaneColors.gold100,
                      textColor: StarlaneColors.gold700,
                      onTap: () {
                        // TODO: Navigation vers profil
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Navigation vers profil - À implémenter'),
                            backgroundColor: StarlaneColors.gold600,
                          ),
                        );
                      },
                    );
                  }
                  return StarlaneAvatar(
                    initials: '?',
                    radius: 22.5, // CORRIGÉ - utilise radius au lieu de size
                    backgroundColor: StarlaneColors.gray200,
                  );
                },
              ),
              
              const Spacer(),
              
              // Notifications
              Container(
                decoration: BoxDecoration(
                  color: StarlaneColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Open notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Notifications - À implémenter'),
                        backgroundColor: StarlaneColors.navy600,
                      ),
                    );
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: StarlaneColors.white,
                        size: 24.sp,
                      ),
                      // Badge de notification
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: StarlaneColors.error,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Texte de bienvenue
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String userName = 'Client';
              if (state is AuthAuthenticated) {
                userName = state.user.name.split(' ').first;
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour $userName',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Découvrez nos services d\'exception',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: StarlaneColors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Logo ou icône Starlane
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: StarlaneColors.gold600.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.star_rounded,
                          color: StarlaneColors.gold400,
                          size: 32.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }
}