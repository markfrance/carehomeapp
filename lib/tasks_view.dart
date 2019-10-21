import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/tasks_form.dart';
import 'package:flutter/material.dart';


class TasksView extends StatefulWidget{

  @override
  _TasksViewState createState() => _TasksViewState();
}


class _TasksViewState extends State<TasksView> {

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
          FormHeader(),
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
              return TasksForm();
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