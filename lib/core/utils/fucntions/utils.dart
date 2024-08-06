import 'package:intl/intl.dart';

String convertTimeFormat(String input) {
  try {
    // Define the input and output date formats
    final inputFormat = DateFormat('HH:mm:ss');
    final outputFormat = DateFormat('hh:mm a');

    // Parse the input string to a DateTime object
    final dateTime = inputFormat.parse(input);

    // Format the DateTime object to the desired output format
    return outputFormat.format(dateTime);
  } catch (e) {
    // If parsing fails, return the input string
    return input;
  }
}
