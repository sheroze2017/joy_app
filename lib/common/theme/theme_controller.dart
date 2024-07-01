import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorController extends GetxController {
  final Rx<Color> selectedColor = Colors.blue.obs;

  final List<Color> colorThemes = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  void changeColor(Color newColor) {
    selectedColor.value = newColor;
    update();
  }

  final Rx<Color> selectedSecondaryColor = Colors.blueGrey.obs;

  final List<Color> secondaryColorThemes = [
    Colors.blueGrey,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
  ];

  void changeSecondaryColor(Color newColor) {
    selectedSecondaryColor.value = newColor;
  }
}

class HomeController extends GetxController {
  // initializing with the current theme of the device
  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  // function to switch between themes
  void switchTheme() {
    currentTheme.value = currentTheme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
