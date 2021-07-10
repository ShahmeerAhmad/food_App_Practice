import 'package:flutter/material.dart';
import 'package:food_app/client/pages/Loading.dart';
import 'package:food_app/client/pages/home.dart';
import 'package:food_app/client/provider/LoaderProvider.dart';
import 'package:food_app/client/services/AuthServices.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final Function togglePage;
  RegisterPage({Key key, this.togglePage}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _fonmState = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final load = Provider.of<LoaderProvider>(context);
    return load.load
        ? Scaffold(body: Loading())
        : SafeArea(
            top: true,
            bottom: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: _key,
              body: SingleChildScrollView(
                child: Form(
                  key: _fonmState,
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
                              controller: _username,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Field Empty";
                                }
                              },
                              // onChanged: (val) {
                              //   _username.text = val.toString();
                              // },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  icon: Icon(Icons.person)),
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
                              keyboardType: TextInputType.phone,
                              controller: _phone,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Field Empty";
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone",
                                  icon: Icon(Icons.phone)),
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
                              controller: _address,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Field Empty";
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address",
                                  icon: Icon(Icons.home_work_outlined)),
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
                              controller: _password,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Field Empty";
                                }
                              },
                              obscureText: true,
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
                              await AuthService().register(
                                  _username.text,
                                  _email.text,
                                  _password.text,
                                  _address.text,
                                  _phone.text);
                              load.setLoader(false);
                              _username.text = "";
                              _email.text = "";
                              _address.text = "";
                              _phone.text = "";
                              _password.text = "";
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
                                    "Register",
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
                          return widget.togglePage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already have an account?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Login Here",
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
