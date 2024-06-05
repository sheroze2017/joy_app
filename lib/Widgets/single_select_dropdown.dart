import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class SearchSingleDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String icon;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  SearchSingleDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.icon,
    this.focusNode,
    this.nextFocusNode,
  });
  @override
  Widget build(BuildContext context) {
    return CustomDropdown.search(
      decoration: CustomDropdownDecoration(
        closedFillColor: Color(0xffF9FAFB),
        closedBorder: Border.all(
          color: const Color(0xffD1D5DB),
          width: 1.0,
        ),
        closedBorderRadius: BorderRadius.circular(8.0),
      ),
      hintText: hintText,
      items: items,
      onChanged: (String) {},
    );
  }
}
