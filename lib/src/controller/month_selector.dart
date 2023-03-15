import 'dart:async';

import 'package:calendar_picker/src/utils/custom_calendar_utils.dart';

import '../calendar_element.dart';

class MonthSelector {
  final _daysController = StreamController<List<CalendarElement?>>();
  late DateTime lastValue;
  Stream<List<CalendarElement?>> get date => _daysController.stream;
  final Map<DateTime, bool> _excluded = {};
  final _navController = StreamController<DateTime>();
  Stream<DateTime> get currMonth => _navController.stream;

  void initializeDate(DateTime date, List<DateTime> excluded) {
    for (int i = 0; i < excluded.length; i++) {
      _excluded[excluded[i].onlyDate] = true;
    }
    lastValue = date;
    _navController.sink.add(date);
    update();
  }

  void update() {
    final totalDays = CustomCalendarUtils().totalDaysInMonth(lastValue);
    final pos = CustomCalendarUtils().getPosition(lastValue);
    List<CalendarElement?> calendar = [];
    for (int i = 0; i < pos; i++) {
      calendar.add(null);
    }
    for (int i = 1; i <= totalDays; i++) {
      final date = lastValue.copyWith(day: i);
      if (_excluded.containsKey(date)) {
        calendar.add(CalendarElement(date: date, isDisabled: true));
      } else {
        calendar.add(CalendarElement(date: date));
      }
    }
    _daysController.sink.add(List<CalendarElement?>.from(calendar));
  }

  void next() {
    lastValue = lastValue.copyWith(month: lastValue.month + 1);
    _navController.sink.add(lastValue);
    update();
  }

  void prev() {
    lastValue = lastValue.copyWith(month: lastValue.month - 1);
    _navController.sink.add(lastValue);
    update();
  }

  void dispose() {
    _navController.close();
    _daysController.close();
  }
}
