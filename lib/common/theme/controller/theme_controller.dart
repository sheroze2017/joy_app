import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  void toggleTheme() {
    _isDarkMode.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    // updateSystemUIOverlayStyle();
  }
}
