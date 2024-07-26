import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String> showDatePickerDialog(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    print('Selected date: $formattedDate');
    return formattedDate;
  } else {
    return '';
  }
}
