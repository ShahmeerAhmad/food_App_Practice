import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/client/constants/constant.dart';
import 'package:food_app/client/model/User.dart';
import 'package:food_app/client/pages/home.dart';
import 'package:food_app/client/provider/LoaderProvider.dart';
import 'package:food_app/client/services/DatabaseService.dart';
import 'package:food_app/client/utils/logintoggle.dart';
import 'package:get/get.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserId _getUid(User uid) {
    return uid.uid != null ? UserId(uid: uid.uid) : null;
  }

  Stream<UserId> get user => _auth.authStateChanges().map(_getUid);
  Future<bool> signin(String email, password) async {
    try {
      UserCredential credential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((error) {
        Get.rawSnackbar(
            duration: Duration(seconds: 5), message: error.message.toString());
      });

      if (credential.user.uid != null) {
        Saver().setLoginStatus(true);

        _getUid(credential.user);

        Get.off(HomeScreen());
        Get.rawSnackbar(
            message: "Successfully",
            backgroundColor: Colors.orangeAccent,
            duration: Duration(seconds: 5));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _mapLoginWithEmailError(FirebaseException error) {
    final code = error.code;
    if (code == 'ERROR_INVALID_EMAIL') {
      print("Errore");
    } else if (code == 'ERROR_WRONG_PASSWORD') {
      print("Errore");
    } else if (code == 'ERROR_USER_NOT_FOUND') {
      print("Errore");
    } else if (code == 'ERROR_TOO_MANY_REQUESTS') {
      print("Errore");
    } else if (code == 'ERROR_USER_DISABLED') {
      print("Errore");
    } else if (code == 'ERROR_OPERATION_NOT_ALLOWED') {
      print("Errore");
      throw 'Email and Password accounts are disabled. Enable them in the '
          'firebase console?';
    } else {
      print("naahi pata");
    }
  }

  Future register(String user, email, password, address, phone) async {
    try {
      UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((error) {
        Get.rawSnackbar(
            duration: Duration(seconds: 5), message: error.message.toString());
      });
      DataBaseService(uid: credential.user.uid)
          .addUser(user, email, address, phone);
      if (credential.user.uid != null) {
        _getUid(credential.user);
        Get.rawSnackbar(
            message: "Successfully",
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2));
        _getUid(credential.user);
        Get.off(HomeScreen());
        Saver().setLoginStatus(true);
      }

      return credential.user.uid;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signout() async {
    try {
      _auth.signOut();
      Saver().setLoginStatus(false);
      Get.off(LoginToggle());
    } catch (e) {}
  }
}
