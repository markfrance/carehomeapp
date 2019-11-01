import 'package:carehomeapp/charts/body_charts.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/charts/medication_charts.dart';
import 'package:carehomeapp/charts/mood_charts.dart';
import 'package:carehomeapp/charts/nutrition_charts.dart';
import 'package:carehomeapp/charts/other_charts.dart';
import 'package:carehomeapp/charts/vitals_charts.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:flutter/material.dart';

class ChartTypeList extends StatelessWidget {

  final Patient patient;
  ChartTypeList(this.patient);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              ChartEntryItem(data[index], context),
          itemCount: data.length,
        ),
      ),
    );
  }
}


// One entry in the multilevel list displayed by this app.
class ChartEntry {
  ChartEntry(this.title, [this.children = const <ChartEntry>[], this.icon, this.form]);

  final String title;
  final IconData icon;
  final Widget form;
  final List<ChartEntry> children;
}

// The entire multilevel list displayed by this app.
final List<ChartEntry> data = <ChartEntry>[
  ChartEntry('Mood', new List<ChartEntry>(), CareHomeIcons.mooddark, MoodCharts()),
  ChartEntry('Vitals', new List<ChartEntry>(), CareHomeIcons.vitalsdark, VitalsCharts()),
  ChartEntry(
    'Medication',
    new List<ChartEntry>(),
    CareHomeIcons.medicationdark,
    MedicationCharts(),
  ),
  ChartEntry(
    'Nutrition',
    new List<ChartEntry>(),
    CareHomeIcons.nutritiondark,
    NutritionCharts(),
  ),
  ChartEntry('Body', new List<ChartEntry>(), CareHomeIcons.body, BodyCharts()),
  ChartEntry(
    'Other',
    new List<ChartEntry>(),
    CareHomeIcons.other,
    OtherCharts(),
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class ChartEntryItem extends StatelessWidget {
  ChartEntryItem(this.entry, this.context);

  final ChartEntry entry;
  final BuildContext context;

  Widget _buildTiles(ChartEntry root) {
    if (root.children.isEmpty){
      return ListTile(
        leading: Icon(root.icon),
        title: Text(root.title),
        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => root.form
                                      )));
             
            
  }
    else
      return ExpansionTile(
        leading: Icon(root.icon),
        key: PageStorageKey<ChartEntry>(root),
        title: Text(root.title),
        children: root.children.map(_buildTiles).toList(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
