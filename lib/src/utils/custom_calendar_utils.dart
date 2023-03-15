import 'package:intl/intl.dart';

class CustomCalendarUtils {
  String getMonthText(DateTime date) => DateFormat.yMMMM().format(date);

  List<String> getDayNames() {
    DateFormat dayFormat = DateFormat(
      'EEEE',
    );
    return dayFormat.dateSymbols.NARROWWEEKDAYS;
  }

  String getFullDate(DateTime date) {
    return DateFormat.yMMMEd().format(date);
  }

  int totalDaysInMonth(DateTime date) {
    final currentDate = date.copyWith(day: 1);
    final nextDate = currentDate.copyWith(month: currentDate.month + 1);
    return nextDate.difference(currentDate).inDays;
  }

  int getPosition(DateTime date) {
    return date.copyWith(day: 1).weekday;
  }

  bool beforeFirstDateDisabled({DateTime? firstDate, DateTime? date}) {
    if (firstDate == null) return false;
    if (date == null) return true;
    if (date.onlyDate.isBefore(firstDate.onlyDate)) {
      return true;
    }
    return false;
  }

  bool afterLastDateDisabled({DateTime? lastDate, DateTime? date}) {
    if (lastDate == null) return false;
    if (date == null) return true;
    if (date.onlyDate.isAfter(lastDate.onlyDate)) {
      return true;
    }
    return false;
  }
}

extension DateTimeX on DateTime {
  DateTime get onlyDate => DateTime(year, month, day);
}
