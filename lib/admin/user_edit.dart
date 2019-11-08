import 'dart:io';

import 'package:carehomeapp/authentication.dart';
import 'package:carehomeapp/model/carehome_model.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class UserEdit extends StatefulWidget {
  final User user;
  UserEdit(this.user);

  @override
  UserEditState createState() => UserEditState();
}

class UserEditState extends State<UserEdit> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String carehome;
  Carehome dropdownValue;

  @override
  void initState() {
    if (widget.user != null) {
      _firstNameController.text = widget.user.firstName;
      _lastNameController.text = widget.user.lastName;
      _emailController.text = widget.user.email;
      dropdownValue = widget.user.carehome;
    }
    return super.initState();
  }

  void _updateUser(BuildContext context) {
    Firestore.instance.collection('users').document(widget.user.id).updateData({
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text,
      'email': _emailController.text,
      'carehome': dropdownValue.id,
      'carehomename': dropdownValue.name
    }).then((onValue) => Navigator.pop(context));
  }

  void _addNewUser(BuildContext context) {
    //Auth auth = new Auth();
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((result) => {
              result.user.sendEmailVerification(),
              Firestore.instance.collection('users').document(result.user.uid).setData({
                'firstname': _firstNameController.text,
                'lastname': _lastNameController.text,
                'email': _emailController.text,
                'carehome': dropdownValue.id,
                'carehomename': dropdownValue.name,
                'notificationlikes' : true,
                'notificationcomments': true,
                'notificationmedication': true,
                'notificationpatient':true,
                'following': []
              }).then((onValue) => Navigator.pop(context))
            });
  }

  Future<List<Carehome>> getCarehomes() async {
    List<Carehome> carehomes = new List<Carehome>();

    QuerySnapshot snapshot =
        await Firestore.instance.collection('carehome').getDocuments();

    snapshot.documents.forEach(
        (data) => carehomes.add(Carehome(data.documentID, data['name'])));
    return carehomes;
  }

  void setPermission(String permission, bool isOn) {
    setState(() {
      Firestore.instance
          .collection('users')
          .document(widget.user.id)
          .updateData({permission: isOn});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
        title: Text('Edit User Data'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(
                    top: 18.0, bottom: 18.0, right: 18.0, left: 18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Carehome",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: FutureBuilder<List<Carehome>>(
                            future: getCarehomes(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Carehome>> snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              return DropdownButton<Carehome>(
                                  hint: dropdownValue == null
                                      ? Padding(
                                          child: Text("Carehomes"),
                                          padding: EdgeInsets.only(left: 8))
                                      : Padding(
                                          child:
                                              Text(dropdownValue?.name ?? ""),
                                          padding: EdgeInsets.only(left: 8)),
                                  isExpanded: true,
                                  value: null,
                                  items: snapshot.data
                                      .map((carehome) =>
                                          DropdownMenuItem<Carehome>(
                                            child: Container(
                                              child: Text(carehome.name ?? ""),
                                              color: Color.fromARGB(
                                                  255, 249, 210, 45),
                                            ),
                                            value: carehome,
                                          ))
                                      .toList(),
                                  onChanged: (Carehome newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                      carehome = newValue.id;
                                      print(newValue);
                                    });
                                  });
                            })),
                             Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("User information",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: 375,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'First Name'),
                        controller: _firstNameController,
                      ),
                    ),
                    Container(
                      width: 375,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'Last Name'),
                        controller: _lastNameController,
                      ),
                    ),
                    Container(
                      width: 375,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'Email'),
                        controller: _emailController,
                      ),
                    ),
                    Visibility(
                      visible: widget.user == null,
                      child:Container(
                      width: 375,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'Password'),
                        controller: _passwordController,
                      ),
                    ),),
                    
                    Padding(
                      padding: EdgeInsets.all(8),
                      child:Text("Roles",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    CheckboxListTile(
                        onChanged: (newValue) =>
                            setPermission('ismanager', newValue),
                        title: Text("Manager"),
                        value: widget.user?.isManager ?? false),
                    CheckboxListTile(
                        onChanged: (newValue) =>
                            setPermission('issuperadmin', newValue),
                        title: Text("Super Admin"),
                        value: widget.user?.isSuperAdmin ?? false),
                    Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        color: Colors.black,
                        padding: EdgeInsets.all(16.0),
                        child: Text("Save"),
                        onPressed: () {
                          if (widget.user == null) {
                            _addNewUser(context);
                          } else {
                            _updateUser(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
