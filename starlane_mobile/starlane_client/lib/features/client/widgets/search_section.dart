import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/starlane_colors.dart';

class SearchSection extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const SearchSection({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      height: 44.h,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14.sp,
          color: StarlaneColors.navy900,
        ),
        decoration: InputDecoration(
          hintText: 'Rechercher un service...',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: StarlaneColors.gray400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: StarlaneColors.gray400,
            size: 20.sp,
          ),
          filled: true,
          fillColor: StarlaneColors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: StarlaneColors.gray300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: StarlaneColors.gray300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: StarlaneColors.gold500, width: 2),
          ),
          isDense: true,
        ),
      ),
    );
  }
}