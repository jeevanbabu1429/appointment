import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'app_button.dart';
import 'app_input.dart';

Future<void> showConfirmBookingPopup({
  required String date,
  required String time,
  required VoidCallback onConfirm,
}) async {
  await Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(AppIcons.calendar, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) Get.back();
                  },
                  icon: const Icon(AppIcons.close, size: 22, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppInput(
              label: 'Date',
              hint: DateFormat('dd MMM yyyy').format(DateTime.parse(date)),
              readOnly: true,
              prefixIcon: const Icon(AppIcons.calendar, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            AppInput(
              label: 'Time',
              hint: time,
              readOnly: true,
              prefixIcon: const Icon(AppIcons.clock, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            const Text(
              'Proceed to book this slot?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: 'Cancel',
                    onPressed: () {
                      if (Get.isDialogOpen ?? false) Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton.primary(
                    label: 'Confirm',
                    onPressed: () async {
                      if (Get.isDialogOpen ?? false) Get.back();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

Future<void> showSuccessPopup({
  required String title,
  String? subtitle,
  VoidCallback? onOk,
}) async {
  await Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(AppIcons.success, size: 34, color: AppColors.accent),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 18),
            AppButton.primary(
              label: 'OK',
              onPressed: () {
                if (Get.isDialogOpen ?? false) {
                  Get.back(closeOverlays: true);
                }
                onOk?.call();
              },
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
