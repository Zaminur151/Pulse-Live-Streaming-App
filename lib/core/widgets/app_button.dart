import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant { primary, gradient, live, tonal, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.text) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context),
      );
    }

    if (variant == AppButtonVariant.gradient) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          child: _buildChild(context, color: Colors.white),
        ),
      );
    }

    Color bgColor;
    Color fgColor;

    switch (variant) {
      case AppButtonVariant.live:
        bgColor = AppColors.error;
        fgColor = Colors.white;
        break;
      case AppButtonVariant.tonal:
        bgColor = AppColors.surfaceContainerHigh;
        fgColor = AppColors.onSurface;
        break;
      default:
        bgColor = AppColors.primary;
        fgColor = AppColors.onPrimary;
    }

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: variant == AppButtonVariant.live ? 8 : 0,
          shadowColor: variant == AppButtonVariant.live ? AppColors.error.withOpacity(0.5) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: _buildChild(context, color: fgColor),
      ),
    );
  }

  Widget _buildChild(BuildContext context, {Color? color}) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold));
  }
}
