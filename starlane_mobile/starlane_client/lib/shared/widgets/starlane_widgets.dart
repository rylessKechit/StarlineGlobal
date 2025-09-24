import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/starlane_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ============ STARLANE BUTTON ============
enum StarlaneButtonStyle { primary, secondary, outline, ghost }
enum StarlaneButtonSize { small, medium, large }

class StarlaneButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final StarlaneButtonStyle style;
  final StarlaneButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const StarlaneButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style = StarlaneButtonStyle.primary,
    this.size = StarlaneButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  State<StarlaneButton> createState() => _StarlaneButtonState();
}

class _StarlaneButtonState extends State<StarlaneButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetPress();
  }

  void _handleTapCancel() {
    _resetPress();
  }

  void _resetPress() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              height: _getHeight(),
              decoration: _getDecoration(),
              child: widget.isLoading
                  ? _buildLoadingContent()
                  : _buildContent(),
            ),
          );
        },
      ),
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case StarlaneButtonSize.small:
        return 40.h;
      case StarlaneButtonSize.medium:
        return 48.h;
      case StarlaneButtonSize.large:
        return 56.h;
    }
  }

  BoxDecoration _getDecoration() {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    switch (widget.style) {
      case StarlaneButtonStyle.primary:
        return BoxDecoration(
          gradient: isDisabled 
              ? null 
              : (_isPressed 
                  ? const LinearGradient(
                      colors: [StarlaneColors.gold600, StarlaneColors.gold700])
                  : StarlaneColors.luxuryGradient),
          color: isDisabled ? StarlaneColors.gray300 : null,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isDisabled || _isPressed ? null : StarlaneColors.softShadow,
        );
      
      case StarlaneButtonStyle.secondary:
        return BoxDecoration(
          color: _isPressed 
              ? StarlaneColors.navy600 
              : (isDisabled ? StarlaneColors.gray300 : StarlaneColors.navy500),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isDisabled || _isPressed ? null : StarlaneColors.softShadow,
        );
      
      case StarlaneButtonStyle.outline:
        return BoxDecoration(
          color: _isPressed ? StarlaneColors.gold50 : StarlaneColors.white,
          border: Border.all(
            color: isDisabled ? StarlaneColors.gray300 : StarlaneColors.gold500,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.r),
        );
      
      case StarlaneButtonStyle.ghost:
        return BoxDecoration(
          color: _isPressed ? StarlaneColors.gray100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        );
    }
  }

  Widget _buildContent() {
    final textColor = _getTextColor();
    final textStyle = _getTextStyle().copyWith(color: textColor);

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: textColor,
            size: _getIconSize(),
          ),
          SizedBox(width: 8.w),
          Text(widget.text, style: textStyle),
        ],
      );
    }

    return Center(
      child: Text(widget.text, style: textStyle),
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      ),
    );
  }

  Color _getTextColor() {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    if (isDisabled) {
      return StarlaneColors.gray500;
    }
    
    switch (widget.style) {
      case StarlaneButtonStyle.primary:
      case StarlaneButtonStyle.secondary:
        return StarlaneColors.white;
      case StarlaneButtonStyle.outline:
      case StarlaneButtonStyle.ghost:
        return StarlaneColors.gold600;
    }
  }

  TextStyle _getTextStyle() {
    final fontSize = widget.size == StarlaneButtonSize.small ? 14.sp :
                     widget.size == StarlaneButtonSize.medium ? 16.sp : 18.sp;
    
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  double _getIconSize() {
    switch (widget.size) {
      case StarlaneButtonSize.small:
        return 16.sp;
      case StarlaneButtonSize.medium:
        return 20.sp;
      case StarlaneButtonSize.large:
        return 24.sp;
    }
  }
}

// ============ STARLANE TEXT FIELD ============
class StarlaneTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;

  const StarlaneTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
  });

  @override
  State<StarlaneTextField> createState() => _StarlaneTextFieldState();
}

