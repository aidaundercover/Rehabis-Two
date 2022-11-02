import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/video_call/call.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

CalendarFormat format = CalendarFormat.month;
DateTime selectedDay = DateTime.now();
DateTime focusedDay = DateTime.now();

class _CalendarState extends State<Calendar> {
  TextEditingController _eventController = TextEditingController();

  List<Event> _getEventsfromDay(DateTime date) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("Users/$iinGlobal/Events/");

    ref.get();
    return selectedEvents[date] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _getEventsfromDay(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Calendar",
          style: TextStyle(
              color: Colors.black.withOpacity(0.9),
              fontSize: 20,
              fontFamily: "Inter"),
        ),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
                print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: _getEventsfromDay,

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: secondPrimaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.6),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: Offset(3, 3))
                      ]),
                  child: Row(
                    children: [
                      Container(
                          height: 50,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(13),
                              bottomLeft: Radius.circular(13),
                            ),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        event.title,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.2,),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const VideoCallPageOficial()));
                },
                child: Container(
                  width: 300,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(3,4),
                        spreadRadius: 10,
                        blurRadius: 10
                      )
                    ]
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Video call to the doctor',
                    style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => Theme(
            data: ThemeData(primaryColor: primaryColor),
            child: AlertDialog(
              title: Text("Add Event"),
              content: TextFormField(
                controller: _eventController,
                decoration: InputDecoration(
                  
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) {
                    } else {
                      if (selectedEvents[selectedDay] != null) {
                        selectedEvents[selectedDay]!.add(
                          Event(title: _eventController.text),
                        );
                      } else {
                        selectedEvents[selectedDay] = [
                          Event(title: _eventController.text)
                        ];
                      }
                    }
                    Navigator.pop(context);
                    _eventController.clear();
                    setState(() {});
                    return;
                  },
                ),
              ],
            ),
          ),
        ),
        label: Text("Add Event"),
        focusColor: primaryColor,
        backgroundColor: primaryColor,
        icon: Icon(Icons.add),
      ),
    );
  }
}

class Event {
  final String title;
  Event({required this.title});

  String toString() => this.title;
}
