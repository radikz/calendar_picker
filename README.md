# Calendar Picker

This package enables the display of a Material Date Picker and offers additional functionality, including the ability to exclude specific dates.

## Usage
```dart
MaterialButton(
  color: Colors.blue,
  onPressed: () {
    showCustomCalendarPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      excluded: [
        DateTime.now().add(const Duration(days: 2)),
        DateTime.now().add(const Duration(days: 5)),
        DateTime.now().subtract(const Duration(days: 5)),
      ],
      onSelected: (date) {
        print("date $date");
      },
    );
  },
  child: const Text("calendar picker", style: TextStyle(color: Colors.white),),
)
```

## Contributing
Any kind of support in the form of reporting bugs, answering questions or PRs is always appreciated.