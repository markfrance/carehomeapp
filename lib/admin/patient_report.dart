import 'dart:io';

import 'package:carehomeapp/admin/pdf_report.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

class PatientReport extends StatefulWidget {
  PatientReport(this.patient, this.user);

  final Patient patient;
  final User user;
  @override
  _PatientReportState createState() => _PatientReportState();
}

class _PatientReportState extends State<PatientReport> {
  List<List<String>> rows = new List<List<String>>();

  String _fromDateString = "";
  String _toDateString = "";
  DateTime _fromDate;
  DateTime _toDate;
  bool update;

  @override
  void initState() {
    super.initState();
    //  getRows();
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

  void getRows() async {
    rows.clear();
    QuerySnapshot snapshot = await Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: widget.patient.id)
        .getDocuments();

    rows.add(["Check Type", "Check", "Comments", "Carer", "Time"]);

    snapshot.documents.where((snap) => DateTime.parse(snap['timeadded']).compareTo(_fromDate) >= 0
      && DateTime.parse(snap['timeadded']).compareTo(_toDate) <= 0)
    .forEach((data) => {
          getComments(data.documentID).then((comments) => rows.add([
                data['type'].toString(),
                data['logdescription']?.toString() ?? "",
                comments,
                data['username']?.toString() ?? "",
                data['timeadded'].toDate().toString()
              ]))
        });

    setState(() {
      update = true;
    });
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
    await PdfReport(widget.patient, rows, widget.user.email, _fromDate, _toDate).sendReport();
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         
          Text("Patient Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Column(children: <Widget>[
          /*  Row(
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
                        padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              imageUrl: widget.patient.imageUrl ??
                                  "https://firebasestorage.googleapis.com/v0/b/carehomeapp-a2936.appspot.com/o/avatar_placeholder_small.png?alt=media&token=32adc9ac-03ad-45ed-bd4c-27ecc4f80a55",
                              placeholder: (context, url) => Image.asset(
                                  "assets/images/avatar_placeholder_small.png",
                                  width: 50,
                                  height: 50),
                              width: 50,
                              height: 50),
                        ),
                      ),
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
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
               
                          Text(widget.patient.id,
                              style: Theme.of(context).textTheme.subhead),
                          Text(widget.patient.keynurse,
                              style: Theme.of(context).textTheme.subhead),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
          ),*/
            Card(
              color: Color.fromARGB(255, 250, 243, 242),
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Check Type")),
                  DataColumn(label: Text("Check")),
                //  DataColumn(label: Text("Comments")),
                  DataColumn(label: Text("Carer")),
                  DataColumn(label: Text("Time"))
                ],
                rows: buildRows(),
              ),
            )
         // ])
        ])]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () => getRows(),
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
                    child: SingleChildScrollView(
                  primary: false,
                  child: report()
                )),
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
