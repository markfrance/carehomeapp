import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/feeditem_model.dart';
import 'package:carehomeapp/feed/feed_card.dart';

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
      if (dropdownValue == 'Most recent' || dropdownValue == null) {
        snapshot = await Firestore.instance
            .collection('feeditem')
            .orderBy('timeadded', descending: true)
            .getDocuments();
      }
      if (dropdownValue == 'Check Type') {
        snapshot = await Firestore.instance
            .collection('feeditem')
            .orderBy('type', descending: false)
            .getDocuments();
      }
      if (dropdownValue == 'Patients') {
        snapshot = await Firestore.instance
            .collection('feeditem')
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
      data.documentID,
        data['timeadded'].toDate(),
        data['type'],
        data['subtype'],
        data['user'],
        data['username'],
        data['patientimage'],
        data['patientname'],
        data['mood'],
        data['systolic'],
        data['diastolic'],
        data['level'],
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
        data['task'],
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
      Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Visibility(
              visible: widget.patient == null,
              child: Align(
                alignment: Alignment.topLeft,
                child: Theme(
                  data: ThemeData(
                    canvasColor: Color.fromARGB(255, 249, 210, 45),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, top: 16, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 249, 210, 45),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(dropdownValue),
                        value: dropdownValue,
                        //icon: Padding(child:Icon(CareHomeIcons.arrowdown, size:10), padding:EdgeInsets.all(8)),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Colors.black,
                            backgroundColor: Color.fromARGB(255, 249, 210, 45)),
                        underline: null,
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
                              color: Color.fromARGB(255, 249, 210, 45),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(value)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(
            flex: 2,
          )
        ],
      ),
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
