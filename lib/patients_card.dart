import 'package:flutter/material.dart';

import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patient_view.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;

  PatientCard(this.patient);

  @override
  _PatientCardState createState() => _PatientCardState(patient);
}

class _PatientCardState extends State<PatientCard> {
   Patient patient;

   _PatientCardState(this.patient);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () { Navigator.push(context,MaterialPageRoute(builder: (context) => PatientView()),);},
      child:Card(
      color: Colors.white,
      // Wrap children in a Padding widget in order to give padding.
      child: Padding(
        // The class that controls padding is called 'EdgeInsets'
        // The EdgeInsets.only constructor is used to set
        // padding explicitly to each side of the child.
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 64.0,
        ),
        // Column is another layout widget -- like stack -- that
        // takes a list of widgets as children, and lays the
        // widgets out from top to bottom.
        child: Column(
          // These alignment properties function exactly like
          // CSS flexbox properties.
          // The main axis of a column is the vertical axis,
          // `MainAxisAlignment.spaceAround` is equivalent of
          // CSS's 'justify-content: space-around' in a vertically
          // laid out flexbox.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.patient.firstname,
                style: Theme.of(context).textTheme.subhead),
            Text(widget.patient.lastname,
                style: Theme.of(context).textTheme.subhead),
            Text(widget.patient.age.toString(),
                style: Theme.of(context).textTheme.subhead),
          ],
        ),
      ),
      ),
    );
  }
}