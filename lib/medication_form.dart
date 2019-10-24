import 'package:carehomeapp/add_medication_form.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/medication_model.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:flutter/material.dart';

class MedicationForm extends StatefulWidget {
  final Patient patient;
  final bool showHeader;
  MedicationForm(this.patient, this.showHeader);

  @override
  MedicationState createState() => new MedicationState();
}

class MedicationState extends State<MedicationForm> {
  Map<Medication, bool> values = {
    Medication("1","Vitamins", "4", DateTime.now()) : false,
    Medication("2","Paracetamol", "2", DateTime.now()) : false,
  };

String imageurl;

 void setImage(String newimageurl) {
    setState((){
      imageurl = newimageurl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 109, 191, 218),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: widget.showHeader == true,
            child:FormHeader(setImage)),
          Text(
            "Medication",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: values.keys.map((Medication key) {
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child:CheckboxListTile(
                activeColor: Colors.black,
                checkColor: Colors.white,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:<Widget>[
                  
                  Align(
                  alignment: Alignment.centerLeft,
                  child:Text(key.time.hour.toString() + ":" + key.time.minute.toString(), 
                  style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text(key.dose + " " + key.medication),)
                ]),
                value: values[key],
                onChanged: (bool value) {
                  setState(() {
                    values[key] = value;
                  });
                },)
              );
            }).toList(),
          ),
          Column(
           
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child:SizedBox(
                width:30,
                height:30,
                child:RaisedButton(
                padding:EdgeInsets.all(0),
                color:Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddMedicationForm(widget.patient);
            },
                ),
                child:Icon(CareHomeIcons.addb,),
              ),),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style:TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
