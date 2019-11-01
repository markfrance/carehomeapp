import 'package:carehomeapp/charts/line_chart.dart';
import 'package:flutter/material.dart';

class BodyCharts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
