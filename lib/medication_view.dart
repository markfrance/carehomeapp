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
    return Column(
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
                  return AddMedicationForm();
                },
              ),
              child: Icon(CareHomeIcons.addb),
            ),
          ],
        ),
      ],
    );
  }
}
