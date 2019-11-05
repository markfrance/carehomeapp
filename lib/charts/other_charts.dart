import 'package:carehomeapp/charts/line_chart.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class TimeSeriesIncident {
  final DateTime time;
  final int incidents;
  
  TimeSeriesIncident(this.time, this.incidents);
}

class OtherCharts extends StatefulWidget {
  OtherCharts(this.patient);
  final Patient patient;

  @override
  _OtherChartsState createState() => _OtherChartsState();
}

class _OtherChartsState extends State<OtherCharts> {

  List<charts.Series<TimeSeriesIncident, DateTime>> incidentSeries;
  final List<TimeSeriesIncident> incidentData = [];
  List<DateTime> incidents = [];
  List<DateTime> activityDates = [];

  @override
  void initState() {
    getIncidentData(widget.patient);
    getHygieneData(widget.patient);

    super.initState();
  }

  void getHygieneData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'activity')
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              activityDates.add(data['timeadded'].toDate()),
            }));
  }

  void getIncidentData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'incident')
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              incidents.add(data['timeadded'].toDate()),
            }));
  }

  void getIncidentSeries() {
    var incidentMap = Map();

    incidents.forEach((date) {
      var dateonly = DateTime.parse(date.year.toString() +
          date.month.toString().padLeft(2, '0') +
          date.day.toString().padLeft(2, '0'));
      if (!incidentMap.containsKey(dateonly)) {
        incidentMap[dateonly] = 1;
      } else {
        incidentMap[dateonly] += 1;
      }
    });
    incidentMap.forEach((k, v) => setState(() => incidentData.add(TimeSeriesIncident(k, v))));

    setState(() => incidentSeries = [
          charts.Series<TimeSeriesIncident, DateTime>(
            id: 'incident',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesIncident incident, _) => incident.time,
            measureFn: (TimeSeriesIncident incident, _) => incident.incidents,
            data: incidentData,
          )
        ]);
  }

  static Widget _activityIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.blue,
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
    for (int i = 0; i < activityDates.length - 1; i++) {
      _markedDateMap.add(
        activityDates[i],
        new Event(
          date: activityDates[i],
          title: 'Activity',
          icon: _activityIcon(
            activityDates[i].day.toString(),
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

    getIncidentSeries();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Other",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Number of Incidents",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 166, 200, 212),
                child: DateTimeComboLinePointChart(incidentSeries),
          ),),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Activity",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
           Padding(
          padding: EdgeInsets.all(16),
          child: Card(
              color:Color.fromARGB(255, 166, 200, 212),
              child: _calendarCarouselNoHeader),
        ),
        
        ],
      ),
    );
  }
}