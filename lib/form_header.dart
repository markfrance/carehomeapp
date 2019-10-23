import 'dart:io';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/enter_comment.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormHeader extends StatelessWidget {

  Future<String> _pickPhoto(String imageId) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(imageId)
        .child(imageFile.uri.toString());
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                child: Icon(CareHomeIcons.arrowleft, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flex: 3),
        Expanded(
            child: FlatButton(
              child: Icon(
                CareHomeIcons.comment,
                color: Colors.black,
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EnterComment();
                  }),
            ),
            flex: 1),
        Expanded(
            child: FlatButton(
              child: Icon(CareHomeIcons.addphoto, color: Colors.black),
              onPressed: () => _pickPhoto("id"),
            ),
            flex: 1)
      ],
    );
  }
}