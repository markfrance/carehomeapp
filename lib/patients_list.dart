import 'package:carehomeapp/user_binding.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patients_card.dart';

class PatientsList extends StatefulWidget {
  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  String dropdownValue = 'Most recent';

  Widget _buildList(BuildContext context) {
    final user = UserBinding.of(context).user;

    return FutureBuilder<List<Patient>>(
        future: user.getPatients(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int) {
              return PatientCard(snapshot.data[int]);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
