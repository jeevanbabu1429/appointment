import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/slot_model.dart';
import '../service/slot_service.dart';
import 'auth_controller.dart';
import '../widgets/app_popup.dart';

class SlotController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  final RxBool isBooking = false.obs; // 👈 NEW
  final RxList<SlotModel> slots = <SlotModel>[].obs;

  // for API
  String get formattedDateForApi =>
      DateFormat('yyyy-MM-dd').format(selectedDate.value);

  // for UI
  String get formattedDateForUi =>
      DateFormat('dd MMM yyyy').format(selectedDate.value);

  @override
  void onInit() {
    super.onInit();
    fetchSlotsForSelectedDate();
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
    fetchSlotsForSelectedDate();
  }

  Future<void> fetchSlotsForSelectedDate() async {
    final authController = Get.find<AuthController>();
    final token = authController.authToken;

    if (token == null) {
      Get.snackbar('Error', 'Not authorized. Please login again.');
      return;
    }

    try {
      isLoading.value = true;
      final list = await SlotService.getSlotsForDate(
        date: formattedDateForApi,
        token: token,
      );
      slots.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 👇 NEW: book a given slot
  Future<void> bookSlot(SlotModel slot) async {
    final authController = Get.find<AuthController>();
    final token = authController.authToken;

    if (token == null) {
      Get.snackbar('Error', 'Not authorized. Please login again.');
      return;
    }

    try {
      isBooking.value = true;
      await SlotService.bookSlot(slotId: slot.id, token: token);

      Get.snackbar('Success', 'Slot booked: ${slot.time}');
      await showSuccessPopup(
        title: 'Slot booked successfully',
        subtitle: 'Time: ${slot.time}',
      );

      // refresh slots for this date so UI updates (turns green -> grey)
      await fetchSlotsForSelectedDate();
    } catch (e) {
      Get.snackbar('Booking Failed', e.toString());
    } finally {
      isBooking.value = false;
    }
  }

}
