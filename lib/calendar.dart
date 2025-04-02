import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget{
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context){
    return TableCalendar(
      firstDay: DateTime.utc(2023, 10, 16),
      lastDay: DateTime.utc(2027, 3, 14),
      focusedDay: DateTime.now(),
);
  }
}