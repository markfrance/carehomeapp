import 'package:carehomeapp/charts/line_chart.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

class BodyCharts extends StatefulWidget{

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

    @override
  void initState() {
    getWeightData(widget.patient);
    getToiletData(widget.patient);

    super.initState();
  }


    void getWeightData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'weight')
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => weightData.add(
                    TimeSeriesWeight(
                        data['timeadded'].toDate(), int.parse(data['kg'])),
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
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => toiletData.add(
                    TimeSeriesToilet(
                        data['timeadded'].toDate(), int.parse(data['kg'])),
                  )),
            }));
  }

   void getToiletSeries() {
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

  @override
  Widget build(BuildContext context) {

     getWeightSeries();
    getToiletSeries();

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
                child: DateTimeComboLinePointChart.withSampleData()),
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
                child: DateTimeComboLinePointChart.withSampleData()),
          ),
         
        ],
      ),
    );
  }
}
