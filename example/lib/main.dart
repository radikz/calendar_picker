import 'package:calendar_picker/calendar_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: MaterialButton(
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
            child: const Text(
              "calendar picker",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
