import 'dart:io';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/logcheck/enter_comment.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormHeader extends StatefulWidget{

  final void Function(String value) imagecallback;
  final void Function(String value) commentCallback;
  final User user;
  FormHeader(this.user,this.imagecallback, this.commentCallback);
  @override
  FormHeaderState createState() => FormHeaderState();
}

class FormHeaderState extends State<FormHeader> {

  Future<String> _pickPhoto(String imageId) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(imageId)
        .child(imageFile.uri.toString());
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void setComment(String commentText) {
    widget.commentCallback(commentText);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child:Row(
      children: <Widget>[
        Expanded(
            child: Align(
              alignment: Alignment(-2,0),
              child: FlatButton(
                child: Icon(CareHomeIcons.arrowleft, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flex: 4),
        Expanded(
            child: FlatButton(
              child: Icon(
                CareHomeIcons.comment,
                color: Colors.black,
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EnterComment(widget.user, null, this.setComment);
                  }),
            ),
            flex: 1),
        Expanded(
            child: FlatButton(
              child: Icon(CareHomeIcons.addphoto, color: Colors.black),
              onPressed: () => _pickPhoto("id").then((url) {widget.imagecallback(url);}),
            ),
            flex: 1)
      ],
    ));
  }
}