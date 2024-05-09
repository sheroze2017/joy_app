import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedBorderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String icon;

  RoundedBorderTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
        color: Color(0xffF9FAFB),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                cursorColor: const Color(0xffD1D5DB),
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: const Color(0xffD1D5DB),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
