
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/patient/patient_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;

  CommentCard(this.comment);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {


 String formatTime(DateTime time) {
    return time.year.toString() +
        "/" +
        time.month.toString().padLeft(2,'0') +
        "/" +
        time.day.toString().padLeft(2,'0') +
        " " +
        time.hour.toString().padLeft(2,'0') +
        ":" +
        time.minute.toString().padLeft(2,'0');
  }

  @override
  Widget build(BuildContext context) {


    return  Card(
            elevation: 4,
            margin: EdgeInsets.only(left:16.0, right:16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color.fromARGB(255, 250, 243, 242),
          
            child: Padding(
              padding: const EdgeInsets.only(
                top: 18.0,
                bottom: 18.0,
              ),
              child: 
                  Padding(
                    padding:EdgeInsets.only(left:16, right:16),
                    child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.comment.username,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatTime(widget.comment.time),),
                      Text(widget.comment.text,
                          style: Theme.of(context).textTheme.subhead),
                    ],
                  ),),
            ));
  }
}
