import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/starlane_colors.dart';

// ============ ENUMS ============
enum StarlaneButtonStyle {
  primary,
  secondary,
  outline,
  ghost,
}

// ============ STARLANE CARD ============
class StarlaneCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Border? border;

  const StarlaneCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding ?? EdgeInsets.all(16.w),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? StarlaneColors.white,
        borderRadius: BorderRadius.circular(borderRadius?.r ?? 16.r),
        border: border,
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: StarlaneColors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius?.r ?? 16.r),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

// ============ STARLANE BUTTON ============
class StarlaneButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final StarlaneButtonStyle style; // PARAMÈTRE REQUIS
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final double? borderRadius;

  const StarlaneButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.style = StarlaneButtonStyle.primary, // PARAMÈTRE REQUIS
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Style configuration based on StarlaneButtonStyle
    Color effectiveBackgroundColor;
    Color effectiveTextColor;
    bool isOutlined = false;

    switch (style) {
      case StarlaneButtonStyle.primary:
        effectiveBackgroundColor = backgroundColor ?? StarlaneColors.primary;
        effectiveTextColor = textColor ?? StarlaneColors.white;
        break;
      case StarlaneButtonStyle.secondary:
        effectiveBackgroundColor = backgroundColor ?? StarlaneColors.gray100;
        effectiveTextColor = textColor ?? StarlaneColors.textPrimary;
        break;
      case StarlaneButtonStyle.outline:
        effectiveBackgroundColor = Colors.transparent;
        effectiveTextColor = textColor ?? StarlaneColors.primary;
        isOutlined = true;
        break;
      case StarlaneButtonStyle.ghost:
        effectiveBackgroundColor = Colors.transparent;
        effectiveTextColor = textColor ?? StarlaneColors.primary;
        break;
    }

    return SizedBox(
      width: width,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          elevation: style == StarlaneButtonStyle.ghost ? 0 : (isOutlined ? 0 : 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius?.r ?? 12.r),
            side: isOutlined 
                ? BorderSide(
                    color: backgroundColor ?? StarlaneColors.primary,
                    width: 1.5,
                  )
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: effectiveTextColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20.sp,
                    ),
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
}

// ============ STARLANE TEXT FIELD ============
class StarlaneTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? label; // PARAMÈTRE REQUIS - alias pour labelText
  final IconData? prefixIcon;
  final Widget? suffixIcon; // MODIFIÉ - Widget au lieu d'IconData
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction; // PARAMÈTRE AJOUTÉ
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted; // PARAMÈTRE AJOUTÉ
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;
  final String? errorText;
  final bool enabled;

  const StarlaneTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.label, // PARAMÈTRE REQUIS
    this.prefixIcon,
    this.suffixIcon, // MODIFIÉ
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction, // PARAMÈTRE AJOUTÉ
    this.validator,
    this.onChanged,
    this.onSubmitted, // PARAMÈTRE AJOUTÉ
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.errorText,
    this.enabled = true,
  });

  @override
  State<StarlaneTextField> createState() => _StarlaneTextFieldState();
}

class _StarlaneTextFieldState extends State<StarlaneTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ?? 12.0;
    final effectiveLabel = widget.label ?? widget.labelText; // Support des deux

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (effectiveLabel != null) ...[
          Text(
            effectiveLabel,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: StarlaneColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
            boxShadow: _isFocused ? [
              BoxShadow(
                color: StarlaneColors.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction, // PARAMÈTRE AJOUTÉ
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted, // PARAMÈTRE AJOUTÉ
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            style: TextStyle(
              fontSize: 16.sp,
              color: StarlaneColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: StarlaneColors.textSecondary,
                fontSize: 16.sp,
              ),
              
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused 
                          ? StarlaneColors.primary 
                          : StarlaneColors.textSecondary,
                      size: 20.sp,
                    )
                  : null,
              
              suffixIcon: widget.suffixIcon, // MODIFIÉ - accepte directement le Widget
              
              filled: true,
              fillColor: widget.fillColor ?? 
                  (_isFocused 
                      ? StarlaneColors.white 
                      : StarlaneColors.gray50),
              
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.prefixIcon != null ? 12.w : 16.w,
                vertical: 16.h,
              ),
              
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
                borderSide: BorderSide(
                  color: widget.borderColor ?? StarlaneColors.gray200,
                  width: 1.5,
                ),
              ),
              
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
                borderSide: BorderSide(
                  color: widget.borderColor ?? StarlaneColors.gray200,
                  width: 1.5,
                ),
              ),
              
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
                borderSide: BorderSide(
                  color: StarlaneColors.primary,
                  width: 2,
                ),
              ),
              
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
                borderSide: BorderSide(
                  color: StarlaneColors.error,
                  width: 1.5,
                ),
              ),
              
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
                borderSide: BorderSide(
                  color: StarlaneColors.error,
                  width: 2,
                ),
              ),
              
              errorText: widget.errorText,
              errorStyle: TextStyle(
                color: StarlaneColors.error,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============ STARLANE SHIMMER ============
class StarlaneShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const StarlaneShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: StarlaneColors.gray200,
      highlightColor: StarlaneColors.gray100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: StarlaneColors.gray200,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

// ============ STARLANE AVATAR ============
class StarlaneAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final double? size; // PARAMÈTRE REQUIS - alias pour radius
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const StarlaneAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 24,
    this.size, // PARAMÈTRE REQUIS
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = size ?? radius; // Support des deux

    Widget avatar = CircleAvatar(
      radius: effectiveRadius.r,
      backgroundColor: backgroundColor ?? StarlaneColors.primary.withOpacity(0.1),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials ?? '?',
              style: TextStyle(
                color: textColor ?? StarlaneColors.primary,
                fontSize: (effectiveRadius * 0.6).sp,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}

// ============ STARLANE BADGE ============
class StarlaneBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;

  const StarlaneBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? StarlaneColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: (fontSize ?? 12).sp,
              color: textColor ?? StarlaneColors.primary,
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: (fontSize ?? 12).sp,
              fontWeight: FontWeight.w600,
              color: textColor ?? StarlaneColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============ STARLANE LOADING ============
class StarlaneLoading extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;

  const StarlaneLoading({
    super.key,
    this.message,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size?.w ?? 32.w,
          height: size?.h ?? 32.h,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: color ?? StarlaneColors.primary,
          ),
        ),
        if (message != null) ...[
          SizedBox(height: 16.h),
          Text(
            message!,
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}