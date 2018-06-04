import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({this.onSuccess, this.onError});

  final VoidCallback onSuccess;
  final VoidCallback onError;

  @override
  LoginFormState createState() {
    return new LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {

  String _username;
  String _password;

  GlobalKey<FormState> _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Login"),
          ),
          body: Column(
          children: <Widget>[
            TextFormField(
              onSaved: (text){
                _username = text;
              },
              decoration: InputDecoration(
                  hintText: "username"
              ),
            ),
            TextFormField(
              onSaved: (text){
                _password = text;
              },
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "password"
              ),
            ),
            RaisedButton(
              onPressed: (){
                _key.currentState.save();
                if(_username == "menno" && _password == "secret") {
                  widget.onSuccess();
                } else {
                  widget.onError();
                }
              },
              child: Text("login"),
            )
          ],
        ),
      ),
    );
  }
}
