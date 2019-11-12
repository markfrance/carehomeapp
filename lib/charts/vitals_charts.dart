import 'package:carehomeapp/charts/line_chart.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimeSeriesHeartRate {
  final DateTime time;
  final int rate;

  TimeSeriesHeartRate(this.time, this.rate);
}

class TimeSeriesBloodSugar {
  final DateTime time;
  final int level;

  TimeSeriesBloodSugar(this.time, this.level);
}

class TimeSeriesBloodPressure {
  final DateTime time;
  final int systolic;
  final int diastolic;

  TimeSeriesBloodPressure(this.time, this.systolic, this.diastolic);
}

class VitalsCharts extends StatefulWidget {
  VitalsCharts(this.patient);
  final Patient patient;
  @override
  VitalsChartState createState() => VitalsChartState();
}

class VitalsChartState extends State<VitalsCharts> {
  List<charts.Series<TimeSeriesHeartRate, DateTime>> heartRateSeries;
  List<charts.Series<TimeSeriesBloodPressure, DateTime>> bloodPressureSeries;
  List<charts.Series<TimeSeriesBloodSugar, DateTime>> bloodSugarSeries;

  final List<TimeSeriesHeartRate> heartRateData = [];
  final List<TimeSeriesBloodPressure> bloodPressureData = [];
  final List<TimeSeriesBloodSugar> bloodSugarData = [];

  @override
  void initState() {
    getHeartRateData(widget.patient);
    getBloodPressureData(widget.patient);
    getBloodSugarData(widget.patient);

    super.initState();
  }

  void getHeartRateSeries() {
    setState(() => heartRateSeries = [
          charts.Series<TimeSeriesHeartRate, DateTime>(
            id: 'heart rate',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesHeartRate heartrate, _) => heartrate.time,
            measureFn: (TimeSeriesHeartRate heartrate, _) => heartrate.rate,
            data: heartRateData,
          )
        ]);
  }

  void getHeartRateData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'heartrate')
        .orderBy('timeadded', descending: false)
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => heartRateData.add(
                    TimeSeriesHeartRate(
                        data['timeadded'].toDate(), int.parse(data['bpm'])),
                  )),
            }));
  }

  void getBloodSugarSeries() {
    setState(() => bloodSugarSeries = [
          charts.Series<TimeSeriesBloodSugar, DateTime>(
            id: 'blood sugar',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesBloodSugar bloodSugar, _) => bloodSugar.time,
            measureFn: (TimeSeriesBloodSugar bloodSugar, _) => bloodSugar.level,
            data: bloodSugarData,
          )
        ]);
  }

  void getBloodSugarData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'bloodsugar')
        .orderBy('timeadded', descending: false)
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => bloodSugarData.add(
                    TimeSeriesBloodSugar(
                        data['timeadded'].toDate(), int.parse(data['level'])),
                  )),
            }));
  }

  void getBloodPressureSeries() {
    setState(() => bloodPressureSeries = [
          charts.Series<TimeSeriesBloodPressure, DateTime>(
            id: 'systolic',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesBloodPressure pressure, _) => pressure.time,
            measureFn: (TimeSeriesBloodPressure pressure, _) =>
                pressure.systolic,
            data: bloodPressureData,
          ),
          charts.Series<TimeSeriesBloodPressure, DateTime>(
            id: 'diastolic',
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (TimeSeriesBloodPressure pressure, _) => pressure.time,
            measureFn: (TimeSeriesBloodPressure pressure, _) =>
                pressure.diastolic,
            data: bloodPressureData,
          )
        ]);
  }

  void getBloodPressureData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'bloodpressure')
        .orderBy('timeadded', descending: false)
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => bloodPressureData.add(
                    TimeSeriesBloodPressure(
                        data['timeadded'].toDate(),
                        int.parse(data['systolic']),
                        int.parse(data['diastolic'])),
                  )),
            }));
  }

  @override
  Widget build(BuildContext context) {
    getHeartRateSeries();
    getBloodPressureSeries();
    getBloodSugarSeries();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Vitals",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Heart Rate (bpm)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Visibility(
            visible: heartRateSeries != null || heartRateSeries?.length != 0,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                  color: Color.fromARGB(255, 251, 148, 148),
                  child: DateTimeComboLinePointChart(heartRateSeries)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Blood Sugar (mmo/l)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 251, 148, 148),
                child: DateTimeComboLinePointChart(bloodSugarSeries)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Blood Pressure",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 251, 148, 148),
                child: DateTimeComboLinePointChart(bloodPressureSeries)),
          ),
        ],
      ),
    );
  }
}