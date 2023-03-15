import 'dart:async';
import '../utils/custom_calendar_utils.dart';

class DateSelector {
  late StreamController<DateTime> _dateController;
  Stream<DateTime> get date => _dateController.stream;

  DateSelector({required DateTime? initialDate}) {
    _dateController = StreamController<DateTime>.broadcast(
        onListen: () async {
          if (initialDate != null) {
            await Future.delayed(const Duration(milliseconds: 0));
            _dateController.add(initialDate.onlyDate);
          }
        },
        sync: true);
  }

  void update(DateTime? date) {
    if (date == null) return;
    _dateController.sink.add(date);
  }

  void dispose() {
    _dateController.close();
  }
}
