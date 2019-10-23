import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/feeditem_model.dart';
import 'package:carehomeapp/feed_card.dart';

class FeedList extends StatefulWidget {
  final Patient patient;
  FeedList([this.patient]);
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  List<FeedItem> feedItems = new List<FeedItem>();
   String dropdownValue = 'Most recent';

  Future<List<FeedItem>> getItems() async {

    feedItems.clear();
    QuerySnapshot snapshot;
    
    if (widget.patient == null) {
      if(dropdownValue == 'Most recent' || dropdownValue == null){
        snapshot = await Firestore.instance.collection('feeditem')
        .orderBy('timeadded', descending: true)
        .getDocuments();
      }
      if(dropdownValue == 'Check Type'){
        snapshot = await Firestore.instance.collection('feeditem')
        .orderBy('type', descending: false)
        .getDocuments();
      }
      if(dropdownValue == 'Patients'){
        snapshot = await Firestore.instance.collection('feeditem')
        .orderBy('patientname', descending: false)
        .getDocuments();
      }
    } else {
      snapshot = await Firestore.instance
          .collection('feeditem')
          .where('patient', isEqualTo: widget.patient.id)
          .orderBy('timeadded', descending: true)
          .getDocuments();
    }

    snapshot.documents.forEach((data) => feedItems.add(new FeedItem(
        data['timeadded'].toDate(),
        data['type'],
        data['subtype'],
        data['user'],
        data['patientname'],
        data['mood'],
        data['systolic'],
        data['diastolic'],
        data['mmol'],
        data['bpm'],
        data['medication'],
        data['dose'],
        data['medicationtime'],
        data['hotcold'],
        data['l'],
        data['ml'],
        data['sugar'],
        data['mealtype'],
        data['gm'],
        data['mealdescription'],
        data['weight'],
        data['hygienetype'],
        data['otherhygiene'],
        data['toilettype'],
        data['status'],
        data['activity'],
        data['incident'],
        data['imageurl'])));

    return feedItems;
  }

 

  Widget _buildList(BuildContext context) {
    return FutureBuilder(
        future: getItems(),
        builder: (context, snapshot) {
        /*  if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }*/
          return ListView.builder(
              itemCount: feedItems.length,
              itemBuilder: (context, int) {
                return FeedCard(feedItems[int]);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Visibility(
        visible: widget.patient == null,
        child:Align(
        alignment: Alignment.topLeft,
        child: Theme(
          data: ThemeData(
            canvasColor: Color.fromARGB(255, 249, 210, 45),
            backgroundColor: Color.fromARGB(255, 250, 243, 242),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: DropdownButton<String>(
              hint: Text(dropdownValue),
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
              items: <String>['Most recent', 'Check Type', 'Patients']
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
      ),
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
