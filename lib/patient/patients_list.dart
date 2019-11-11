import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/patient/patient_edit.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/patient/patients_card.dart';


class PatientsList extends StatefulWidget {
  PatientsList(this.user);
  final User user;
  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  String dropdownValue = 'Most recent';

  Widget _buildList(BuildContext context) {


    return FutureBuilder<List<Patient>>(
        future: widget.user.getPatients(dropdownValue),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int) {
              return PatientCard(snapshot.data[int], widget.user);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return Column(children: <Widget>[
      Row(children: <Widget>[
          Padding(
            child:Text("Patients", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            padding:EdgeInsets.all(16)),
          SizedBox(
                width:30,
                height:30,
                child: Visibility(
                    visible: widget.user.isSuperAdmin == true || widget.user.isManager == true,
                    child:RaisedButton(
                padding:EdgeInsets.all(0),
                color:Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return PatientEdit(null, widget.user);
            },
                ),
                child:Icon(CareHomeIcons.addb,),
              ),),)

        ],
        ),
      Row(children: <Widget>[
        
        Expanded(
            flex: 2,
            child: Align(
                alignment: Alignment.topLeft,
                child: Theme(
                  data: ThemeData(
                    canvasColor: Color.fromARGB(255, 249, 210, 45),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, top: 16, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 249, 210, 45),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        hint:Text(dropdownValue),
                      //  icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, backgroundColor: Color.fromARGB(255, 249, 210, 45)),
                         underline: null,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'Most recent',
                          'Following',
                          'Alphabetically'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              color: Color.fromARGB(255, 249, 210, 45),
                              child: Padding(padding:EdgeInsets.only(left: 8), child:Text(value)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )))
      ]),
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
