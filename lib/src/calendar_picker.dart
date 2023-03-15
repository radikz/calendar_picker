import 'dart:async';

import 'package:flutter/material.dart';
import 'calendar_element.dart';
import 'calendar_header.dart';
import 'controller/date_selector.dart';
import 'controller/month_selector.dart';
import 'utils/custom_calendar_utils.dart';

/// Shows a dialog that contains Material Date Picker
///
/// Param [initialDate] is required and it represents the selected date
/// The month of / [initialDate] will be displayed in the date picker at
/// startup, with [initialDate] selected.
///
/// The [firstDate] parameter represents the earliest selectable date within
/// the calendar.
/// The [lastDate] parameter represents the latest selectable date within
/// the calendar.
///
/// The [initialDate] must be within the range of [firstDate] and [lastDate].
///
/// An optional list of [excluded] dates can be provided to restrict the
/// selection of certain dates.
///
/// Function [onSelected] is callback when a date is selected.
Future<void> showCustomCalendarPicker(
    {required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    List<DateTime> excluded = const [],
    required void Function(DateTime) onSelected}) async {
  if (lastDate != null && firstDate != null) {
    assert(
      !lastDate.onlyDate.isBefore(firstDate.onlyDate),
      'lastDate ${lastDate.onlyDate} must be on or after firstDate ${firstDate.onlyDate}.',
    );
  }

  if (firstDate != null) {
    assert(
      !initialDate.onlyDate.isBefore(firstDate.onlyDate),
      'initialDate ${initialDate.onlyDate} must be on or after firstDate ${firstDate.onlyDate}.',
    );
  }

  if (lastDate != null) {
    assert(
      !initialDate.onlyDate.isAfter(lastDate.onlyDate),
      'initialDate ${initialDate.onlyDate} must be on or before lastDate ${lastDate.onlyDate}.',
    );
  }

  showDialog(
    context: context,
    builder: (context) {
      return CustomCalendarDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          excluded: excluded,
          onSelected: onSelected);
    },
  );
}

/// A Material-style date picker dialog.
///
/// It is used internally by [showCustomCalendarPicker]
class CustomCalendarDialog extends StatefulWidget {
  const CustomCalendarDialog(
      {Key? key,
      this.lastDate,
      this.firstDate,
      this.excluded = const [],
      required this.initialDate,
      required this.onSelected})
      : super(key: key);

  /// Param [initialDate] is required and it represents the selected date
  /// The month of / [initialDate] will be displayed in the date picker at
  /// startup, with [initialDate] selected.
  final DateTime initialDate;

  /// The [firstDate] parameter represents the earliest selectable date within
  /// the calendar.
  final DateTime? firstDate;

  /// The [lastDate] parameter represents the latest selectable date within
  /// the calendar.
  final DateTime? lastDate;

  /// An optional list of [excluded] dates can be provided to restrict the
  /// selection of certain dates.
  final List<DateTime> excluded;

  /// Function [onSelected] is callback when a date is selected.
  final void Function(DateTime) onSelected;

  @override
  State<CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<CustomCalendarDialog> {
  DateTime? _selectedDate;
  late DateSelector _selector, _displaySelector;
  late MonthSelector _monthSelector;

  final List<String> days = [];

  @override
  void initState() {
    days.addAll(CustomCalendarUtils().getDayNames());
    _selector = DateSelector(initialDate: widget.initialDate.onlyDate);
    _displaySelector = DateSelector(initialDate: widget.initialDate.onlyDate);
    _monthSelector = MonthSelector()
      ..initializeDate(widget.initialDate.onlyDate, widget.excluded);
    _selectedDate = widget.initialDate.onlyDate;
    super.initState();
  }

  @override
  void dispose() {
    _selector.dispose();
    _displaySelector.dispose();
    _monthSelector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth * 0.6;
      final itemHeight = constraints.maxHeight * 0.5;

      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Visibility(
                visible: constraints.maxWidth >= 480,
                child: Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: StreamBuilder<DateTime>(
                          stream: _displaySelector.date,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                CustomCalendarUtils()
                                    .getFullDate(snapshot.data!),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              );
                            }
                            return const SizedBox();
                          }),
                    )),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CalendarHeader(monthSelector: _monthSelector),
                        SizedBox(
                          height: 40,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio:
                                        constraints.maxWidth >= 480
                                            ? itemWidth / itemHeight
                                            : 1.5,
                                    crossAxisCount: 7),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              return Center(child: Text(days[index]));
                            },
                          ),
                        ),
                        SizedBox(
                          height: itemHeight,
                          child: StreamBuilder<List<CalendarElement?>>(
                              stream: _monthSelector.date,
                              builder: (context, days) {
                                if (days.hasData) {
                                  return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio:
                                                constraints.maxWidth >= 480
                                                    ? itemWidth / itemHeight
                                                    : itemHeight / itemWidth,
                                            crossAxisCount: 7),
                                    itemCount: days.data!.length,
                                    physics: constraints.maxWidth >= 480
                                        ? null
                                        : const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final element =
                                          days.data?.elementAt(index);
                                      final isDisabled = CustomCalendarUtils()
                                              .beforeFirstDateDisabled(
                                                  date: element?.date,
                                                  firstDate:
                                                      widget.firstDate) ||
                                          CustomCalendarUtils()
                                              .afterLastDateDisabled(
                                                  date: element?.date,
                                                  lastDate: widget.lastDate);
                                      return Visibility(
                                        visible: element != null,
                                        child: InkWell(
                                          onTap: !isDisabled
                                              ? () {
                                                  if (element!.isDisabled) {
                                                    return;
                                                  } else {
                                                    _selectedDate =
                                                        element.date;
                                                    _selector
                                                        .update(element.date);
                                                    _displaySelector
                                                        .update(element.date);
                                                  }
                                                }
                                              : null,
                                          child: Center(
                                            child: StreamBuilder<DateTime>(
                                                stream: _selector.date,
                                                builder: (context, snapshot) {
                                                  if (snapshot.data ==
                                                      element!.date) {
                                                    return CircleAvatar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      child: Text(
                                                        "${element.date.day}",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary),
                                                      ),
                                                    );
                                                  }
                                                  return Text(
                                                    "${element.date.day}",
                                                    style: TextStyle(
                                                        color: isDisabled ||
                                                                element
                                                                    .isDisabled
                                                            ? Colors.grey
                                                            : Colors.black),
                                                  );
                                                }),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "CANCEL",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (_selectedDate != null) {
                                widget.onSelected(_selectedDate!);
                                Navigator.pop(context);
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Theme.of(context).colorScheme.primary,
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
