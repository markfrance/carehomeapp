import 'package:carehomeapp/add_medication_form.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:flutter/material.dart';

class MedicationView extends StatefulWidget {
  @override
  _MedicationViewState createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
  Map<String, bool> values = {
    '08:30': true,
    '06:32': false,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
        margin:EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
  color: Color.fromARGB(255, 109, 191, 218),
      child:Padding(
        padding:EdgeInsets.all(18),
        child:Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Medication",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: values.keys.map((String key) {
            return CheckboxListTile(
              title: new Text(key),
              value: values[key],
              onChanged: (bool value) {
                setState(() {
                  values[key] = value;
                });
              },
            );
          }).toList(),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return null;//AddMedicationForm();
                },
              ),
              child: Icon(CareHomeIcons.addb),
            ),
          ],
        ),
      ],
      ),
      ),
    );
  }
}
