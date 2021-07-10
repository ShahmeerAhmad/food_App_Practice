import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_app/client/model/User.dart';
import 'package:food_app/client/model/product.dart';
import 'package:food_app/client/model/profiledata.dart';
import 'package:food_app/client/pages/home.dart';
import 'package:food_app/client/services/DatabaseService.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrderConfirm extends StatefulWidget {
  int item;
  Product product;
  OrderConfirm({this.item, this.product});
  @override
  _OrderConfirmState createState() => _OrderConfirmState();
}

class _OrderConfirmState extends State<OrderConfirm> {
  getToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    print("---------------");
    print(token);
  }

  @override
  void initState() {
    getToken();
    // TODO: implement initState
    super.initState();
  }

  final _formState = GlobalKey<FormState>();
  bool _editable = true;
  @override
  Widget build(BuildContext context) {
    final _uid = Provider.of<UserId>(context).uid;
    return WillPopScope(
      onWillPop: () {
        Get.back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Check Info"),
          backgroundColor: Colors.deepOrange,
        ),

        //Body Data confirm order

        body: StreamBuilder<ProfileData>(
            stream: DataBaseService(uid: _uid).getProData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                TextEditingController _address =
                    TextEditingController(text: snapshot.data.address);
                return SingleChildScrollView(
                  child: Form(
                    key: _formState,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl: widget.product.img.toString(),
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.product.name.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Category ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.product.category.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Price ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.item * widget.product.price}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "item ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.item}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Contact ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${snapshot.data.phone}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            readOnly: _editable,
                            controller: _address,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                disabledBorder: InputBorder.none,
                                suffixIcon: _editable
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 33,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _editable = !_editable;
                                          });
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.check_rounded,
                                          size: 33,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _editable = !_editable;
                                          });
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(_uid)
                                              .update({
                                                "address":
                                                    _address.text.toString()
                                              })
                                              .then((value) => Get.rawSnackbar(
                                                  message:
                                                      'Successfully Update',
                                                  duration:
                                                      Duration(seconds: 3)))
                                              .catchError((error) {
                                                Get.rawSnackbar(
                                                    message: error.toString(),
                                                    duration:
                                                        Duration(seconds: 3));
                                              });
                                        })),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            DataBaseService(uid: _uid).addOrder(
                                widget.product.name,
                                snapshot.data.address.toString(),
                                widget.product.img,
                                widget.item,
                                snapshot.data.phone,
                                widget.item * widget.product.price,
                                false);
                            Get.off(HomeScreen());
                          },
                          textColor: Colors.white,
                          elevation: 5,
                          height: 50,
                          minWidth: 199,
                          child: Text("Confirm Order"),
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 19,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
