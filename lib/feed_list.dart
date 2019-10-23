import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/feeditem_model.dart';
import 'package:carehomeapp/feed_card.dart';

class FeedList extends StatefulWidget {
  final List<FeedItem> initialFeeds = []
    ..add(FeedItem('first patient',CheckType.vitals,"Blood Pressure: 7.8 mmol"))
    ..add(FeedItem('second patient',CheckType.body,"Weight: 80kg"))
    ..add(FeedItem('third patient',CheckType.other,"Incident: Fell down stairs"))
    ..add(FeedItem('fourth patient',CheckType.medication,"Medication: 08:40 - 2 Vitamins"))
    ..add(FeedItem('fifth patient',CheckType.mood,"Mood: Angry"))
    ..add(FeedItem('sixth patient',CheckType.nutrition,"Breakfast: Egg and Bacon"));


  @override
  _FeedListState createState() => _FeedListState(initialFeeds);
}

class _FeedListState extends State<FeedList> {
  final List<FeedItem> feeditems;
  _FeedListState(this.feeditems);
  String dropdownValue = 'Most recent';

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: feeditems.length,
      itemBuilder: (context, int) {
        return FeedCard(feeditems[int]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Align(
        alignment: Alignment.topLeft,
        child: Theme(
          data: ThemeData(
            canvasColor: Color.fromARGB(255,249, 210, 45),
            backgroundColor:Color.fromARGB(255,250, 243, 242),
             ),
          child:Padding(
            padding: EdgeInsets.only(
              left: 16
            ),
            child:DropdownButton<String>(
          value: dropdownValue,
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
              dropdownValue = newValue;
            });
          },
          items: <String>['Most recent', 'Following', 'Alphabetically']
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
          ),
        ),
      ),
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
