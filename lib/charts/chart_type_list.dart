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
              ChartEntryItem(data[index], context, patient),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class ChartEntry {
  ChartEntry(this.title, [this.children = const <ChartEntry>[], this.icon]);

  final String title;
  final IconData icon;
  final List<ChartEntry> children;
}

// The entire multilevel list displayed by this app.
final List<ChartEntry> data = <ChartEntry>[
  ChartEntry('Mood', new List<ChartEntry>(), CareHomeIcons.mooddark),
  ChartEntry('Vitals', new List<ChartEntry>(), CareHomeIcons.vitalsdark),
  ChartEntry(
      'Medication', new List<ChartEntry>(), CareHomeIcons.medicationdark),
  ChartEntry('Nutrition', new List<ChartEntry>(), CareHomeIcons.nutritiondark),
  ChartEntry('Body', new List<ChartEntry>(), CareHomeIcons.body),
  ChartEntry(
    'Other',
    new List<ChartEntry>(),
    CareHomeIcons.other,
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class ChartEntryItem extends StatelessWidget {
  ChartEntryItem(this.entry, this.context, this.patient);

  final ChartEntry entry;
  final BuildContext context;
  final Patient patient;

  Widget _getChart(String title) {
    switch (title) {
      case 'Mood':
        return MoodCharts();
      case 'Vitals':
        return VitalsCharts(patient);
      case 'Medication':
        return MedicationCharts();
      case 'Nutrition':
        return NutritionCharts(patient);
      case 'Body':
        return BodyCharts();
      case 'Other':
        return OtherCharts();
      default:
        return null;
    }
  }

  Widget _buildTiles(ChartEntry root) {
    if (root.children.isEmpty) {
      return ListTile(
          leading: Icon(root.icon),
          title: Text(root.title),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => _getChart(root.title))));
    } else
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
