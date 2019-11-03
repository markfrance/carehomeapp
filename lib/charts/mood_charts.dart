import 'package:carehomeapp/charts/line_chart.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimeSeriesMood {
  final DateTime time;
  final int mood;

  TimeSeriesMood(this.time, this.mood);
}

class MoodCharts extends StatefulWidget {
  MoodCharts(this.patient);
  final Patient patient;

  @override
  MoodChartState createState() => MoodChartState();
}

class MoodChartState extends State<MoodCharts> {
  List<charts.Series<TimeSeriesMood, DateTime>> weightSeries;
  
  final List<TimeSeriesMood> moodData = [];

  @override
  void initState() {
    getMoodData(widget.patient);


    super.initState();
  }

   void getMoodData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'mood')
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => moodData.add(
                    TimeSeriesMood(
                        data['timeadded'].toDate(),getMoodValue(data['mood'])),
                  )),
            }));
  }


  int getMoodValue(String mood) {
    List<String> values = ['Unwell', 'Sad', 'Confused', 'Neutral', 'Happy', 'Great'];
    return values.indexOf(mood);
  }

  String getMoodDescription(int mood){
    List<String> values = ['Unwell', 'Sad', 'Confused', 'Neutral', 'Happy', 'Great'];
    return values[mood];
  }

  void getMoodSeries() {
    setState(() => weightSeries = [
          charts.Series<TimeSeriesMood, DateTime>(
            id: 'weight',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesMood mood, _) => mood.time,
            measureFn: (TimeSeriesMood mood, _) => mood.mood,
            data: moodData,
            labelAccessorFn: (TimeSeriesMood row, _) => getMoodDescription(row.mood),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    getMoodSeries();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Mood",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 222, 164, 209),
                child: DateTimeComboLinePointChart(weightSeries)),
          ),
        ],),);
  }
}
