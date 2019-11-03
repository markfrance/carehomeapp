import 'package:carehomeapp/charts/line_chart.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimeSeriesHydration {
  final DateTime time;
  final int l;

  TimeSeriesHydration(this.time, this.l);
}

class TimeSeriesMeal {
  final DateTime time;
  final int gm;

  TimeSeriesMeal(this.time, this.gm);
}

class NutritionCharts extends StatefulWidget{
  NutritionCharts(this.patient);
  final Patient patient;

  @override
  NutritionChartState createState() => NutritionChartState();
}

class NutritionChartState extends State<NutritionCharts> {

  List<charts.Series<TimeSeriesHydration, DateTime>> hydrationSeries;
  List<charts.Series<TimeSeriesMeal, DateTime>> mealSeries;


  final List<TimeSeriesHydration> hydrationData = [];
  final List<TimeSeriesMeal> mealData = [];

   @override
  void initState() {
    getHydrationData(widget.patient);
    getMealData(widget.patient);

    super.initState();
  }

  void getHydrationSeries() {
    setState(() => hydrationSeries = [
          charts.Series<TimeSeriesHydration, DateTime>(
            id: 'hydration',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesHydration hydration, _) => hydration.time,
            measureFn: (TimeSeriesHydration hydration, _) => hydration.l,
            data: hydrationData,
          )
        ]);
  }

  void getHydrationData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'hydration')
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => hydrationData.add(
                    TimeSeriesHydration(
                        data['timeadded'].toDate(), int.parse(data['l'])),
                  )),
            }));
  }


  void getMealSeries() {
    setState(() => mealSeries = [
          charts.Series<TimeSeriesMeal, DateTime>(
            id: 'meal',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesMeal meal, _) => meal.time,
            measureFn: (TimeSeriesMeal meal, _) => meal.gm,
            data: mealData,
          )
        ]);
  }

  void getMealData(Patient patient) {
    Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: patient.id)
        .where('subtype', isEqualTo: 'meals')
        .getDocuments()
        .then((documents) => documents.documents.forEach((data) => {
              setState(() => mealData.add(
                    TimeSeriesMeal(
                        data['timeadded'].toDate(), int.parse(data['gm'])),
                  )),
            }));
  }

  @override
  Widget build(BuildContext context) {

    getHydrationSeries();
    getMealSeries();
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Nutrition",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Hydration (L)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 186, 225, 189),
                child: DateTimeComboLinePointChart(hydrationSeries)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 0, bottom: 8),
            child: ListTile(
              title: Text("Meal (gm)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
                color: Color.fromARGB(255, 186, 225, 189),
                child: DateTimeComboLinePointChart(mealSeries)),
          ),
         
        ],
      ),
    );
  }
}
