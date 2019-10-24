import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/popup_message.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/blood_pressure_form.dart';
import 'package:carehomeapp/blood_sugar_level_form.dart';
import 'package:carehomeapp/heart_rate_form.dart';
import 'package:carehomeapp/medication_form.dart';
import 'package:carehomeapp/mood_form.dart';
import 'package:carehomeapp/activity_form.dart';
import 'package:carehomeapp/incident_form.dart';
import 'package:carehomeapp/weight_form.dart';
import 'package:carehomeapp/toilet_form.dart';
import 'package:carehomeapp/hygiene_form.dart';
import 'package:carehomeapp/hydration_form.dart';
import 'package:carehomeapp/meals_form.dart';

class LogCheck extends StatefulWidget {
  @override
  LogCheckState createState() => LogCheckState();
}

class LogCheckState extends State<LogCheck> {
  Patient dropdownValue;

  @override
  Widget build(BuildContext context) {
    final user = UserBinding.of(context).user;
  
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
        body: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(flex:2,
            
            child:Align(
              alignment: Alignment.topLeft,
              child: Theme(
          data: ThemeData(
            
            canvasColor: Color.fromARGB(255, 249, 210, 45),
           
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 25, top:16, bottom:8),
            child:Container(
            decoration: BoxDecoration(color: Color.fromARGB(255, 249, 210, 45), borderRadius: BorderRadius.circular(8)),
            
            child: FutureBuilder<List<Patient>>(
                  future: user.getPatients(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Patient>> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButton<Patient>(
                      hint:dropdownValue == null ? Padding(child:Text("Patient Name"), padding:EdgeInsets.only(left:8)) 
                      : Padding(child:Text(dropdownValue.firstname + " " + dropdownValue.lastname), padding:EdgeInsets.only(left:8)),
                      isExpanded: true,
                      value:null,
                      items: snapshot.data
                            .map((patient) => DropdownMenuItem<Patient>(
                                  child: Container(
                                    child:Text(patient.firstname +
                                      " " +
                                      patient.lastname),
                                       color: Color.fromARGB(255, 249, 210, 45),
                                  ),
                                  value: patient,
                                  
                                ))
                            .toList(),
                      onChanged: (Patient newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            print(newValue);
                          });
                        });
                  }),)))
            ),),
            Spacer(),
            ]),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    EntryItem(data[index], context, dropdownValue),
                itemCount: data.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[], this.icon, this.form]);

  final String title;
  final String icon;
  final String form;
  final List<Entry> children;
}

Widget getIcon(String icon) {
  if (icon == null) {
    return null;
  } else {
    return Image.asset(icon);
  }
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry('Mood', new List<Entry>(), "assets/images/moodicon.png", 'mood'),
  Entry(
    'Vitals',
    <Entry>[
      Entry('Blood Pressure', new List<Entry>(), null, 'bloodpressure'),
      Entry('Blood Sugar Level', new List<Entry>(), null, 'bloodsugar'),
      Entry('Heart Rate', new List<Entry>(), null, 'heartrate'),
    ],
    "assets/images/vitalsicon.png",
  ),
  Entry('Medication', new List<Entry>(), "assets/images/medsicon.png",
      'medication'),
  Entry(
    'Nutrition',
    <Entry>[
      Entry('Hydration', new List<Entry>(), null, 'hydration'),
      Entry('Meals', new List<Entry>(), null, 'meals'),
    ],
    "assets/images/nutrition.png",
  ),
  Entry(
    'Body',
    <Entry>[
      Entry('Weight', new List<Entry>(), null, 'weight'),
      Entry('Hygiene', new List<Entry>(), null, 'hygiene'),
      Entry('Toilet', new List<Entry>(), null, 'toilet'),
    ],
    "assets/images/body.png",
  ),
  Entry(
    'Other',
    <Entry>[
      Entry('Activity', new List<Entry>(), null, 'activity'),
      Entry('Incident', new List<Entry>(), null, 'incident'),
    ],
    "assets/images/other.png",
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  EntryItem(this.entry, this.context, this.patient);

  final Patient patient;
  final Entry entry;
  final BuildContext context;

  Widget getForm(String formname) {
    switch (formname) {
      case 'mood':
        return MoodForm(patient);
      case 'bloodpressure':
        return BloodPressureForm(patient);
      case 'bloodsugar':
        return BloodSugarLevelForm(patient);
      case 'heartrate':
        return HeartRateForm(patient);
      case 'medication':
        return MedicationForm(patient, true);
      case 'hydration':
        return HydrationForm(patient);
      case 'meals':
        return MealsForm(patient);
      case 'weight':
        return WeightForm(patient);
      case 'hygiene':
        return HygieneForm(patient);
      case 'toilet':
        return ToiletForm(patient);
      case 'activity':
        return ActivityForm(patient);
      case 'incident':
        return IncidentForm(patient);

      default:
        return null;
    }
  }

  Widget _buildTiles(Entry root) {

    if (root.children.isEmpty)
      return Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: getIcon(root.icon),
          title: Text(root.title,
              style: TextStyle(
                  fontSize: root.icon != null ? 20 : 16,
                  fontWeight: FontWeight.bold)),
          onTap: () => {
            patient == null ?
            showDialog(
              context: context,
              builder: (BuildContext context){
                return Center(
                  child:PopupMessage("Please first select patient"));
              }
            ) :
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return getForm(root.form);
              })},
        ),
      );
    else
      return Padding(
        padding: EdgeInsets.all(8),
        child: ExpansionTile(
          leading: getIcon(root.icon),
          key: PageStorageKey<Entry>(root),
          title: Text(root.title,
              style: TextStyle(
                  fontSize: root.icon != null ? 20 : 16,
                  fontWeight: FontWeight.bold)),
          children: root.children.map(_buildTiles).toList(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
