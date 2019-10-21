import 'package:carehomeapp/chart_type_list.dart';
import 'package:carehomeapp/feed_list.dart';
import 'package:carehomeapp/medication_view.dart';
import 'package:carehomeapp/patient_view.dart';
import 'package:carehomeapp/patients_card.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/tasks_view.dart';


class PatientHome extends StatefulWidget {

   @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final Patient patient = new Patient("first", "patient", 65,"test");

 int _selectedIndex = 0;

  void _setIndex(index) {
      setState(() {
        _selectedIndex = index;
      });
    
  }

final widgetOptions = [FeedList(),MedicationView(),ChartTypeList(), TasksView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          title: Text('Patient'),
        ),
        body: Column(
          children:<Widget>[
            Column(children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(child:  PatientCard(patient),)
               
              ],),
      
        
      Row(children: <Widget>[
        Spacer(),
          RaisedButton(child: Text("Feed"),
          onPressed: () => _setIndex(0)),
           Spacer(),
          RaisedButton(child: Text("Medication"),
          onPressed: () => _setIndex(1)),
           Spacer(),
      ],),
       Row(children: <Widget>[
          Spacer(),
          RaisedButton(child: Text("Chart"),
          onPressed: () => _setIndex(2)),
           Spacer(),
          RaisedButton(child: Text("Tasks"),
          onPressed: () => _setIndex(3)),
           Spacer(),
      ],),],),
         RaisedButton(child: Icon(Icons.info),
            onPressed: () { Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientView()));
                        },),
                       
             Expanded(child: widgetOptions.elementAt(_selectedIndex))
          ]
        ),
    );
  }
}
