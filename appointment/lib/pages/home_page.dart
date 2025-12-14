import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/slot_controller.dart';
import '../models/slot_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../widgets/app_button.dart';
import '../widgets/app_popup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showConfirmDialog(SlotModel slot, SlotController slotController) {
    showConfirmBookingPopup(
      date: slot.date,
      time: slot.time,
      onConfirm: () => slotController.bookSlot(slot),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SlotController slotController = Get.find<SlotController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          'BOOK APPOINTMENT',
          style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 6,
        foregroundColor: Colors.white,
        shadowColor: AppColors.primary.withOpacity(0.35),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => Get.back(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  const Icon(AppIcons.calendar,
                      size: 18, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    slotController.formattedDateForUi,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(AppIcons.clock,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          '${slotController.slots.length} slots',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date card with picker
              Obx(() {
                final selected = slotController.selectedDate.value;
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Date',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slotController.formattedDateForUi,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 130,
                        child: AppButton.primary(
                          label: 'Pick date',
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          icon: const Icon(AppIcons.calendar,
                              size: 18, color: Colors.white),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selected,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: AppColors.primary,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null) {
                              slotController.changeDate(picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              const Text(
                'Pick a time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap any available card below to book instantly.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // Grid of slots (3 per row)
              Expanded(
                child: Obx(() {
                  if (slotController.isLoading.value) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: 10),
                          Text('Loading available slots...',
                              style: TextStyle(color: AppColors.primary)),
                        ],
                      ),
                    );
                  }

                  final slots = slotController.slots;

                  if (slots.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'No slots available for this date. Try another day.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 6),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      final isAvailable = !slot.booked;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (!isAvailable) {
                              Get.snackbar(
                                'Slot Unavailable',
                                'This slot is already booked. Please choose another time.',
                                backgroundColor: Colors.red.withOpacity(0.8),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } else {
                              _showConfirmDialog(slot, slotController);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? AppColors.availableBg
                                  : AppColors.bookedBg,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              slot.time,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isAvailable
                                    ? AppColors.accent
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              // Booking Loader (Bottom)
              Obx(
                () => slotController.isBooking.value
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: LinearProgressIndicator(
                          color: AppColors.primary,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
