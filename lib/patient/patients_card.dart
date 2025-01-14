import 'package:cached_network_image/cached_network_image.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/patient/patient_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;
  final User user;

  PatientCard(this.patient, this.user);

  @override
  _PatientCardState createState() => _PatientCardState(patient);
}

class _PatientCardState extends State<PatientCard> {
  Patient patient;
  String followText;
  _PatientCardState(this.patient);

  void _setFollowText(user) {
    Firestore.instance.collection('users').document(user.id).get().then((doc) =>
        List.from(doc['following']).contains(widget.patient.id)
            ? setState(() => followText = "Following")
            : setState(() => followText = "Follow"));
  }

  void _followToggle(user) {
    Firestore.instance
        .collection('users')
        .document(user.id)
        .get()
        .then((doc) => {
              List.from(doc['following']).contains(widget.patient.id)
                  ? {
                      Firestore.instance
                          .collection('users')
                          .document(user.id)
                          .updateData({
                        'following': FieldValue.arrayRemove([widget.patient.id])
                      }),
                      setState(() => followText = "Follow")
                    }
                  : {
                      Firestore.instance
                          .collection('users')
                          .document(user.id)
                          .updateData({
                        'following': FieldValue.arrayUnion([widget.patient.id])
                      }),
                      setState(() => followText = "Following")
                    }
            });
  }

  @override
  Widget build(BuildContext context) {
 
    if (followText == null) {
      _setFollowText(widget.user);
    }

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientHome(this.patient, followText, widget.user)),
          );
        },
        child: Card(
            elevation: 4,
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color.fromARGB(255, 250, 243, 242),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 18.0,
                bottom: 18.0,
                left:18.0,
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:CachedNetworkImage(
                                  imageUrl: widget.patient.imageUrl ?? "https://firebasestorage.googleapis.com/v0/b/carehomeapp-a2936.appspot.com/o/avatar_placeholder_small.png?alt=media&token=32adc9ac-03ad-45ed-bd4c-27ecc4f80a55",
                                  placeholder: (context, url) => Image.asset("assets/images/avatar_placeholder_small.png",width:50,height:50),
                                  width: 50,
                                  height: 50),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.patient.firstname,
                          style: Theme.of(context).textTheme.subhead),
                      Text(widget.patient.lastname,
                          style: Theme.of(context).textTheme.subhead),
                      Text(widget.patient.age.toString(),
                          style: Theme.of(context).textTheme.subhead),
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: RaisedButton(
                        padding:EdgeInsets.all(0),
                          color: Colors.black,
                          child: Text(followText ?? "",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () => {_followToggle(widget.user)}),
                    ),
                  )),
                ],
              ),
            )));
  }
}
