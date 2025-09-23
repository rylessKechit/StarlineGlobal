import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/starlane_colors.dart';

enum StarlaneButtonVariant {
  primary,
  secondary,
  outline,
}

class StarlaneButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final StarlaneButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  const StarlaneButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = StarlaneButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(variant),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    variant == StarlaneButtonVariant.primary
                        ? StarlaneColors.white
                        : StarlaneColors.gold500,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20.sp),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  ButtonStyle _getButtonStyle(StarlaneButtonVariant variant) {
    switch (variant) {
      case StarlaneButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: StarlaneColors.gold500,
          foregroundColor: StarlaneColors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        );
      case StarlaneButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: StarlaneColors.emerald500,
          foregroundColor: StarlaneColors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        );
      case StarlaneButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: StarlaneColors.gold600,
          elevation: 0,
          side: BorderSide(color: StarlaneColors.gold500, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        );
    }
  }
}