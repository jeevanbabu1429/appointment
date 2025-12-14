// lib/controllers/auth_controller.dart

import 'package:get/get.dart';

import '../models/user_model.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  String? authToken;

  bool get isLoggedIn => authToken != null && currentUser.value != null;

  Future<void> login({
    required String mobile,
    required String password,
  }) async {
    if (mobile.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Mobile and password are required');
      return;
    }

    try {
      isLoading.value = true;

      final loginResponse = await AuthService.login(
        mobile: mobile,
        password: password,
      );

      authToken = loginResponse.token;
      currentUser.value = loginResponse.user;

      Get.snackbar('Success', 'Login successful');

      // Go to home
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: register
  Future<void> register({
    required String name,
    required String mobile,
    required String password,
    String? email,
  }) async {
    if (name.isEmpty || mobile.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Name, mobile and password are required');
      return;
    }

    try {
      isLoading.value = true;

      final res = await AuthService.register(
        name: name,
        mobile: mobile,
        password: password,
        email: email,
      );

      Get.snackbar('Success', res.message.isNotEmpty
          ? res.message
          : 'Registered successfully');

      // After successful register, go back to Login screen
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Register Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
