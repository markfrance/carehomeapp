import 'dart:io';

import 'package:carehomeapp/admin/pdf_report.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:csv/csv.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';


class PatientReport extends StatefulWidget {
  PatientReport(this.patient, this.user);

  final Patient patient;
  final User user;
  @override
  _PatientReportState createState() => _PatientReportState();
}

class _PatientReportState extends State<PatientReport> {
  List<List<String>> rows = new List<List<String>>();
  GlobalKey scaffoldKey = GlobalKey();

  String _fromDateString = "";
  String _toDateString = "";
  DateTime _fromDate;
  DateTime _toDate;
  bool update;

  @override
  void initState() {
    super.initState();
  
    initDates();
  }

  void initDates() {
    var now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    _toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _fromDateString =
        '${_fromDate.year} / ${_fromDate.month.toString().padLeft(2, '0')} / ${_fromDate.day.toString().padLeft(2, '0')}';
    _toDateString =
        '${_toDate.year} / ${_toDate.month.toString().padLeft(2, '0')} / ${_toDate.day.toString().padLeft(2, '0')}';
  }

  Future<String> getComments(String feedId) async {
    List<String> comments = new List<String>();

    QuerySnapshot commentDocs = await Firestore.instance
        .collection('feeditem')
        .document(feedId)
        .collection('comments')
        .getDocuments();

    commentDocs.documents
        .forEach((comment) => comments.add(comment.data['text']));

    return comments.join(", ");
  }

  Future<List<List<String>>> getRows() async {

    List<List<String>> newRows = List<List<String>>();

    QuerySnapshot snapshot = await Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: widget.patient.id)
        .where('timeadded', isGreaterThanOrEqualTo: _fromDate)
        .where('timeadded', isLessThanOrEqualTo: _toDate)
        .getDocuments();

    newRows.add(["Check Type", "Check", "Comments", "Carer", "Time"]);

    snapshot.documents
    .forEach((data) => {
          getComments(data.documentID).then((comments) => newRows.add([
                data['type'].toString(),
                data['logdescription']?.toString() ?? "",
                comments,
                data['username']?.toString() ?? "",
                data['timeadded'].toDate().toString()
              ]))
        });

        
      setState(() {
        rows = newRows;
      });
   
    return newRows;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<void> writeCsv() async {
    var patientName = widget.patient.firstname + "_" + widget.patient.lastname;

    var date = DateTime.now().toUtc().toString();

    File csvFile = await _localFile('$patientName-$date.csv');

    String csv = const ListToCsvConverter().convert(rows);

    await csvFile.writeAsString('$csv');

    storage.StorageReference ref = storage.FirebaseStorage.instance
        .ref()
        .child("csv")
        .child(csvFile.uri.toString());
    storage.StorageUploadTask uploadTask = ref.putFile(csvFile);
    var csvUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    final Email email = Email(
      body: 'Here is your reqested report $csvUrl',
      subject: 'Patient csv report',
      recipients: [widget.user.email],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  Future<void> writePdf() async {
    await PdfReport(widget.patient, rows, widget.user.email, _fromDate, _toDate, widget.user.carehome.name).sendReport();
  }

  List<DataRow> buildRows() {
    List<DataRow> rowWidgets = [];

    rows.forEach((r) => rowWidgets.add(DataRow(cells: [
          DataCell(Text(r[0] ?? "")),
          DataCell(Text(r[1] ?? "")),
     //     DataCell(Text(r[2] ?? "")),
          DataCell(Text(r[3] ?? "")),
          DataCell(Text(r[4] ?? "")),
        ])));

    return rowWidgets;
  }

  Widget report() {
    return SingleChildScrollView(
            primary: true,
            child:  ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height -240 ),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child:Text("Patient Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),),
          
           Expanded(child: Container(
           
              
         child: Card(
              color: Color.fromARGB(255, 250, 243, 242),
              child:ListView.builder(
                shrinkWrap: true,
                itemCount: rows.length,
                itemBuilder: (context, int){
                  return Row(children: <Widget>[
                    Container( 
                      constraints: BoxConstraints(maxWidth: 70, minWidth: 70),
                      child:Padding(
                        padding:EdgeInsets.all(4),
                       child:Text(rows[int][0] ?? "", style: int == 0 ? TextStyle(fontWeight: FontWeight.bold) : null),
                       )),
                       Container( 
                      constraints: BoxConstraints(maxWidth: 180, minWidth: 180),
                      child:Padding(
                        padding:EdgeInsets.all(4),
                       child:Text(rows[int][1] ?? "", style: int == 0 ? TextStyle(fontWeight: FontWeight.bold) : null),)),
                       Container( 
                      constraints: BoxConstraints(maxWidth: 80, minWidth: 80),
                      child:Padding(
                        padding:EdgeInsets.all(4),
                       child:Text(rows[int][3] ?? "", style: int == 0 ? TextStyle(fontWeight: FontWeight.bold) : null),)),
                         Container( 
                      constraints: BoxConstraints(maxWidth: 70, minWidth: 70),
                      child:Padding(
                        padding:EdgeInsets.all(4),
                       child:Text(rows[int][4] ?? "", style: int == 0 ? TextStyle(fontWeight: FontWeight.bold) : null),)),
    
                  ],);
                },
              ),
            ))
         // ])
        )])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Generate Report"),
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(children: <Widget>[
                Text("From:"),
                Spacer(),
                FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(5.0)),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          backgroundColor: Color.fromARGB(255, 250, 243, 242),
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true, onConfirm: (date) {
                      _fromDateString =
                          '${date.year} / ${date.month.toString().padLeft(2, '0')} / ${date.day.toString().padLeft(2, '0')}';

                      setState(() {
                        _fromDate = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                    setState(() {});
                  },
                  child: Text(
                    _fromDateString ?? "",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Spacer(),
                Text("To:"),
                Spacer(),
                FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(5.0)),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          backgroundColor: Color.fromARGB(255, 250, 243, 242),
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true, onConfirm: (date) {
                      _toDateString =
                          '${date.year} / ${date.month.toString().padLeft(2, '0')} / ${date.day.toString().padLeft(2, '0')}';

                      setState(() {
                        _toDate = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                    setState(() {});
                  },
                  child: Text(
                    _toDateString ?? "",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ]),
            ),
            RaisedButton(
              onPressed: (){getRows(); setState((){});},
              child: Text("Generate Report"),
            ),
            Visibility(
                visible: rows.length != 0,
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    RaisedButton(
                      onPressed: () => writeCsv(),
                      child: Text("Export CSV"),
                    ),
                    Spacer(),
                    RaisedButton(
                      onPressed: () => writePdf(),
                      child: Text("Export PDF"),
                    ),
                    Spacer()
                  ],
                )),
            Visibility(
                child: Container(
                    child:report()
                ),
                visible: rows.length != 0),
            Visibility(
                child: Container(
                    child:Text("No data available for selected date range. Select dates and click generate report."),
                ),
                visible: rows.length == 0)
          ],
        ));
  }
}
