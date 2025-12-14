// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _mobileCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final RxBool _obscurePassword = true.obs;

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.background),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      AppIcons.calendar,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Book Your Appointment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    AppInput(
                      controller: _mobileCtrl,
                      label: 'Mobile Number',
                      hint: 'e.g., 9876543210',
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(AppIcons.phone, color: AppColors.primary),
                      inputFormatters:  [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter mobile number';
                        }
                        if (value.trim().length < 8) {
                          return 'Enter valid mobile number';
                        }
                        if (value.trim().length > 10) {
                          return 'Mobile number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Obx(() {
                      final isObscure = _obscurePassword.value;
                      return AppInput(
                        controller: _passwordCtrl,
                        label: 'Password',
                        obscureText: isObscure,
                        prefixIcon:
                            const Icon(AppIcons.lock, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? AppIcons.eye : AppIcons.eyeOff,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => _obscurePassword.toggle(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 24),

                    Obx(
                      () => AppButton.primary(
                        label: 'Log In',
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        onPressed: _authController.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  _authController.login(
                                    mobile: _mobileCtrl.text.trim(),
                                    password: _passwordCtrl.text,
                                  );
                                }
                              },
                        icon: _authController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