class _StarlaneTextFieldState extends State<StarlaneTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _borderColorAnimation = ColorTween(
      begin: StarlaneColors.gray300,
      end: StarlaneColors.gold500,
    ).animate(_animationController);

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: StarlaneColors.gray700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        AnimatedBuilder(
          animation: _borderColorAnimation,
          builder: (context, child) {
            return TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              validator: widget.validator,
              onTap: widget.onTap,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              readOnly: widget.readOnly,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: StarlaneColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: StarlaneColors.gray400,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused ? StarlaneColors.gold500 : StarlaneColors.gray400,
                        size: 20.sp,
                      )
                    : null,
                suffixIcon: widget.suffixIcon,
                filled: true,
                fillColor: _isFocused ? StarlaneColors.gold50 : StarlaneColors.gray50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: StarlaneColors.gray300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: StarlaneColors.gray300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: _borderColorAnimation.value ?? StarlaneColors.gold500,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: StarlaneColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: StarlaneColors.error, width: 2),
                ),
                counterText: '',
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============ LOADING OVERLAY ============
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingText;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: StarlaneColors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: StarlaneColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: StarlaneColors.luxuryShadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.gold500),
                    ),
                    if (loadingText != null) ...[
                      SizedBox(height: 16.h),
                      Text(
                        loadingText!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: StarlaneColors.gray700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============ STARLANE CARD ============
class StarlaneCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const StarlaneCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  State<StarlaneCard> createState() => _StarlaneCardState();
}

class _StarlaneCardState extends State<StarlaneCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 4.0,
      end: (widget.elevation ?? 4.0) * 0.5,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetPress();
  }

  void _handleTapCancel() {
    _resetPress();
  }

  void _resetPress() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: widget.margin ?? EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? StarlaneColors.white,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: StarlaneColors.black.withOpacity(0.1),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value * 0.5),
                  ),
                ],
              ),
              child: Padding(
                padding: widget.padding ?? EdgeInsets.all(16.w),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============ STARLANE AVATAR ============
class StarlaneAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const StarlaneAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: backgroundColor == null ? StarlaneColors.luxuryGradient : null,
          color: backgroundColor,
          border: Border.all(
            color: StarlaneColors.gold200,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildInitialsWidget(),
                )
              : _buildInitialsWidget(),
        ),
      ),
    );
  }

  Widget _buildInitialsWidget() {
    return Center(
      child: Text(
        initials ?? '?',
        style: TextStyle(
          color: textColor ?? StarlaneColors.white,
          fontSize: (size * 0.4).sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============ AJOUTEZ CES COMPOSANTS À VOTRE starlane_widgets.dart ============

// ============ STARLANE IMAGE ============
class StarlaneImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const StarlaneImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: StarlaneColors.gray200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.gold500),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: StarlaneColors.gray200,
          child: Icon(
            Icons.image_not_supported,
            color: StarlaneColors.gray400,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}

// ============ STARLANE BADGE ============
class StarlaneBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double? fontSize;

  const StarlaneBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: (fontSize ?? 12.sp) + 2,
              color: textColor,
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 12.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ============ STARLANE RATING ============
class StarlaneRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool allowHalfRating;

  const StarlaneRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
    this.activeColor,
    this.inactiveColor,
    this.allowHalfRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return Icon(
          _getIconForIndex(index),
          size: size.sp,
          color: _getColorForIndex(index),
        );
      }),
    );
  }

  IconData _getIconForIndex(int index) {
    double ratingForIcon = rating - index;
    
    if (ratingForIcon >= 1.0) {
      return Icons.star_rounded;
    } else if (ratingForIcon >= 0.5 && allowHalfRating) {
      return Icons.star_half_rounded;
    } else {
      return Icons.star_outline_rounded;
    }
  }

  Color _getColorForIndex(int index) {
    double ratingForIcon = rating - index;
    
    if (ratingForIcon >= 0.5) {
      return activeColor ?? StarlaneColors.gold500;
    } else {
      return inactiveColor ?? StarlaneColors.gray300;
    }
  }
}