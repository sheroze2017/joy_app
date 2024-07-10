String getElapsedTime(String createdTimeString) {
  DateTime createdTime = DateTime.parse(createdTimeString);

  DateTime now = DateTime.now();
  Duration difference = now.difference(createdTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} day(s) ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour(s) ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute(s) ago';
  } else {
    return 'Just now';
  }
}
