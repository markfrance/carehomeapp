import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/logcheck/tasks_form.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/task_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  final Patient patient;
  final User user;
  TasksView(this.patient, this.user);

  @override
  _TasksViewState createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  List<Task> userTasks = new List<Task>();

  Future<List<Task>> getTasks() async {
    userTasks.clear();

    QuerySnapshot snapshot = await Firestore.instance
        .collection('tasks')
        .where('patient', isEqualTo: widget.patient.id)
        .getDocuments();

    snapshot.documents.forEach((data) => {
          userTasks.add(new Task(
              data.documentID, data['patient'], data['task'], data['done']))
        });

    return userTasks;
  }

  void setTask(Task task, bool status) {


    Firestore.instance
        .collection('tasks')
        .document(task.id)
        .updateData({'lastupdated': DateTime.now(), 'done': status});
    if (status == true) {
      //Create feed item
      Firestore.instance.collection('feeditem').document().setData({
        'timeadded': DateTime.now(),
        'type': 'task',
        'patientname': widget.patient.firstname + " " + widget.patient.lastname,
        'patient': widget.patient.id,
        'subtype': 'task',
        'task': task.task,
        'logdescription': "Completed Task: " + task.task,
        'user': widget.user.id,
        'username' : widget.user.firstName + " " + widget.user.lastName,
      });
    }
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder<List<Task>>(
        future: getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return SingleChildScrollView(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, int) {
              return CheckboxListTile(
                activeColor: Colors.black,
                checkColor: Colors.white,
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(snapshot.data[int].task ?? "",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                value: snapshot.data[int].done,
                onChanged: (bool value) {
                  setState(() {
                    setTask(userTasks[int], value);
                  });
                },
              );
            },
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color.fromARGB(255, 250, 243, 242),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Tasks",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[_buildList(context)]),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return TasksForm(widget.patient, widget.user);
                      }),
                  child: Icon(CareHomeIcons.addb),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
