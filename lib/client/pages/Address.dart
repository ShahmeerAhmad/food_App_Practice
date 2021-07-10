import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/client/model/User.dart';

import 'package:food_app/client/model/profiledata.dart';
import 'package:food_app/client/provider/LoaderProvider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Address extends StatefulWidget {
  ProfileData data;
  Address({this.data});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool _textFieldEnable = false;
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ProviderValue>(context);
    TextEditingController _address =
        TextEditingController(text: widget.data.address);
    TextEditingController _phone =
        TextEditingController(text: widget.data.phone);
    TextEditingController _emial =
        TextEditingController(text: widget.data.email);
    final uid = Provider.of<UserId>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Adress Details"),
        ),
        body: SingleChildScrollView(
          child: Consumer<LoaderProvider>(builder: (context, snapshot, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phone"),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _phone,
                        enabled: snapshot.textFieldStatus,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      Text("Email"),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _address,
                        enabled: snapshot.textFieldStatus,
                        maxLines: 2,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      Text("Home Address"),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emial,
                        enabled: snapshot.textFieldStatus,
                        maxLines: 2,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ],
                  ),
                ),
                snapshot.textFieldStatus
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            snapshot.setTextField(false);
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid.uid)
                                .update({
                                  "address": _address.text,
                                  "phone": _phone.text,
                                  "email": _emial.text
                                })
                                .then((value) => Get.rawSnackbar(
                                    message: 'Successfully Update',
                                    duration: Duration(seconds: 3)))
                                .catchError((error) {
                                  Get.rawSnackbar(
                                      message: error.toString(),
                                      duration: Duration(seconds: 3));
                                });
                          },
                          child: Text("Change"),
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          color: Colors.red,
                          textColor: Colors.white,
                          shape: StadiumBorder(),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          shape: StadiumBorder(),
                          onPressed: () {
                            snapshot.setTextField(true);
                          },
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text("Edit"),
                          color: Colors.red,
                          textColor: Colors.white,
                        ),
                      )
              ],
            );
          }),
        ));
  }
}
