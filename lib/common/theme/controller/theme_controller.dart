import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController with WidgetsBindingObserver {
  final _themePreferenceKey = 'theme_mode';
  final _isManualModeKey = 'manual_mode';

  var _isDarkMode = false.obs;
  var _isManualMode = false.obs; // Track if user manually toggled

  bool get isDarkMode => _isDarkMode.value;
  bool get isManualMode => _isManualMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPreferences();
    WidgetsBinding.instance
        .addObserver(this); // Observe system brightness changes
  }

  void toggleTheme() async {
    _isDarkMode.toggle();
    _isManualMode.value = true; // Mark as manual mode
    await _saveThemeToPreferences();
  }

  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getBool(_themePreferenceKey);
    final manualMode = prefs.getBool(_isManualModeKey) ?? false;

    if (manualMode && themeMode != null) {
      _isDarkMode.value = themeMode;
      _isManualMode.value = true;
    } else {
      // Follow system theme
      _isDarkMode.value =
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      _isManualMode.value = false;
    }
  }

  Future<void> _saveThemeToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode.value);
    await prefs.setBool(_isManualModeKey, _isManualMode.value);
  }

  @override
  void didChangePlatformBrightness() {
    if (!_isManualMode.value) {
      _isDarkMode.value =
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when controller is closed
    super.onClose();
  }
}
