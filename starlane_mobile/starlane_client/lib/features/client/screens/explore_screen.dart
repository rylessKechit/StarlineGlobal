import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/starlane_colors.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      appBar: AppBar(
        title: Text(
          'Explorer',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.white,
          ),
        ),
        backgroundColor: StarlaneColors.emerald500,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.sp,
              color: StarlaneColors.gray400,
            ),
            SizedBox(height: 16.h),
            Text(
              'Écran Explorer',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: StarlaneColors.navy700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Fonctionnalité à venir...',
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}