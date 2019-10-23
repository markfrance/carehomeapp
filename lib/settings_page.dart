import 'package:carehomeapp/user_binding.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = UserBinding.of(context).user;

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body:Column(children: <Widget>[
      Expanded(child:Card(
        elevation: 4,
         margin:EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
      color: Color.fromARGB(255, 250, 243, 242),
        child:Padding(
          
        padding: const EdgeInsets.only(
          top: 18.0,
          bottom: 18.0,
          left: 64.0,
        ),

        child:Column(
          children: <Widget>[
           Text("Email"),
           Text(user.email),
           Text("Password"),
           Text("*********")

          ],
      ),
        ),
      ),
      ),
    ],)
    );
  }
}