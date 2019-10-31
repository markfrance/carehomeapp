import 'package:carehomeapp/patient/patient_view.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/patient/patients_card.dart';

class PatientEdit extends StatefulWidget {
 final Patient patient;
  PatientEdit(this.patient);

  @override
  PatientEditState createState() => PatientEditState();
}

class PatientEditState extends State<PatientEdit> {
  
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _medicalconditionController = TextEditingController();
  final _contactsController = TextEditingController();
  final _keynurseController = TextEditingController();
  final _contraindicationsController = TextEditingController();
  final _frustrateController = TextEditingController();
  final _loveController = TextEditingController();

  @override
  void initState() {
    if(widget.patient != null) {
    _firstNameController.text = widget.patient.firstname;
    _lastNameController.text = widget.patient.lastname;
    _ageController.text = widget.patient.age.toString();
    _likesController.text = widget.patient.likes;
    _contactsController.text = widget.patient.contacts;
    _contraindicationsController.text = widget.patient.contraindications;
    _dislikesController.text = widget.patient.dislikes;
    _frustrateController.text = widget.patient.frustrate;
    _keynurseController.text = widget.patient.keynurse;
    _loveController.text = widget.patient.love;
    _medicalconditionController.text = widget.patient.medicalcondition;
    }
    return super.initState();
  }

  void _updatePatientData(BuildContext context)
  {
    Firestore.instance.collection('patients').document(widget.patient.id).updateData(
      {
        
        'likes': _likesController.text,
        'dislikes' : _dislikesController.text,
        'medicalcondition': _medicalconditionController.text,
        'contacts': _contactsController.text,
        'keynurse': _keynurseController.text,
        'contraindications':_contraindicationsController.text,
        'frustrate': _frustrateController.text,
        'love': _loveController.text
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }

  void _addNewPatient(BuildContext context){
    Firestore.instance.collection('patients').document().setData(
      {
        'firstname': _firstNameController.text,
        'lastname' : _lastNameController.text,
        'age': _ageController.text,
        'likes': _likesController.text,
        'dislikes' : _dislikesController.text,
        'medicalcondition': _medicalconditionController.text,
        'contacts': _contactsController.text,
        'keynurse': _keynurseController.text,
        'contraindications':_contraindicationsController.text,
        'frustrate': _frustrateController.text,
        'love': _loveController.text
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }

  String followText = "Follow";

  void _follow() {
    setState(() {
      followText = "Following";
    });
  }

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
          title: Text('Edit Patient Data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                    top: 18.0,
                    bottom: 18.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                                "assets/images/avatar_placeholder_small.png",
                                width: 50,
                                height: 50),
                          )),
                      Column(
                      
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                     
                        
                          
                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child:RaisedButton(
                          color:Colors.black,
                        
                        padding: EdgeInsets.all(16.0),
                        child: Text("Save"),
                        onPressed: () {
                          if(widget.patient == null) {
                            _addNewPatient(context);
                          } else {
                          _updatePatientData(context);
                          }
                        },
                      ),),
                    ],
                  ),
                ))
              ],
            ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
      
                 
                ],
              ),
              Padding(
                padding:EdgeInsets.only(left:50, right:50),
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Likes"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _likesController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Dislikes", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _dislikesController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Medical Condition", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _medicalconditionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contacts", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _contactsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Key Nurse", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _keynurseController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contra Indications", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _contraindicationsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that frustrate", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _frustrateController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they love", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _loveController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              )],
          ),
        ));
  }
}
