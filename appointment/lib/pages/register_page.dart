// lib/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirm = true.obs;

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: AppColors.background,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(AppIcons.back, color: AppColors.primary),
                  onPressed: () => Get.back(),
                ),
                expandedHeight: 0,
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Join us to book your next appointment easily.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppInput(
                              controller: _nameCtrl,
                              label: 'Full Name',
                              prefixIcon: const Icon(
                                AppIcons.person,
                                color: AppColors.primary,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            AppInput(
                              controller: _mobileCtrl,
                              label: 'Mobile Number',
                              keyboardType: TextInputType.phone,
                              prefixIcon: const Icon(
                                AppIcons.phone,
                                color: AppColors.primary,
                              ),
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
                            AppInput(
                              controller: _emailCtrl,
                              label: 'Email (Optional)',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                AppIcons.email,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              final isObscure = _obscurePassword.value;
                              return AppInput(
                                controller: _passwordCtrl,
                                label: 'Password',
                                obscureText: isObscure,
                                prefixIcon: const Icon(
                                  AppIcons.lock,
                                  color: AppColors.primary,
                                ),
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
                            const SizedBox(height: 20),
                            Obx(() {
                              final isObscure = _obscureConfirm.value;
                              return AppInput(
                                controller: _confirmPasswordCtrl,
                                label: 'Confirm Password',
                                obscureText: isObscure,
                                prefixIcon: const Icon(
                                  AppIcons.lock,
                                  color: AppColors.primary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isObscure ? AppIcons.eye : AppIcons.eyeOff,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () => _obscureConfirm.toggle(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm password';
                                  }
                                  if (value != _passwordCtrl.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              );
                            }),
                            const SizedBox(height: 40),
                            Obx(
                              () => AppButton.primary(
                                label: 'Create Account',
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                onPressed: _authController.isLoading.value
                                    ? null
                                    : () {
                                        if (_formKey.currentState
                                                ?.validate() ??
                                            false) {
                                          _authController.register(
                                            name: _nameCtrl.text.trim(),
                                            mobile: _mobileCtrl.text.trim(),
                                            password: _passwordCtrl.text,
                                            email: _emailCtrl.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _emailCtrl.text.trim(),
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
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Get.offAllNamed('/login');
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
