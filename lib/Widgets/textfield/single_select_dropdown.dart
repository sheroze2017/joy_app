import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:joy_app/theme.dart';

class SearchSingleDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String icon;
  final bool isEnabled;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  SearchSingleDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.icon,
    this.isEnabled = true,
    this.focusNode,
    this.nextFocusNode,
  });
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.6,
        child: CustomDropdown.search(
          // initialItem: value,
          listItemPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          closedHeaderPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          expandedHeaderPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemsListPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: CustomDropdownDecoration(
            expandedFillColor: ThemeUtil.isDarkMode(context)
                ? Color(0xff121212)
                : Color(0xffF9FAFB),
            closedFillColor: ThemeUtil.isDarkMode(context)
                ? Color(0xff121212)
                : Color(0xffF9FAFB),
            closedBorder: Border.all(
              color: const Color(0xffD1D5DB),
              width: 1,
            ),
            closedBorderRadius: BorderRadius.circular(8.0),
          ),
          hintText: hintText,
          items: items,
          onChanged: isEnabled ? onChanged : (value) {},
        ),
      ),
    );
  }
}
