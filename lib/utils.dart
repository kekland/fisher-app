import 'package:intl/intl.dart';

class Utils {
  static String dateTimeToString(DateTime dateTime) {
    DateTime today = DateTime.now();
    var formatter = new DateFormat('H:mm');

    if (dateTime.day == today.day && dateTime.month == today.month && dateTime.year == today.year) {
      return 'Today at ${formatter.format(dateTime)}';
    } else if (dateTime.year == today.year) {
      return '${dateTime.day} ${months[dateTime.month - 1]}';
    } else {
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    }
  }

  static List months = ['January', 'Febuary', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
}
