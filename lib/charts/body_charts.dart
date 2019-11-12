import 'package:carehomeapp/charts/line_chart.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class TimeSeriesWeight {
  final DateTime time;
  final int kg;

  TimeSeriesWeight(this.time, this.kg);
}

class TimeSeriesToilet {
  final DateTime time;
  final int visits;

  TimeSeriesToilet(this.time, this.visits);
}

class BodyCharts extends StatefulWidget {
  BodyCharts(this.patient);
  final Patient patient;

  @override
  BodyChartState createState() => BodyChartState();
}

class BodyChartState extends State<BodyCharts> {
  List<charts.Series<TimeSeriesWeight, DateTime>> weightSeries;
  List<charts.Series<TimeSeriesToilet, DateTime>> toiletSeries;

  final List<TimeSeriesWeight> weightData = [];
  final List<TimeSeriesToilet> toiletData = [];
  List<DateTime> toiletVisits = [];
  List<DateTime> hygieneDates = [];

  @override
  void initState() {
    getWeightData(widget.patient);
    getToiletData(widget.patient);
    getHygieneData(widget.patient);

    super.initState();
  }

  void getWeightData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'weight')
        .orderBy('timeadded', descending: false)
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => weightData.add(
                    TimeSeriesWeight(
                        data['timeadded'].toDate(), int.parse(data['weight'])),
                  )),
            }));
  }

  void getWeightSeries() {
    setState(() => weightSeries = [
          charts.Series<TimeSeriesWeight, DateTime>(
            id: 'weight',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesWeight weight, _) => weight.time,
            measureFn: (TimeSeriesWeight weight, _) => weight.kg,
            data: weightData,
          )
        ]);
  }

  void getToiletData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'toilet')
        .orderBy('timeadded', descending: false)
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              toiletVisits.add(data['timeadded'].toDate()),
            }));
  }

  void getToiletSeries() {
    var toiletMap = Map();

    toiletVisits.forEach((date) {
      var dateonly = DateTime.parse(date.year.toString() +
          date.month.toString().padLeft(2, '0') +
          date.day.toString().padLeft(2, '0'));
      if (!toiletMap.containsKey(dateonly)) {
        toiletMap[dateonly] = 1;
      } else {
        toiletMap[dateonly] += 1;
      }
    });
    toiletMap.forEach((k, v) => toiletData.add(TimeSeriesToilet(k, v)));

    setState(() => toiletSeries = [
          charts.Series<TimeSeriesToilet, DateTime>(
            id: 'toilet',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesToilet toilet, _) => toilet.time,
            measureFn: (TimeSeriesToilet toilet, _) => toilet.visits,
            data: toiletData,
          )
        ]);
  }


  void getHygieneData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('type', isEqualTo: 'hygiene')
        .orderBy('timeadded', descending: false)
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              hygieneDates.add(data['timeadded'].toDate()),
            }));
  }

 static Widget _hygieneIcon(String day) => Container(
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
    getWeightSeries();
    getToiletSeries();

cHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < hygieneDates.length - 1; i++) {
      _markedDateMap.add(
        hygieneDates[i],
        new Event(
          date: hygieneDates[i],
          title: 'Hygiene',
          icon: _hygieneIcon(
            hygieneDates[i].day.toString(),
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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Body",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Weight (kg)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 244, 174, 124),
                child: DateTimeComboLinePointChart(weightSeries)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Toilet (visits)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 244, 174, 124),
                child: DateTimeComboLinePointChart(toiletSeries)),
          ),
            Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Hygiene",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
          padding: EdgeInsets.all(16),
          child: Card(
              color:Color.fromARGB(255, 244, 174, 124),
              child: _calendarCarouselNoHeader),
        ),
        ],
      ),
    );
  }
}
