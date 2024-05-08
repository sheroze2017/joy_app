import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  RoundedButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }
}
