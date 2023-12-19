import 'package:intl/intl.dart';

dateFormat(DateTime date) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd MMMM yyyy');
  final String formatted = formatter.format(date);
  return formatted;
}

dateFormatSlash(DateTime date) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String formatted = formatter.format(date);
  return formatted;
}

dateFormatDash(DateTime date) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(date);
  return formatted;
}

dateOfBirthFormatDash(DateTime date) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(date);
  return formatted;
}

timeFormat(DateTime date) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('hh:mm a');
  final String formatted = formatter.format(date);
  return formatted;
}

lastSeen(DateTime date) {
// the current date and time
  DateTime currentDate = DateTime.now();

// calculate the time difference
  Duration difference = currentDate.difference(date);

// format the difference as "X hour(s) ago", "X minute(s) ago", "X second(s) ago", "X day(s) ago", "X month(s) ago", or "X year(s) ago"
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 365) {
    double monthsAgo = difference.inDays / 30;
    return '${monthsAgo.round()} months ago';
  } else {
    double yearsAgo = difference.inDays / 365;
    return '${yearsAgo.round()} years ago';
  }
}
