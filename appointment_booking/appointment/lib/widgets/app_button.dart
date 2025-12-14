import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppButtonVariant { primary, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final EdgeInsetsGeometry padding;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : variant = AppButtonVariant.primary;

  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : variant = AppButtonVariant.outline;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : variant = AppButtonVariant.ghost;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    Color bg;
    Color fg;
    BorderSide? side;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        side = null;
        break;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.primary;
        side = BorderSide(color: AppColors.primary.withOpacity(0.4));
        break;
      case AppButtonVariant.ghost:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        side = null;
        break;
    }

    if (isDisabled) {
      fg = fg.withOpacity(0.5);
      bg = bg.withOpacity(0.5);
      side = side?.copyWith(color: side.color.withOpacity(0.3));
    }

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bg,
          foregroundColor: fg,
          side: side,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
