import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';

class SearchSection extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onSearchChanged; // PARAMÈTRE REQUIS
  final VoidCallback? onFilterTap;

  const SearchSection({
    super.key,
    this.controller,
    this.onSearchChanged, // PARAMÈTRE REQUIS
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          // Barre de recherche
          Expanded(
            child: StarlaneTextField(
              controller: controller,
              hintText: 'Rechercher une activité...',
              prefixIcon: Icons.search,
              onChanged: onSearchChanged,
              borderRadius: 16,
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Bouton filtre
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: StarlaneColors.gold600,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: StarlaneColors.gold600.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onFilterTap,
              icon: Icon(
                Icons.tune_rounded,
                color: StarlaneColors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}