import 'package:flutter/material.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/feeditem_model.dart';

class FeedCard extends StatefulWidget {
  final FeedItem feedItem;

  FeedCard(this.feedItem);

  @override
  _FeedCardState createState() => _FeedCardState(feedItem);
}

class _FeedCardState extends State<FeedCard> {
   FeedItem patient;

   _FeedCardState(this.patient);

  IconData getIcon(CheckType type) {
    switch (type) {
      case CheckType.body : 
        return CareHomeIcons.body;
      case CheckType.medication :
        return CareHomeIcons.medsicon;
      case CheckType.mood:
        return CareHomeIcons.moodicon;
      case CheckType.nutrition:
        return CareHomeIcons.nutrition;
      case CheckType.other:
        return CareHomeIcons.other;
      case CheckType.vitals:
        return CareHomeIcons.vitalsicon;
      default: 
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.white,
      child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(

        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 64.0,
        ),
            child:Row(children: <Widget>[
              Column(children: <Widget>[Text(widget.feedItem.name,
                style: Theme.of(context).textTheme.subhead),
            Text("16/10/19 00:43"),]
              ),
              Spacer(),
            Icon(getIcon(widget.feedItem.type)),
            ]),),
            Text(widget.feedItem.body,
                style: Theme.of(context).textTheme.subhead),
            Row(children: <Widget>[
              Icon(CareHomeIcons.likeinactive),
              Icon(CareHomeIcons.comment)
            ],)
            
          ],
        ),
      
    );
  }
}