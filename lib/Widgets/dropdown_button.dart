import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:joy_app/theme.dart';

const List<Job> _list = [
  Job('Developer', Icons.developer_mode),
  Job('Designer', Icons.design_services),
  Job('Consultant', Icons.account_balance),
  Job('Student', Icons.school),
];

class SearchDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String icon;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  SearchDropdown({
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
    return CustomDropdown.multiSelectSearch(
      decoration: CustomDropdownDecoration(
        expandedFillColor: ThemeUtil.isDarkMode(context)
            ? Color(0xff121212)
            : Color(0xffF9FAFB),
        closedFillColor: ThemeUtil.isDarkMode(context)
            ? Color(0xff121212)
            : Color(0xffF9FAFB),
        closedBorder: Border.all(
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff2F343C)
              : Color(0xffD1D5DB),
          width: 1.0,
        ),
        closedBorderRadius: BorderRadius.circular(8.0),
      ),
      hintText: hintText,
      items: items,
      onListChanged: (value) {
        print('changing value to: $value');
      },
    );
  }
}

class Job {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() {
    return name;
  }
}
