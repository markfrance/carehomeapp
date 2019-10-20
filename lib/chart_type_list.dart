import 'package:carehomeapp/body_charts.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/medication_charts.dart';
import 'package:carehomeapp/mood_charts.dart';
import 'package:carehomeapp/nutrition_charts.dart';
import 'package:carehomeapp/other_charts.dart';
import 'package:carehomeapp/vitals_charts.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:flutter/material.dart';

class ChartTypeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
         endDrawer: YellowDrawer(),
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 250, 243, 242),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text("Charts",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black)),
            ),
            iconTheme: new IconThemeData(color: Colors.black)),
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
    if (root.children.isEmpty)
      return ListTile(
        leading: Icon(root.icon),
        title: Text(root.title),
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return root.form;
            }),
      );
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
