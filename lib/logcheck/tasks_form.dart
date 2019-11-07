import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TasksForm extends StatefulWidget {
    final Patient patient;
  TasksForm(this.patient);
  
  @override
  TasksFormState createState() => TasksFormState();

}

class TasksFormState extends State<TasksForm> {

  final _taskController = TextEditingController();

  void _addTask(BuildContext context)
  {
    final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('tasks').document().setData(
      {
        'lastupdated': DateTime.now(),
        'patient': widget.patient.id,
        'patientimage': widget.patient.imageUrl,
        'patientname': widget.patient.firstname + " " +widget.patient.lastname,
        'user' : user.id,
        'task': _taskController.text,
        'done' : false,
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }
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
          Text(
            "Tasks",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _taskController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style:TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addTask(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
