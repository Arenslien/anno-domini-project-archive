import 'dart:core';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  DateTime _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

          }),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(),
            ),
            ListTile(
              title: Text("Item 1"),
              onTap: () {

              },
            ),
            ListTile(
              title: Text("Item 2"),
              onTap: () {
                
              },
            )
          ],
        )
      ),

      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 5,
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(1900, 1, 1),
                lastDay: DateTime(2100, 1, 1),

                selectedDayPredicate: (day) {
                  return _selectedDay == day;
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(

                ),
              ),
            ),

            // Container
            Flexible(
              
              flex: 3,
              child: Scrollbar(
                child: Container(
                    decoration: BoxDecoration(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            
          ],
        )
      )
    );
  }
}