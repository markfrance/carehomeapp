import 'package:carehomeapp/logcheck/enter_comment.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/feeditem_model.dart';

class FeedCard extends StatefulWidget {
  final FeedItem feedItem;

  FeedCard(this.feedItem);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  
  IconData getIcon(String type) {
    switch (type) {
      case "body":
        return CareHomeIcons.body;
      case "medication":
        return CareHomeIcons.medsicon;
      case "mood":
        return CareHomeIcons.moodicon;
      case "nutrition":
        return CareHomeIcons.nutrition;
      case "other":
        return CareHomeIcons.other;
      case "vitals":
        return CareHomeIcons.vitalsicon;
      case "task":
      return Icons.check_circle_outline;
      default:
        return null;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case "body":
        return Color.fromARGB(255, 244, 174, 124);
      case "medication":
        return Color.fromARGB(255, 109, 191, 218);
      case "mood":
        return Color.fromARGB(255, 222, 164, 209);
      case "nutrition":
        return Color.fromARGB(255, 186, 225, 189);
      case "other":
        return Color.fromARGB(255, 204, 241, 255);
      case "vitals":
        return Color.fromARGB(255, 251, 148, 148);
      default:
        return Colors.white;
    }
  }

  String getDescription(String type) {
    FeedItem feedItem = widget.feedItem;
    switch (type) {
      case "mood":
        return "Mood: " + feedItem.mood;
      case "bloodpressure":
        return "Blood pressure reading: " +
            feedItem.systolic +
            "/" +
            feedItem.diastolic;
      case "bloodsugarlevel":
        return "Blood sugar level: " + feedItem.mmol + " mmo/l";
      case "heartrate":
        return "Heart rate: " + feedItem.bpm + "bpm";
      case "medication":
        return "Took " +
            feedItem.dose +
            " " +
            feedItem.medication +
            " at " +
            feedItem.medicationtime;
      case "hydration":
        return "Drank " +
            feedItem.l +
            "L " +
            feedItem.hotcold +
            " drink. " +
            feedItem.sugar;
      case "meals":
        return "Ate " +
            feedItem.gm +
            "g meal for " +
            feedItem.mealtype +
            ". " +
            feedItem.description;
      case "weight":
        return "Weight reading: " + feedItem.weight + "kg";
      case "hygiene":
        return "Hygiene: " + feedItem.hygienetype + ". " + feedItem.otherhygiene;
      case "toilet":
        return "Went to toilet for " +
            feedItem.toilettype +
            ". " +
            feedItem.status;
      case "activity":
        return "New activity:" + feedItem.activity;
      case "incident":
        return "New incident: " + feedItem.incident;
      case "task":
        return feedItem.task;
      default:
        return "description error";
    }
  }

  bool isLiked = false;
  void _toggleLikeIcon() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  IconData _getLikeIcon() {
    if (isLiked == true) {
      return CareHomeIcons.likeactive;
    } else {
      return CareHomeIcons.likeinactive;
    }
  }

  String formatTime(DateTime time) {
    return time.year.toString() +
        "/" +
        time.month.toString() +
        "/" +
        time.day.toString() +
        " " +
        time.hour.toString() +
        ":" +
        time.minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: EdgeInsets.only(left: 25, right: 25, top: 16.0, bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: getColor(widget.feedItem.type),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 18.0,
                  bottom: 18.0,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child:Image.asset(
                                      "assets/images/avatar_placeholder_small.png",
                                      width: 50,
                                      height: 50) ,)
                          
                          ),
                      Column(children: <Widget>[
                        Text(
                          widget.feedItem.patientname ?? " ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(formatTime(widget.feedItem.timeAdded)),
                      ]),
                      Spacer(flex: 5),
                      Expanded(
                        flex: 3,
                        child: Padding(
                            child: Icon(getIcon(widget.feedItem.type)),
                            padding: EdgeInsets.all(8)),
                      ),
                    ]),
              ),
              Padding(
                  child: Text(getDescription(widget.feedItem.subType) ?? " ",
                      style: Theme.of(context).textTheme.subhead),
                  padding: EdgeInsets.all(8)),
              Visibility(
                visible: widget.feedItem.imageUrl != null,
                child:Padding(
                  child: Image.asset(
                    widget.feedItem.imageUrl ?? "",
                    fit: BoxFit.fitWidth,
                  ),
                  padding: EdgeInsets.all(8)),
              ),
              Row(
                children: <Widget>[
                  Spacer(flex: 7),
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      child: Icon(
                        _getLikeIcon(),
                        color: Colors.black,
                      ),
                      onPressed: () => _toggleLikeIcon(),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: FlatButton(
                              child: Icon(CareHomeIcons.comment,
                                  color: Colors.black),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EnterComment();
                                  })))),
                ],
              )
            ],
          ),
        ));
  }
}