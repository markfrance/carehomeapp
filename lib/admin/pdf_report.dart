import 'dart:io';

import 'package:carehomeapp/model/patient_model.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class PdfReport {
  PdfReport(this.patient, this.rows, this.email, this.dateFrom, this.dateTo, this.carehomename);
  final Patient patient;
  final String email;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String carehomename;
  final List<List<String>> rows;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<void> sendReport() async {
    final Document pdf = Document();

    pdf.addPage(MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const BoxDecoration(
                  border: BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: Text('Carehomeapp Patient Report',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
              Header(
                  level: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Patient Report', textScaleFactor: 2),
                      
                      ])),
              Paragraph(text: "First Name: ${patient.firstname}"),
              Paragraph(text: "Last Name: ${patient.lastname}"),
              Paragraph(text: "Age: ${patient.age.toString()}"),
              Paragraph(
                  text: "Dates: ${dateFrom.toString()} - ${dateTo.toString()}"),
              Paragraph(text: "Patient ID: ${patient.id.toString()}"),
              Paragraph(text: "Key Nurse: ${patient.keynurse}"),
              Paragraph(text: "Carehome: $carehomename"),
              Table.fromTextArray(context: context, data: rows),
            ]));

    final File file = await _localFile('example.pdf');
    file.writeAsBytesSync(pdf.save());

    storage.StorageReference ref = storage.FirebaseStorage.instance
        .ref()
        .child("pdf")
        .child(file.uri.toString());
    storage.StorageUploadTask uploadTask = ref.putFile(file);
    var pdfUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    final Email emailContent = Email(
      body: 'Here is your requested PDF report $pdfUrl',
      subject: 'Patient PDF report',
      recipients: [email],
      isHTML: true,
    );

    await FlutterEmailSender.send(emailContent);
  }
}
