import 'package:intl/intl.dart';

class DateHelper {
  static const _locale = 'en';
  static const int _secondMillis = 1000;
  static const int _minuteMillis = 60 * _secondMillis;
  static const int _hourMillis = 60 * _minuteMillis;
  static const int _daysMillis = 24 * _hourMillis;

  static final _timeFormat12 = DateFormat("h:mm a", _locale);
  static final _timeFormat24 = DateFormat("HH:mm:ss", _locale);
  static final _timeFormat24Post = DateFormat("HH:mm", _locale);

  static final _dateFormatLog = DateFormat("dd MMM yyyy", _locale);
  static final dateFormatGetEvent = DateFormat("yyyy-MM-dd", _locale);
  static final _dateFormatEvent = DateFormat("dd MMM yyyy", _locale);
  static final _joiningDate = DateFormat("dd MMM yyyy", _locale);
  static final _dateFormatEventDetail = DateFormat("EEEE, MMM dd", _locale);
  static final _dateFormatNotification = DateFormat("MMM dd", _locale);
  static final _expiryMonthCard = DateFormat("MM", _locale);
  static final _expiryYearCard = DateFormat("dd", _locale);
  static final _addCardDateFormat = DateFormat("MM/yyyy", _locale);
  static final _dateFormateWithoutString = DateFormat("yyyy-MM-dd", _locale);
  static final _dateFormateNoString = DateFormat("dd/MM/yyyy", _locale);
  static final _walletScreenFormate = DateFormat("MMMdd,yyyy h:mm a", _locale);
  static final _dateTimeFormat = DateFormat("dd MM yyyy HH:mm", _locale);
  static final _dateTimeFormatChat = DateFormat("yyyy-MM-dd hh:mm a", _locale);

  static DateFormat getDateFormat(String dateFormat) {
    return DateFormat(dateFormat, _locale);
  }

  static String getStringFromDate(String dateFormat, DateTime dateTime) {
    return getDateFormat(dateFormat).format(dateTime);
  }

  static DateTime getDateFromString(String dateFormat, String dateTime) {
    return getDateFormat(dateFormat).parse(dateTime);
  }

  static String getMeetingDate(DateTime dateTime) {
    return _dateFormatEvent.format(dateTime);
  }

  static String getChatDateTime(DateTime? dateTime) {
    return _dateTimeFormatChat.format(dateTime?.toLocal() ?? DateTime.now());
  }

  static String getEventDate(String date) {
    DateTime aDate = dateFormatGetEvent.parse(date);
    return _dateFormatEvent.format(aDate);
  }

  static String getEventDetailDate(String date) {
    DateTime aDate = dateFormatGetEvent.parse(date);
    return _dateFormatEvent.format(aDate);
  }

  static DateTime getEventDateObject(String? date) {
    return dateFormatGetEvent.parse(date!);
  }

  static String getEventStringDate(DateTime? date) {
    return _dateFormatEvent.format(date!);
  }

  static String getEventTime(String time) {
    DateTime date = _timeFormat24.parse(time);
    return _timeFormat12.format(date);
  }

  static DateTime getEventTimeObject(String time) {
    return _timeFormat24.parse(time);
  }

  static String getTime12(DateTime? dateTime) {
    return _timeFormat12.format(dateTime!);
  }

  static String convertDateto24(DateTime dateTime) {
    return _timeFormat24.format(dateTime);
  }

  static String getChatTime(int time) {
    if (time < 1000000000000) {
      // if timestamp given in seconds, convert to millis
      time *= 1000;
    }
    var now = DateTime.now().millisecondsSinceEpoch;
    if (time > now || time <= 0) {
      return "just now";
    }
    final int diff = now - time;
    if (diff < _minuteMillis) {
      return "just now";
    } else if (diff < 2 * _minuteMillis) {
      return "a minute ago";
    } else {
      var date = DateTime.fromMillisecondsSinceEpoch(time);
      return _timeFormat12.format(date);
    }
  }

  static String getTimeAgo(int time) {
    if (time < 1000000000000) {
      // if timestamp given in seconds, convert to millis
      time *= 1000;
    }
    var now = DateTime.now().millisecondsSinceEpoch;
    if (time > now || time <= 0) {
      return "just now";
    }
    // TODO: localize
    final int diff = now - time;
    if (diff < _minuteMillis) {
      return "just now";
    } else if (diff < 2 * _minuteMillis) {
      return "a minute ago";
    } else if (diff < 50 * _minuteMillis) {
      return "${(diff / _minuteMillis).floor()} minutes ago";
    } else if (diff < 90 * _minuteMillis) {
      return "an hour ago";
    } else if (diff < 24 * _hourMillis) {
      return "${(diff / _hourMillis).floor()} hours ago";
    } else if (diff < 48 * _hourMillis) {
      return "yesterday";
    } else {
      var date = DateTime.fromMillisecondsSinceEpoch(time);
      return _dateFormatLog.format(date);
    }
  }

