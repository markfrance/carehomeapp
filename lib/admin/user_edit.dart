import 'dart:io';

import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String carehome;

  @override
  void initState() {
    if (widget.user != null) {
      _firstNameController.text = widget.user.firstName;
      _lastNameController.text = widget.user.lastName;
      _emailController.text = widget.user.email;
      carehome = widget.user.carehome;
     
    }
    return super.initState();
  }

  void _updateUser(BuildContext context) {
    Firestore.instance
        .collection('users')
        .document(widget.user.id)
        .updateData({
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text,
      'email': _emailController.text,
      'carehome': carehome,
    }).then((onValue) => Navigator.pop(context));
  }

  void _addNewUser(BuildContext context) {
    Firestore.instance.collection('users').document().setData({
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text,
       'email': _emailController.text,
      'carehome': carehome,
    }).then((onValue) => Navigator.pop(context));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
          title: Text('Edit User Data'),
        ),
        body:  Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                      top: 18.0,
                      bottom: 18.0,
                      right: 18.0,
                      left:18.0
                    ),
                    child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 150,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'First Name'),
                                controller: _firstNameController,
                              ),
                            ),
                            Container(
                              width: 150,
                              child: TextFormField(
                                 decoration: InputDecoration(
                                    hintText: 'Last Name'),
                                controller: _lastNameController,
                              ),
                            ),
                            Container(
                              width: 150,
                              child: TextFormField(
                                 decoration: InputDecoration(
                                    hintText: 'Email'),
                                controller: _emailController,
                              ),
                            ),
                            Text("Carehome", style:TextStyle(fontWeight: FontWeight.bold)),
                            Text("Roles", style:TextStyle(fontWeight: FontWeight.bold)),
                            CheckboxListTile(onChanged: null,
                            title: Text("Manager"),
                            value: widget.user.isManager ?? false),
                            CheckboxListTile(onChanged: null,
                            title: Text("Super Admin"),
                            value: widget.user.isSuperAdmin ?? false),
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
