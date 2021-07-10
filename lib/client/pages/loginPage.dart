import 'package:flutter/material.dart';
import 'package:food_app/client/pages/Loading.dart';
import 'package:food_app/client/pages/home.dart';
import 'package:food_app/client/provider/LoaderProvider.dart';
import 'package:food_app/client/services/AuthServices.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function togglePage;
  LoginPage({Key key, this.togglePage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _fonmState = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final load = Provider.of<LoaderProvider>(context);
    return SafeArea(
      child: load.load
          ? Loading()
          : Scaffold(
              backgroundColor: Colors.white,
              key: _key,
              body: Form(
                key: _fonmState,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ClipPath(
                          child: Container(
                            padding: EdgeInsets.all(40),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            color: Colors.white,
                            child: Image.asset(
                              "images/logo.jpg",
                              width: 200,
                              height: 200,
                            ),
                          ),
                          clipper: CustomClipPath(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              controller: _email,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Field Empty";
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  icon: Icon(Icons.email)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              obscureText: true,
                              controller: _password,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Field Empty";
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  icon: Icon(Icons.lock)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            if (_fonmState.currentState.validate()) {
                              _fonmState.currentState.save();
                              load.setLoader(true);
                              await AuthService()
                                  .signin(_email.text, _password.text);
                              load.setLoader(false);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.togglePage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Register Here",
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
