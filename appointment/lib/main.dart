// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/slot_controller.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/register_page.dart';
import 'controllers/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Slot Booking Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      initialBinding: BindingsBuilder(() {
        // make AuthController available everywhere
        Get.put(AuthController(), permanent: true);
        Get.put(SlotController(), permanent: true);
      }),
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
        ),
      ],
    );
  }
}
