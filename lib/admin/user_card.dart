import 'package:carehomeapp/admin/user_edit.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final User user;

  UserCard(this.user);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  void _deleteUser(BuildContext context) {
    Firestore.instance.collection('users').document(widget.user.id).delete();
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User?'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Text('ACCEPT', style: TextStyle(color: Colors.black)),
              onPressed: () {
                _deleteUser(context);
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserBinding.of(context).user;

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserEdit(widget.user)),
          );
        },
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Color.fromARGB(255, 250, 243, 242),
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 18.0, left: 18),
            child: Row(children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        (widget.user.firstName ?? "") +
                            " " +
                            (widget.user.lastName ?? ""),
                        style: Theme.of(context).textTheme.subhead),
                    Text(widget.user.email ?? ""),
                    Text(widget.user.carehome?.name ?? "",
                        style: Theme.of(context).textTheme.subhead),
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Roles",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Carer"),
                        Visibility(
                          visible: widget.user.isManager ?? false,
                          child: Text("Manager"),
                        ),
                        Visibility(
                            visible: widget.user.isSuperAdmin ?? false,
                            child: Text("Super Admin")),
                      ],
                    ),
                  ),
                  flex: 1),
              Visibility(
                visible: user.isSuperAdmin == true,
                child: Expanded(
                    child: FlatButton(
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => _asyncConfirmDialog(context),
                    ),
                    flex: 1),
              ),
            ]),
          ),
        ));
  }
}
