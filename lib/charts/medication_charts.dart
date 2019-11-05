import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class MedicationCharts extends StatefulWidget {
  Patient patient;
  MedicationCharts(this.patient);
  @override
  MedicationChartsState createState() => MedicationChartsState();
}

List<DateTime> medicationDates = [];
int medicationCount;

List<DateTime> allTakenDates = [];

List<DateTime> someTakenDates = [];


class MedicationChartsState extends State<MedicationCharts> {

  @override
  void initState() {
    getMedicationData(widget.patient);

    super.initState();
  }

  void getMedicationData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'medication')
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              medicationDates.add(data['timeadded'].toDate()),
            }));

    Firestore.instance
        .collection('medication')
        .where('patient', isEqualTo: patient.id)
        .getDocuments()
        .then((documents) => medicationCount = documents.documents.length);
  }

  void showMedicationDates() {
    var medicationMap = Map();

    medicationDates.forEach((date) {
      var dateonly = DateTime.parse(date.year.toString() +
          date.month.toString().padLeft(2, '0') +
          date.day.toString().padLeft(2, '0'));
      if (!medicationMap.containsKey(dateonly)) {
        medicationMap[dateonly] = 1;
      } else {
        medicationMap[dateonly] += 1;
      }
    });

    medicationMap.forEach((k,v) {
      if(v >= medicationCount){
        allTakenDates.add(k);
      }
      else{
        someTakenDates.add(k);
      }
    });
  }
  
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
    showMedicationDates();
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
          null, 
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
