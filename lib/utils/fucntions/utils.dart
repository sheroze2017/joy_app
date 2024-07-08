import 'package:intl/intl.dart';

class Utils {
  static String convertToUserTimeZone(String utcTime) {
    // Parse the UTC time string
    print('date $utcTime');
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").parseUTC(utcTime);

    // Get the current date and time in the local time zone
    DateTime now = DateTime.now();

    // Get the time zone offset
    Duration offset = now.timeZoneOffset;

    // Apply the time zone offset to the parsed UTC time
    DateTime userTime = parsedDate.add(offset);

    // Format the user's time
    String formattedTime = DateFormat("yyyy MMM dd HH:mm:ss").format(userTime);

    return formattedTime;
  }
}
