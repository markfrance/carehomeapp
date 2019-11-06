import 'dart:io';

import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

class PatientReport extends StatefulWidget {
  PatientReport(this.patient);

  final Patient patient;
  @override
  _PatientReportState createState() => _PatientReportState();
}

class _PatientReportState extends State<PatientReport> {
  List<List<String>> rows = new List<List<String>>();

  @override
  void initState() {
    super.initState();
    getRows();
  }

  void getRows() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('feeditem')
        .where('patient', isEqualTo: widget.patient.id)
        .getDocuments();

    snapshot.documents.forEach((data) => {
          rows.add([
            data['type'].toString(),
            "description",
            //data['description'].toString(),
            "COmments",
            data['user'].toString(),
            data['timeadded'].toString()
          ])
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

  Future<File> writeCsv() async {
    var patientName = widget.patient.firstname + "_" + widget.patient.lastname;

    var date = DateTime.now().toUtc().toString();

    final file = await _localFile('$patientName-$date.csv');

    String csv = const ListToCsvConverter().convert(rows);

    return file.writeAsString('$csv');
  }

  List<DataRow> buildRows() {
    List<DataRow> rowWidgets = [];

    rows.forEach((r) => rowWidgets.add(DataRow(cells: [
          DataCell(Text(r[0])),
          DataCell(Text(r[1])),
          DataCell(Text(r[2])),
          DataCell(Text(r[3])),
          DataCell(Text(r[4])),
        ])));

    return rowWidgets;
  }

  Widget report() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset("assets/images/icons/PNG/main.png"),
          Text("Daily Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Column(children: <Widget>[
            Row(
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
                                  "assets/images/avatar_placeholder_small.png",
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
                          Text("Date",
                              style: Theme.of(context).textTheme.subhead),
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
            ),
            Card(
              color: Color.fromARGB(255, 250, 243, 242),
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Check Type")),
                  DataColumn(label: Text("Check")),
                  DataColumn(label: Text("Comments")),
                  DataColumn(label: Text("Carer")),
                  DataColumn(label: Text("Time"))
                ],
                rows: buildRows(),
              ),
            ),
          ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          title: 
            Text("Export CSV"),
            
          
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
        ),
        body: SingleChildScrollView(child: report()));
  }
}
