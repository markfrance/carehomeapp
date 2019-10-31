import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/logcheck/tasks_form.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/task_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
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

  userTasks.clear();
    
    QuerySnapshot snapshot = await Firestore.instance
    .collection('tasks')
    .where('patient', isEqualTo: widget.patient.id)
    .getDocuments();

    snapshot.documents.forEach((data) => {
      userTasks.add(
      new Task(
        data.documentID,
        data['patient'],
        data['task'],
        data['done']))
    });
      
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
      'task' : "Completed Task: " + task.task,
      'user': user.id,
    });

  }

    Widget _buildList(BuildContext context){

    return FutureBuilder<List<Task>>(
      future:getTasks(),
      builder:(context, snapshot)
      {
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, int)
          {
           return CheckboxListTile(
                title: new Text(snapshot.data[int].task),
                value: snapshot.data[int].done,
                onChanged: (bool value) {
                  setState(() {
                    setTask(userTasks[int],value);
                  });
                },
              );
          },);
      });
  }
  
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Tasks",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
          
            children: <Widget>[
               _buildList(context)
               ]
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

