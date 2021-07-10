import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:food_app/client/constants/providerValueSet.dart';
import 'package:food_app/client/model/User.dart';
import 'package:food_app/client/model/product.dart';
import 'package:food_app/client/model/profiledata.dart';
import 'package:food_app/client/pages/AllProducts.dart';
import 'package:food_app/client/pages/Loading.dart';
import 'package:food_app/client/pages/ProductDetails.dart';
import 'package:food_app/client/pages/ShippingOrder.dart';
import 'package:food_app/client/pages/cartScreend.dart';
import 'package:food_app/client/services/AuthServices.dart';
import 'package:food_app/client/services/DatabaseService.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'Address.dart';

class HomeScreen extends StatefulWidget {
  String uid;
  HomeScreen({this.uid});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  var _connectionStatus = "Enter the search word";

  bool _status = true;
  var _connectivity;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _connectivity = Connectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.wifi) {
          setState(() {
            _status = true;
          });
        } else if (result == ConnectivityResult.mobile) {
          setState(() {
            _status = true;
          });
        } else if (result == ConnectivityResult.none) {
          setState(() {
            _status = false;
          });
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  double _rate = 0;
  @override
  Widget build(BuildContext context) {
    final _uid = Provider.of<UserId>(context);

    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;
    return !_status
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loading(),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Waiting For Internet"),
                ],
              ),
            ),
          )
        : StreamBuilder<ProfileData>(
            initialData: ProfileData(),
            stream: DataBaseService(uid: _uid.uid).getProData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ProfileData profileData = snapshot.data;

                return WillPopScope(
                  onWillPop: () {
                    return null;
                  },
                  child: SafeArea(
                    bottom: true,
                    top: false,
                    child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          iconTheme: IconThemeData(color: Colors.white),
                          elevation: 0.5,
                          title: Text("FoodApp"),
                          actions: <Widget>[
                            Stack(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: () {
                                    Get.to(CartScreen(
                                      title: "CartScreen",
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),

                        //Drawer

                        drawer: Drawer(
                          child: ListView(
                            children: [
                              DrawerHeader(
                                decoration: BoxDecoration(color: Colors.red),
                                child: snapshot.hasData
                                    ? UserAccountsDrawerHeader(
                                        margin: EdgeInsets.all(0),
                                        decoration:
                                            BoxDecoration(color: Colors.red),
                                        accountName:
                                            Text(profileData.name ?? "none"),
                                        accountEmail: Text(
                                          profileData.email ?? "",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Container(),
                              ),
                              ListTile(
                                leading: Icon(Icons.home),
                                title: Text('Home'),
                                onTap: () {
                                  Get.off(HomeScreen());
                                },
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              ListTile(
                                leading: Icon(Icons.bookmark_outline),
                                title: Text('Orders'),
                                onTap: () {
                                  Get.to(ShippingOrder(
                                    title: "Shipping",
                                  ));
                                },
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              Provider(
                                create: (_) => AdressValue(),
                                child: ListTile(
                                  leading: Icon(Icons.location_on_outlined),
                                  title: Text('Address'),
                                  onTap: () {
                                    AdressValue()
                                        .setAddress(profileData.address);
                                    Get.to(Address(
                                      data: profileData,
                                    ));
                                  },
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              ListTile(
                                leading: Icon(Icons.add_shopping_cart_rounded),
                                title: Text('Products'),
                                onTap: () {
                                  Get.to(AllProducts());
                                },
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              ListTile(
                                leading: Icon(Icons.person_search_outlined),
                                title: Text('About'),
                                onTap: () {},
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.logout,
                                ),
                                title: Text('Logout'),
                                onTap: () {
                                  AuthService().signout();
                                },
                              ),
                              Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),

                        //Body DATA

                        body: SingleChildScrollView(
                          child: Column(
                            // padding: EdgeInsets.all(5),
                            // physics: NeverScrollableScrollPhysics(),
                            children: [
                              // Container(
                              //   color: Colors.white,
                              //   width: w,
                              //   height: h / 9,
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(12),
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //           border: Border.all(color: Colors.grey),
                              //           borderRadius: BorderRadius.circular(15)),
                              //       child: Padding(
                              //         padding: EdgeInsets.only(left: 10),
                              //         child: TextFormField(
                              //           autofocus: false,
                              //           decoration: InputDecoration(
                              //               border: InputBorder.none,
                              //               hintText: "Search Food",
                              //               icon: Icon(Icons.food_bank_outlined)),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: w,
                                  height: h / 4,
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 10),
                                          alignment: Alignment.topLeft,
                                          width: w,
                                          height: 22,
                                          child: Text(
                                            "Featured",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      //Featured Details

                                      Container(
                                        width: w,
                                        height: h / 5,
                                        child: StreamBuilder<List<Product>>(
                                          stream: DataBaseService().getAllData,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var _data = snapshot.data;

                                              return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: _data.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (_data[index].status) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Get.to(ProductDetails(
                                                            product:
                                                                _data[index],
                                                          ));
                                                        },
                                                        child: Container(
                                                          width: w / 2.8,
                                                          child: Card(
                                                            elevation: 3,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  color: Colors
                                                                      .black,
                                                                  width: w,
                                                                  height: h / 7,
                                                                  child: Stack(
                                                                    children: [
                                                                      Opacity(
                                                                        opacity:
                                                                            0.4,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl: _data[index]
                                                                              .img
                                                                              .toString(),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          placeholder: (context, url) =>
                                                                              Center(child: CircularProgressIndicator()),
                                                                          errorWidget: (context, url, error) =>
                                                                              Icon(Icons.error),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            _data[index].name.toString() ??
                                                                                "",
                                                                            style: TextStyle(
                                                                                textBaseline: TextBaseline.alphabetic,
                                                                                color: Colors.white70,
                                                                                fontSize: 12),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            2),
                                                                    width:
                                                                        w / 2.8,
                                                                    height:
                                                                        h / 25,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        SmoothStarRating(
                                                                            allowHalfRating:
                                                                                false,
                                                                            onRated:
                                                                                (v) {},
                                                                            starCount:
                                                                                5,
                                                                            rating: _data[index].rating <= 0
                                                                                ? 0.0
                                                                                : _data[index].rating.toDouble(),
                                                                            size: 12.0,
                                                                            isReadOnly: true,
                                                                            color: Colors.green,
                                                                            borderColor: Colors.green,
                                                                            spacing: 0.0),
                                                                        Text(
                                                                          _data[index].price != null
                                                                              ? _data[index].price.toString()
                                                                              : "0" + " PKR",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  });
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //Popular

                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 10),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Popular:",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Get.to(AllProducts());
                                          },
                                          child: Text(
                                            "See All",
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          ))
                                    ],
                                  ),
                                  Container(
                                    width: w,
                                    height: h / 2,
                                    child: StreamBuilder<List<Product>>(
                                      stream:
                                          DataBaseService().getAllPopularData,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var _data = snapshot.data;
                                          return ListView.builder(
                                              itemCount: _data.length,
                                              itemBuilder: (context, index) {
                                                if (_data[index].status) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Get.to(ProductDetails(
                                                        product: _data[index],
                                                      ));
                                                    },
                                                    child: Card(
                                                      elevation: 2,
                                                      child: Container(
                                                          width: w / 3,
                                                          height: h / 2.6,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: w,
                                                                height: h / 3.5,
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      16 / 9,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: _data[
                                                                            index]
                                                                        .img
                                                                        .toString(),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom: 5,
                                                                      left: 5),
                                                                  child: Text(
                                                                      _data[index]
                                                                          .name),
                                                                ),
                                                                subtitle: SmoothStarRating(
                                                                    allowHalfRating:
                                                                        false,
                                                                    onRated:
                                                                        (v) {},
                                                                    starCount:
                                                                        5,
                                                                    rating: _data[
                                                                            index]
                                                                        .rating
                                                                        .toDouble(),
                                                                    size: 20.0,
                                                                    isReadOnly:
                                                                        true,
                                                                    color: Colors
                                                                        .green,
                                                                    borderColor:
                                                                        Colors
                                                                            .green,
                                                                    spacing:
                                                                        0.0),
                                                                trailing: Text(
                                                                    _data[index]
                                                                            .price
                                                                            .toString() +
                                                                        " PKR"),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              });
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            });
  }
}
