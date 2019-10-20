import 'package:carehomeapp/patient_edit.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patients_card.dart';

class PatientView extends StatelessWidget {
  final Patient patient = new Patient("first", "patient", 65, "test");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          title: Text('Patient Data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(flex: 5, child: PatientCard(this.patient)),
                  Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(1.0),
                        child: Text("Edit"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientEdit()));
                        },
                      ),
                      flex: 1)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Likes"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Dislikes"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Medical Condition"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contacts"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Key Nurse"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contra Indications"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they hate"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they love"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
