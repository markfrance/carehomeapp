import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/blood_pressure_form.dart';
import 'package:carehomeapp/medication_form.dart';

class LogCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              EntryItem(data[index], context),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[],this.icon, this.form]);

  final String title;
  final IconData icon;
  final Widget form;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry('Mood', new List<Entry>(),CareHomeIcons.mooddark, BloodPressureForm()),
  Entry(
    'Vitals',
    <Entry>[
      Entry('Blood Pressure'),
      Entry('Blood Sugar Level'),
      Entry('Heart Rate'),
    ],
      CareHomeIcons.vitalsdark,
  ),
  Entry('Medication', new List<Entry>(),CareHomeIcons.medicationdark, MedicationForm()),
  Entry('Nutrition',
   <Entry>[
      Entry('Hydration'),
      Entry('Meals'),
    ],
    CareHomeIcons.nutritiondark,
  ),
  Entry('Body', 
   <Entry>[
      Entry('Weight'),
      Entry('Hygiene'),
      Entry('Toilet'),
    ],
    CareHomeIcons.body,
  ),
  Entry('Other', 
   <Entry>[
      Entry('Activity'),
      Entry('Incident'),
    ],
    CareHomeIcons.other,
  ),
];




// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
   EntryItem(this.entry, this.context);

  final Entry entry;
  final BuildContext context;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(
      leading: Icon(root.icon),
      title: Text(root.title),
      onTap: ()=> showDialog(
                context: context,
                builder: (BuildContext context) {
                  return root.form;
                }
              ),
            );
              else return ExpansionTile(
      leading:Icon(root.icon),
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
