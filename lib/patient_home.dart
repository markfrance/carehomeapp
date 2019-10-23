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

  PatientHome(this.patient);
  final Patient patient;
   @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
 

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
                  Expanded(child:  PatientCard(widget.patient),)
               
              ],),
      
        
      Row(children: <Widget>[
        Spacer(),
          Expanded(
            flex:3,
            child:RaisedButton(child: Text("Feed"),
          
          onPressed: () => _setIndex(0)),),
           Spacer(),
          Expanded(
            flex:3,
            child:RaisedButton(child: Text("Medication"),
          onPressed: () => _setIndex(1)),
          ),
           Spacer(),
      ],),
       Row(children: <Widget>[
          Spacer(),
          Expanded(
            flex:3,
            child:RaisedButton(child: Text("Chart"),
          onPressed: () => _setIndex(2)),
          ),
           Spacer(),
          Expanded(
            flex:3,
            child:RaisedButton(child: Text("Tasks"),
          onPressed: () => _setIndex(3)),
          ),
           Spacer(),
      ],),],),
         RaisedButton(child: Icon(Icons.info),
            onPressed: () { Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientView(widget.patient)));
                        },),
                       
             Expanded(child: widgetOptions.elementAt(_selectedIndex))
          ]
        ),
    );
  }
}
