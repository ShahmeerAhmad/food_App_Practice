import 'package:flutter/material.dart';

class AdressValue extends ChangeNotifier {
  String _address = "value";
  String get address => _address;
  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }
}
