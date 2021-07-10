import 'package:flutter/material.dart';
import 'package:food_app/client/pages/loginPage.dart';
import 'package:food_app/client/pages/registration.dart';

class LoginToggle extends StatefulWidget {
  @override
  _LoginToggleState createState() => _LoginToggleState();
}

class _LoginToggleState extends State<LoginToggle> {
  bool value = true;

  void togglePage() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (value) {
      return LoginPage(
        togglePage: togglePage,
      );
    } else {
      return RegisterPage(
        togglePage: togglePage,
      );
    }
  }
}
