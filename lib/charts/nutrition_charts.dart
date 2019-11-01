import 'package:carehomeapp/charts/line_chart.dart';
import 'package:flutter/material.dart';

class NutritionCharts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                child: DateTimeComboLinePointChart.withSampleData()),
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
                child: DateTimeComboLinePointChart.withSampleData()),
          ),
         
        ],
      ),
    );
  }
}
