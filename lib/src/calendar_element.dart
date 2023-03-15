class CalendarElement {
  final DateTime date;
  final bool isDisabled;

  const CalendarElement({
    required this.date,
    this.isDisabled = false,
  });

  CalendarElement copyWith({
    DateTime? date,
    bool? isDisabled,
  }) {
    return CalendarElement(
      date: date ?? this.date,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }

  @override
  String toString() {
    return 'CalendarElement{date: $date, isDisabled: $isDisabled}';
  }
}
