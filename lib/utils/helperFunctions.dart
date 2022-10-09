import 'package:intl/intl.dart';

/// Provides a methods to manage dateTime objects.
class HelperFunctions {
  static String getTime(String timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
      format = DateFormat('jm');
    } else {
      format = DateFormat.yMd('en_US');
    }
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }

  static String getMsgTime(String timestamp) {
    String time;
    final duration = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(timestamp),
      ),
    );
    if (1 > duration.inMinutes) {
      time = 'Now';
    } else if (24 > duration.inHours) {
      time = 'Today';
    } else if (48 > duration.inHours) {
      time = 'Yesterday';
    } else if (365 > duration.inDays) {
      final msgDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(timestamp),
      );
      time = DateFormat.MMMd().format(msgDate);
    } else {
      final msgDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(timestamp),
      );
      time = DateFormat.yMMMd().format(msgDate);
    }
    return time;
  }
}
