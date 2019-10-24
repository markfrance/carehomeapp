import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MealsForm extends StatefulWidget {
  final Patient patient;
  MealsForm(this.patient);
  
  @override
  MealsFormState createState() => MealsFormState();
}

class MealsFormState extends State<MealsForm> {

    final _weightController = TextEditingController();
    final _descriptionController = TextEditingController();
    String imageurl;
    String mealType;
  
   void _addMeal(BuildContext context)
  {
     final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('feeditem').document().setData(
      {
        'timeadded': DateTime.now(),
        'type': 'nutrition',
        'subtype': 'meals',
        'patient': widget.patient.id,
        'patientname': widget.patient.firstname + " " +widget.patient.lastname,
        'user' : user.id,
        'mealtype' : mealType,
        'gm': _weightController.text,
        'mealdescription': _descriptionController.text,
        'imageurl': imageurl
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }

   void setImage(String newimageurl) {
    setState((){
      imageurl = newimageurl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 186, 225, 189),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(setImage),
          Text(
            "Meal",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DropdownButton<String>(
                  hint: mealType == null ? Text( "Type") : Text(mealType),
              value: null,
              icon: Icon(CareHomeIcons.arrowdown),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                setState(() {
                  mealType = newValue;
                });
              },
              items: <String>['Breakfast', 'Lunch', 'Supper','Snack']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    color: Color.fromARGB(255, 250, 243, 242),
                    child: Text(value),
                  ),
                );
              }).toList(),
            ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _weightController,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("gm"),
                      flex: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Description",
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0), child: TextFormField(
                  controller:_descriptionController,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style:TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addMeal(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
