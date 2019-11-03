import 'package:carehomeapp/charts/chart_type_list.dart';
import 'package:carehomeapp/feed/feed_list.dart';
import 'package:carehomeapp/logcheck/medication_form.dart';
import 'package:carehomeapp/patient/patient_view.dart';
import 'package:carehomeapp/patient/tasks_view.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';

class PatientHome extends StatefulWidget {
  PatientHome(this.patient, this.followText);

  final Patient patient;
  final String followText;
  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  int _selectedIndex = 0;

  void _setIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    final widgetOptions = [
      FeedList(widget.patient),
      MedicationForm(widget.patient, false),
      ChartTypeList(widget.patient),
      TasksView(widget.patient)
    ];

    return Scaffold(
      endDrawer: YellowDrawer(),
      appBar: AppBar(
        title: Text(widget.patient.firstname + " " + widget.patient.lastname),
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
      ),
      body: Column(children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                    top: 18.0,
                    bottom: 18.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                                widget.patient.imageUrl ?? "assets/images/avatar_placeholder_small.png",
                                width: 50,
                                height: 50),
                          )),
                      Column(
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
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(widget.followText),
                              onPressed: () => null,)
                        ),
                      )),
                      FlatButton(
                        child: Icon(Icons.info, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PatientView(widget.patient, widget.followText)));
                        },
                      ),
                    ],
                  ),
                ))
              ],
            ),
            Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Feed"), onPressed: () => _setIndex(0)),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Medication"), onPressed: () => _setIndex(1)),
                ),
                Spacer(),
              ],
            ),
            Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Chart"), onPressed: () => _setIndex(2)),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Tasks"), onPressed: () => _setIndex(3)),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
        Expanded(child: widgetOptions.elementAt(_selectedIndex))
      ]),
    );
  }
}
