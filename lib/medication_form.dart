import 'package:carehomeapp/add_medication_form.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:flutter/material.dart';

class MedicationForm extends StatefulWidget {
  @override
  MedicationState createState() => new MedicationState();
}

class Medication{
  final String description;
   DateTime time;

  Medication(this.description);
}

class MedicationState extends State<MedicationForm> {
  Map<String, bool> values = {
    '08:30': true,
    '06:32': false,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 204, 241, 255),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(),
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
              FlatButton(
                onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddMedicationForm();
            },
                ),
                child:Icon(CareHomeIcons.addb),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Save"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
