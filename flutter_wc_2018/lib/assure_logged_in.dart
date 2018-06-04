import 'package:flutter/material.dart';
import 'login_form.dart';

class AssureLoggedIn extends StatefulWidget {
  AssureLoggedIn({this.child});

  final Widget child;

  @override
  AssureLoggedInState createState() {
    return new AssureLoggedInState();
  }
}

class AssureLoggedInState extends State<AssureLoggedIn> {

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? widget.child : new LoginForm(
      onSuccess: () {
        setState(() {
          isLoggedIn = true;
        });
      },
      onError: () {
        print("no go!");
      }
    );
  }
}
