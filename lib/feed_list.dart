import 'package:flutter/material.dart';
import 'package:carehomeapp/feeditem_model.dart';
import 'package:carehomeapp/feed_card.dart';

class FeedList extends StatefulWidget {
  final List<FeedItem> initialFeeds = []
    ..add(FeedItem('first patient',CheckType.vitals,"THIS IS THE FEED CONTENT"))
    ..add(FeedItem('second patient',CheckType.body,"THIS IS THE FEED CONTENT"))
    ..add(FeedItem('third patient',CheckType.other,"THIS IS THE FEED CONTENT"))
    ..add(FeedItem('fourth patient',CheckType.medication,"THIS IS THE FEED CONTENT"))
    ..add(FeedItem('fifth patient',CheckType.mood,"THIS IS THE FEED CONTENT"))
    ..add(FeedItem('sixth patient',CheckType.nutrition,"THIS IS THE FEED CONTENT"));


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
          child:DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
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
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
