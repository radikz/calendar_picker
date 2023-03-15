import 'package:calendar_picker/src/utils/custom_calendar_utils.dart';
import 'package:flutter/material.dart';

import 'controller/month_selector.dart';

/// This class contains navigator left, right and the current month and year
class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required MonthSelector monthSelector,
  }) : _monthSelector = monthSelector;

  final MonthSelector _monthSelector;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            _monthSelector.prev();
          },
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: StreamBuilder<DateTime>(
                stream: _monthSelector.currMonth,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      CustomCalendarUtils().getMonthText(snapshot.data!),
                      textAlign: TextAlign.center,
                    );
                  }
                  return const SizedBox();
                })),
        const SizedBox(
          width: 8,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            _monthSelector.next();
          },
        ),
      ],
    );
  }
}
