import 'package:carehomeapp/authentication.dart';
import 'package:flutter/material.dart';


class ResetPassword extends StatefulWidget {
    ResetPassword(this.auth);
  final BaseAuth auth;

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {

  final _formKey = new GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  void _resetPassword() async {
    await widget.auth.resetPassword(emailController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          leading: Padding(
            padding: EdgeInsets.all(5),
            child: Image.asset(
              "assets/images/icons/PNG/main.png",
            ),
          ),
          title: new Text('CareHomeApp Reset Password'),
        ),
        body: Stack(children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Image.asset(
                "assets/images/icons/PNG/main.png",
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                      child: new TextFormField(
                        controller: emailController,
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: new InputDecoration(
                          hintText: 'email',
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Email can\'t be empty' : null
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(16),
                    child: Text("Enter your email address and you will receive an email with a link to reset password if your email exists.")),
                    Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Color.fromARGB(255, 249, 210, 45),
            child: new Text('Reset Password',
                style: new TextStyle(fontSize: 20.0, color: Colors.black)),
            onPressed: () => _resetPassword(),
          ),
        ))
                  ],
                ),
              ))
        ]));
  }
}
