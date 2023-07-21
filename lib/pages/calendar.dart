import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../app_state.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Event> _eventsForDay = [];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.getEvents();
    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2025, 3, 14),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
          ),
          locale: 'es_ES',
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _eventsForDay = _getEventsForDay(selectedDay, appState.events);
            });
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _eventsForDay.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final event = _eventsForDay[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('${event.name} de ${event.group}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ubicación: ${event.position}'),
                    Text('Descripción: ${event.description}'),
                    // Agregar más información si es necesario
                  ],
                ),
                // Agregar cualquier otra información del evento que desees mostrar
              ),
            );
          },
        ),
      ],
    );
  }

  List<Event> _getEventsForDay(DateTime day, List<Event> eventsData) {
    return eventsData
        .where((event) => isSameDay(
            DateFormat('yyyy-MM-dd HH:mm').parse(event.startDate), day))
        .map((event) => Event(
              event.name,
              event.group,
              event.description,
              event.position,
              event.startDate,
              event.termDate,
            ))
        .toList();
  }
}
