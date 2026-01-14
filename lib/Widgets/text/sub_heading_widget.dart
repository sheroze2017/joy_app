import 'package:flutter/material.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';

/// Reusable SubHeading widget for section headings throughout the app
/// 
/// Styling:
/// - Font size: 20
/// - Font weight: 600
/// - Color: #1F2A37 (light mode) / #C8D3E0 (dark mode)
/// 
/// Usage:
/// ```dart
/// SubHeadingWidget(title: 'My Friends')
/// ```
class SubHeadingWidget extends StatelessWidget {
  final String title;
  final double? size;

  const SubHeadingWidget({
    super.key,
    required this.title,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: CustomTextStyles.w600TextStyle(
        size: size ?? 20,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xffC8D3E0)
            : Color(0xff1F2A37),
      ),
    );
  }
}
