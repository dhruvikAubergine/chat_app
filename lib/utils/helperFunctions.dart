import 'package:intl/intl.dart';

class HelperFunctions {
  static String getConvoID(String uid, String pid) {
    return uid.hashCode <= pid.hashCode ? '${uid}_$pid' : '${pid}_$uid';
  }

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
}
