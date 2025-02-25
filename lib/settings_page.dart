import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(this.user);
  final User user;
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool likes = false;
  bool comments = false;
  bool medication = false;
  bool patientpost = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Firestore.instance
        .collection('users')
        .document(widget.user.id)
        .get()
        .then((data) => {
              setState(() {
                likes = data['notificationlikes'];
                comments = data['notificationcomments'];
                medication = data['notificationmedication'];
                patientpost = data['notificationpatient'];
              })
            });
  }

  void setSwitch(User user, String type, bool isOn) {
    setState(() {
      Firestore.instance
          .collection('users')
          .document(user.id)
          .updateData({type: isOn});
    });
  }

    _launchPolicy() async {
  const url = 'https://www.iubenda.com/privacy-policy/50588106';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
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
                margin:
                    EdgeInsets.only(left: 16.0, right: 16, top: 0, bottom: 8),
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
                              child: Text(widget.user.email),
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
                  margin:
                      EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
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
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            alignment: Alignment.centerLeft),
                        Row(
                          children: <Widget>[
                            Expanded(child: Text("Patient post"), flex: 4),
                            Expanded(
                                flex: 1,
                                child: Switch(
                                  activeColor: Color.fromARGB(255, 35, 33, 26),
                                  value: patientpost,
                                  onChanged: (value) => {
                                    setSwitch(
                                        widget.user, 'notificationpatient', value)
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
                                  activeColor: Color.fromARGB(255, 35, 33, 26),
                                  value: likes,
                                  onChanged: (value) => {
                                    setSwitch(widget.user, 'notificationlikes', value)
                                  },
                                )),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(child: Text("Comments"), flex: 4),
                            Expanded(
                                flex: 1,
                                child: Switch(
                                  activeColor: Color.fromARGB(255, 35, 33, 26),
                                  value: comments,
                                  onChanged: (value) => {
                                    setSwitch(
                                        widget.user, 'notificationcomments', value)
                                  },
                                )),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text("Medication reminder"), flex: 4),
                            Expanded(
                                flex: 1,
                                child: Switch(
                                  activeColor: Color.fromARGB(255, 35, 33, 26),
                                  value: medication,
                                  onChanged: (value) => {
                                    setSwitch(
                                        widget.user, 'notificationmedication', value)
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
                  margin: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8, bottom: 8),
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
                              child: FlatButton(
                                padding:EdgeInsets.all(0),
                                child: Text("Privacy and Cookie Policy", textAlign: TextAlign.left, style:TextStyle(color:Colors.blue)), 
        onPressed: _launchPolicy,),
                              alignment: Alignment.centerLeft),
                        ],
                      )),
                ))
          ],
        ));
  }
}
