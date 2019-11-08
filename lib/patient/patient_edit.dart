import 'dart:io';

import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  String imageUrl;

  @override
  void initState() {
    if (widget.patient != null) {
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

  void _pickPhoto(String imageId) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(imageId)
        .child(imageFile.uri.toString());
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    await (await uploadTask.onComplete)
        .ref
        .getDownloadURL()
        .then((url) => setState(() => imageUrl = url));
  }

  void _updatePatientData(BuildContext context) {
    Firestore.instance
        .collection('patients')
        .document(widget.patient.id)
        .updateData({
      'likes': _likesController.text,
      'dislikes': _dislikesController.text,
      'medicalcondition': _medicalconditionController.text,
      'contacts': _contactsController.text,
      'keynurse': _keynurseController.text,
      'contraindications': _contraindicationsController.text,
      'frustrate': _frustrateController.text,
      'love': _loveController.text,
      'imageurl': imageUrl
    }).then((onValue) => Navigator.pop(context));
  }

  void _addNewPatient(BuildContext context) {
     final user = UserBinding.of(context).user;
    Firestore.instance.collection('patients').document().setData({
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
      'likes': _likesController.text,
      'dislikes': _dislikesController.text,
      'medicalcondition': _medicalconditionController.text,
      'contacts': _contactsController.text,
      'keynurse': _keynurseController.text,
      'contraindications': _contraindicationsController.text,
      'frustrate': _frustrateController.text,
      'love': _loveController.text,
      'carehome': user.carehome.id,
      'carehomename': user.carehome.name,
      'imageurl': imageUrl
    }).then((onValue) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
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
                          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: FlatButton(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                  imageUrl: widget.patient?.imageUrl ??
                                      "assets/images/avatar_placeholder_small.png",
                                  placeholder: (context, url) => Image.asset(
                                      "assets/images/avatar_placeholder_small.png",
                                      width: 50,
                                      height: 50),
                                  width: 50,
                                  height: 50),
                            ),
                            onPressed: () => _pickPhoto(widget.patient.id),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 150,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'First Name'),
                                controller: _firstNameController,
                              ),
                            ),
                            Container(
                              width: 150,
                              child: TextFormField(
                                 decoration: InputDecoration(
                                    hintText: 'Last Name'),
                                controller: _lastNameController,
                              ),
                            ),
                            Container(
                              width: 50,
                              child: TextFormField(
                                 decoration: InputDecoration(
                                    hintText: 'Age'),
                                controller: _ageController,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            color: Colors.black,
                            padding: EdgeInsets.all(16.0),
                            child: Text("Save"),
                            onPressed: () {
                              if (widget.patient == null) {
                                _addNewPatient(context);
                              } else {
                                _updatePatientData(context);
                              }
                            },
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ))
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[],
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Column(
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
                      child: Text(
                        "Dislikes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      child: Text(
                        "Medical Condition",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      child: Text(
                        "Contacts",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      child: Text(
                        "Key Nurse",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      child: Text(
                        "Contra Indications",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      child: Text(
                        "Things that frustrate",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      child: Text(
                        "Things that they love",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
              )
            ],
          ),
        ));
  }
}