  static String getDateTimeAgo(DateTime? date) {
    if (date == null) {
      return "";
    }

    DateTime current = DateTime.now();

    int time = date.millisecondsSinceEpoch;

    int now = current.millisecondsSinceEpoch;

    // if (time > now || time <= 0) {
    //   return _walletScreenFormate.format(date);
    // }

    final int diff = now - time;
    if (isToday(date)) {
      return _timeFormat12.format(date);
    } else if (dayIsYesterday(date)) {
      return "yesterday";
    } else {
      return _dateFormatLog.format(date);
    }
  }

  static String getShortTimeAgo(DateTime? dateTime) {
    var now = DateTime.now();
    final difference = now.difference(dateTime ?? DateTime.now());
    String time = "";
    if (difference.inDays > 29) {
      if ((difference.inDays / 30).floor() == 1) {
        time = "1 month ago";
      } else {
        time = "Active since ${(difference.inDays / 30).floor()}months";
      }
    } else if (difference.inDays >= 1 && difference.inDays <= 29) {
      if (difference.inDays == 1) {
        time = "1 day";
      } else {
        time = "${difference.inDays} days";
      }
    } else if (difference.inHours >= 1) {
      if (difference.inHours == 1) {
        time = "1 hour";
      } else {
        time = "${difference.inHours} hours";
      }
    } else if (difference.inMinutes >= 1) {
      if (difference.inMinutes == 1) {
        time = "1 min";
      } else {
        time = "${difference.inMinutes} min";
      }
    } else {
      time = "${difference.inSeconds} sec";
    }
    return "$time ago";
  }

  static String getSinceAgo(DateTime dateTime) {
    var now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 29) {
      if ((difference.inDays / 30).floor() == 1) {
        return "Active since 1 month";
      } else {
        return "Active since ${(difference.inDays / 30).floor()}months";
      }
    } else if (difference.inDays >= 1 && difference.inDays <= 29) {
      if (difference.inDays == 1) {
        return "Active since 1 day";
      } else {
        return "Active since ${difference.inDays} days";
      }
    } else if (difference.inHours >= 1) {
      if (difference.inHours == 1) {
        return "Active since 1 hour";
      } else {
        return "Active since ${difference.inHours} hours";
      }
    } else if (difference.inMinutes >= 1) {
      if (difference.inMinutes == 1) {
        return "Active since 1 minute";
      } else {
        return "Active since ${difference.inMinutes} minutes";
      }
    } else {
      return "Active since ${difference.inSeconds} seconds";
    }
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    final aDate1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    final aDate2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);
    return aDate1 == aDate2;
  }

  static bool dayIsYesterday(DateTime dateTime) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return yesterday == aDate;
  }

  static String getNotificationDate(DateTime dateTime) {
    return _dateFormatNotification.format(dateTime.toLocal());
  }

  static DateTime excludeSeconds(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour,
        dateTime.minute);
  }

  static DateTime getOnlyDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String joiningDate(DateTime? dateTime) {
    return _joiningDate.format(dateTime!);
  }

  static String expiryMonth(DateTime dateTime) {
    return _expiryMonthCard.format(dateTime);
  }

  static String expiryYear(DateTime dateTime) {
    return _expiryYearCard.format(dateTime);
  }

  static DateTime getAddCardDate(String date) {
    return _addCardDateFormat.parse(date);
  }

  static String getCardDate(DateTime? date) {
    if (date == null) return "";
    return _addCardDateFormat.format(date);
  }

  static String getUpdateDateMyPostList(DateTime? dateTime) {
    if (dateTime == null) return "0";
    return _dateFormateNoString.format(dateTime);
  }

  static String getPickupTimeMyPostList(String? time) {
    if (time == null) {
      return "";
    }
    var date = _timeFormat24Post.parse(time);
    return _timeFormat12.format(date);
  }

  static DateTime getPickUpTimeDateObject(String? time) {
    return _timeFormat24Post.parse(time!);
  }

  static String getPostDateToSend(DateTime? date) {
    return dateFormatGetEvent.format(date!);
  }

  static String convertDateto24Post(DateTime? dateTime) {
    return _timeFormat24Post.format(dateTime!);
  }

  static String getPickupDateMyPostList(String? time) {
    if (time == null) {
      return '';
    } else {
      var date = _dateFormateWithoutString.parse(time);
      return _dateFormateNoString.format(date);
    }
  }

  static String getMyPostDetailsDate(String? time) {
    if (time == null) {
      return '';
    }
    var date = _dateFormateWithoutString.parse(time);
    return _dateFormatLog.format(date);
  }

  static String getChatScreenTime(DateTime? time) {
    if (time == null) {
      return '';
    }
    return _timeFormat12.format(time);
  }

  static String getWalletDate(DateTime? time) {
    if (time == null) {
      return '';
    }
    return _walletScreenFormate.format(time);
  }

  static bool isTimeBetween(
      DateTime time, DateTime startTime, DateTime endTime) {
    time = _dateTimeFormat.parse(_dateTimeFormat.format(time));
    startTime = _dateTimeFormat.parse(_dateTimeFormat.format(startTime));
    endTime = _dateTimeFormat.parse(_dateTimeFormat.format(endTime));
    if ((time.isAfter(startTime) && time.isBefore(endTime)) ||
        time.isAtSameMomentAs(startTime)) {
      return true;
    } else {
      return false;
    }
  }
}
