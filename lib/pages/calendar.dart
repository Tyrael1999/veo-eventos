import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Center(
          child: TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2025, 3, 14),
            focusedDay: _focusedDay,
            locale: 'es_ES',
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          onPressed: () {
            // Add your onPressed code here!
          },
          child: const Icon(Icons.add),
        ));
  }
}
