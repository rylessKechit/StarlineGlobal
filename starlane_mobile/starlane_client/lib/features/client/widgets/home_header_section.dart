import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../auth/bloc/auth_bloc.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            StarlaneColors.navy700,
            StarlaneColors.navy800,
          ],
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final userName = state is AuthAuthenticated 
                ? state.user.name.split(' ').first
                : 'Utilisateur';
            
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour $userName 👋',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Découvrez nos services premium',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: StarlaneColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                StarlaneAvatar(
                  initials: userName.isNotEmpty ? userName[0] : 'U',
                  size: 45,
                  onTap: () {
                    // TODO: Navigation vers profil
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}