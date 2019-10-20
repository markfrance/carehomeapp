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
    return Column(
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
      );
    }
}