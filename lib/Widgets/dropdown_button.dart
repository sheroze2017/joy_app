import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedBorderDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String icon;

  RoundedBorderDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color(0xffD1D5DB),
          width: 1.0,
        ),
        color: Color(0xffF9FAFB),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            SizedBox(width: 8.0),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  onChanged: onChanged,
                  items: items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: const Color(0xffD1D5DB)),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    hintText,
                    style: TextStyle(color: const Color(0xffD1D5DB)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
