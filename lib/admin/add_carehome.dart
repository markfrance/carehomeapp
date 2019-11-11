import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCarehome extends StatefulWidget {
  @override
  AddCarehomeState createState() => AddCarehomeState();
}

class AddCarehomeState extends State<AddCarehome> {
  final _nameController = TextEditingController();

  void _addNewCarehome(BuildContext context) {
    Firestore.instance.collection('carehome').document().setData(
        {'name': _nameController.text}).then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 250, 243, 242),
              title: Text('Add New Carehome'),
            ),
            body: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment:Alignment.centerLeft,
                    child:Padding(
                    padding:EdgeInsets.all(8),
                    child:Text("Carehome Name:",style: TextStyle(fontWeight: FontWeight.bold)),),),
                  Padding(
                    padding:EdgeInsets.all(8),
                    child:TextFormField(
                    controller: _nameController,
                  ),),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.black,
                      padding: EdgeInsets.all(16.0),
                      child: Text("Save"),
                      onPressed: () {
                        _addNewCarehome(context);
                      },
                    ),
                  ),
                ])));
  }
}
