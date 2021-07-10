import 'package:flutter/cupertino.dart';

class LoaderProvider extends ChangeNotifier {
  bool _load = false;
  bool _textFieldState = false;
  bool _status = true;
  bool get load => _load;

  void setLoader(bool val) {
    _load = val;
    notifyListeners();
  }

  bool get textFieldStatus => _textFieldState;
  setTextField(bool val) {
    _textFieldState = val;
    notifyListeners();
  }

  bool get status => _status;
  setConnectionStatus(bool val) {
    _status = val;
    notifyListeners();
  }
}
