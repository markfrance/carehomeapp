import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/task_model.dart';
import 'package:carehomeapp/tasks_form.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TasksView extends StatefulWidget{

  final Patient patient;
  TasksView(this.patient);
  
  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {

List<Task> userTasks= new List<Task>();

Future<List<Task>> getTasks() async {
    
    QuerySnapshot snapshot = await Firestore.instance
    .collection('tasks')
    .where('patient', isEqualTo: widget.patient.id)
    .getDocuments();

    snapshot.documents.forEach((data) =>
      userTasks.add(
      new Task(
        data.documentID,
        data['patient'],
        data['task'],
        data['done'])));
                 
      return userTasks;
  }

  void setTask(Task task, bool status) {

    final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('tasks').document(task.id).updateData(
      {
        'lastupdated': DateTime.now(),
        'done' : status
      }
    );

     //Create feed item
     Firestore.instance.collection('feeditem').document().setData({
      'timeadded': DateTime.now(),
      'type': 'task',
      'subtype': 'task',
      'task' : "Completed Task" + task.task,
      'user': user.id,
    });


  }

    Map<String, bool> values = {
    'Clean room': true,
    'Change bedding': false,
  };
  
  @override
  Widget build(BuildContext context) {
    return Card(
       
        elevation: 4,
        margin:EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
      color: Color.fromARGB(255, 250, 243, 242),
      child: Padding(
        padding: EdgeInsets.all(18),
        child:Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tasks",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: values.keys.map((String key) {
              return CheckboxListTile(
                title: new Text(key),
                value: values[key],
                onChanged: (bool value) {
                  setState(() {
                    values[key] = value;
                   // setTask(userTasks[key], value);

                  });
                },
              );
            }).toList(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return TasksForm(widget.patient);
            }),
                child:Icon(CareHomeIcons.addb),
              ),
              
            ],
          ),
        ],
      ),
      ),
      );
    }
}

