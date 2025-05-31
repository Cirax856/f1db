import 'package:intl/intl.dart';

String parseDate(String dateinput, String timeinput) {
  DateTime date = DateTime.parse('${dateinput}T$timeinput').toLocal();

  var day = date.day;
  var suffixa = suffix(day);

  var formatted = DateFormat("MMM yyyy, h:mm a").format(date);
  return "$day$suffixa $formatted";
}

String suffix(int day) {
    if (day >= 11 && day <= 13) return "th";
    switch (day % 10) {
      case 1: return "st";
      case 2: return "nd";
      case 3: return "rd";
      default: return "th";
    }
  }