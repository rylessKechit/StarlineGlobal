import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      appBar: AppBar(
        title: Text(
          'Mes Réservations',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy900,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_outlined,
                size: 80.w,
                color: StarlaneColors.navy500,
              ),
              SizedBox(height: 20.h),
              Text(
                'Mes Réservations',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: StarlaneColors.navy900,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Consultez et gérez vos réservations',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: StarlaneColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
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
                child: Text(
                  '🚧 En cours de développement\n\nFonctionnalités à venir :\n• Liste des réservations\n• Statuts en temps réel\n• Annulation de réservations\n• Avis et évaluations',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: StarlaneColors.gray700,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}