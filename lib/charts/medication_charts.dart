import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class MedicationCharts extends StatefulWidget {
  @override
  MedicationChartsState createState() => MedicationChartsState();
}

List<DateTime> allTakenDates = [
  DateTime(2019, 11, 1),
  DateTime(2019, 11, 3),
  DateTime(2019, 11, 4),
  DateTime(2019, 11, 5),
  DateTime(2019, 11, 6),
  DateTime(2019, 11, 11),
  DateTime(2019, 11, 15),
  DateTime(2019, 11, 11),
  DateTime(2019, 11, 15),
];

List<DateTime> someTakenDates = [
  DateTime(2019, 11, 9),
  DateTime(2019, 11, 10),
  DateTime(2019, 11, 14),
  DateTime(2019, 11, 16)
];

List<DateTime> noneTakenDates = [
  DateTime(2019, 11, 2),
  DateTime(2019, 11, 7),
  DateTime(2019, 11, 8),
  DateTime(2019, 11, 12),
  DateTime(2019, 11, 13),
  DateTime(2019, 11, 17),
  DateTime(2019, 11, 18),
  DateTime(2019, 11, 17),
  DateTime(2019, 11, 18),
];

class MedicationChartsState extends State<MedicationCharts> {
  DateTime _currentDate = DateTime.now();
  static Widget _allIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
  static Widget _noneIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
  static Widget _someIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarouselNoHeader;
  double cHeight;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < allTakenDates.length - 1; i++) {
      _markedDateMap.add(
        allTakenDates[i],
        new Event(
          date: allTakenDates[i],
          title: 'All',
          icon: _allIcon(
            allTakenDates[i].day.toString(),
          ),
        ),
      );
    }

    for (int i = 0; i < noneTakenDates.length - 1; i++) {
      _markedDateMap.add(
        noneTakenDates[i],
        new Event(
          date: noneTakenDates[i],
          title: 'None',
          icon: _noneIcon(
            noneTakenDates[i].day.toString(),
          ),
        ),
      );
    }
    for (int i = 0; i < someTakenDates.length - 1; i++) {
      _markedDateMap.add(
        someTakenDates[i],
        new Event(
          date: someTakenDates[i],
          title: 'Some',
          icon: _someIcon(
            someTakenDates[i].day.toString(),
          ),
        ),
      );
    }

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      headerTextStyle: TextStyle(color: Colors.black),
      thisMonthDayBorderColor: Colors.black,
      height: cHeight * 0.54,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.black38,
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal:
          null, // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return event.icon;
      },
    );

    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ListTile(
          title:
              Text("Medication", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        markerRepresent(Colors.red, "None Taken"),
        markerRepresent(Colors.orange, "Some Taken"),
        markerRepresent(Colors.green, "All Taken"),
        Padding(
          padding: EdgeInsets.all(16),
          child: Card(
              color: Color.fromARGB(255, 109, 191, 218),
              child: _calendarCarouselNoHeader),
        ),
      ],
    ));
  }

  Widget markerRepresent(Color color, String data) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: cHeight * 0.022,
      ),
      title: new Text(
        data,
      ),
    );
  }
}
