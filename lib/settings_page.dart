import 'package:carehomeapp/model/user_binding.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final user = UserBinding.of(context).user;
    bool likes = false;
    bool comments = false;
    bool medication = false;
    bool patientpost = false;

    return Scaffold(
        appBar: AppBar(
          backgroundColor:  Color.fromARGB(255, 250, 243, 242),
          title: Text("Settings"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Text("Settings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                margin: EdgeInsets.only(left:16.0, right:16, top:0, bottom:8 ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Color.fromARGB(255, 250, 243, 242),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 18.0,
                    bottom: 18.0,
                    left: 18.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Align(
                        child: Text("Email",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        alignment: Alignment.centerLeft,
                      ),
                      Padding(
                          child: Align(
                              child: Text(user.email),
                              alignment: Alignment.centerLeft),
                          padding: EdgeInsets.only(bottom: 16)),
                      Align(
                        child: Text("Password",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        alignment: Alignment.centerLeft,
                      ),
                      Align(
                          child: Text("********"),
                          alignment: Alignment.centerLeft),
                    /*  Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 16,
                                right: 16,
                              ),
                              child: RaisedButton(
                                child: Text("Edit"),
                                color: Colors.black,
                                onPressed: null,
                              ))),*/
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.only(left:16.0, right:16, top:8, bottom:8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Color.fromARGB(255, 250, 243, 242),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: 18.0,
                        bottom: 18.0,
                        left: 18.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                              child: Text("Notifications",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              alignment: Alignment.centerLeft),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text("Patient post"), flex: 4),
                              Expanded(
                                  flex: 1,
                                  child: Switch(
                                    activeColor:
                                        Color.fromARGB(255, 35, 33, 26),
                                    value: patientpost,
                                    onChanged: (value) => {
                                      setState(() {
                                        patientpost = value;
                                      })
                                    },
                                  )),
                            ],
                          ),
                            Row(
                            children: <Widget>[
                              Expanded(child: Text("Likes"), flex: 4),
                              Expanded(
                                  flex: 1,
                                  child: Switch(
                                    activeColor:
                                        Color.fromARGB(255, 35, 33, 26),
                                    value: likes,
                                    onChanged: (value) => {
                                      setState(() {
                                        likes = value;
                                      })
                                    },
                                  )),
                            ],),
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text("Comments"), flex: 4),
                                  Expanded(
                                      flex: 1,
                                      child: Switch(
                                        activeColor:
                                            Color.fromARGB(255, 35, 33, 26),
                                        value: comments,
                                        onChanged: (value) => {
                                          setState(() {
                                            comments = value;
                                          })
                                        },
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text("Medication reminder"),
                                      flex: 4),
                                  Expanded(
                                      flex: 1,
                                      child: Switch(
                                        activeColor:
                                            Color.fromARGB(255, 35, 33, 26),
                                        value: medication,
                                        onChanged: (value) => {
                                          setState(() {
                                            medication = value;
                                          })
                                        },
                                      )),
                                ],
                              )
                            ],
                          ),
                        
                      )),
                ),
            Expanded(
                flex: 2,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.only(left:16.0, right:16.0, top: 8, bottom:8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Color.fromARGB(255, 250, 243, 242),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: 18.0,
                        bottom: 18.0,
                        left: 18.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                              child: Text("About & Privacy Policy",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              alignment: Alignment.centerLeft),
                          Align(
                              child: Text("CareHomeApp v1.0"),
                              alignment: Alignment.centerLeft),
                        ],
                      )),
                ))
          ],
        ));
  }
}
