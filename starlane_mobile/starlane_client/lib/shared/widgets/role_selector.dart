import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/starlane_colors.dart';
import '../../data/models/user.dart';

class RoleSelector extends StatelessWidget {
  final UserRole selectedRole;
  final Function(UserRole) onRoleChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Je suis un...',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: StarlaneColors.navy700,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildRoleOption(
                role: UserRole.client,
                icon: Icons.person_rounded,
                title: 'Client',
                description: 'Accès aux services de luxe',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildRoleOption(
                role: UserRole.prestataire,
                icon: Icons.business_rounded,
                title: 'Prestataire',
                description: 'Fournisseur de services',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required UserRole role,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isSelected = selectedRole == role;
    
    return GestureDetector(
      onTap: () => onRoleChanged(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
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
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isSelected ? StarlaneColors.gold500 : StarlaneColors.gray400,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: StarlaneColors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? StarlaneColors.gold700 : StarlaneColors.gray700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? StarlaneColors.gold600 : StarlaneColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}