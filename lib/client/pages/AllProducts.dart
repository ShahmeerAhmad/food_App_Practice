import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/client/model/product.dart';
import 'package:food_app/client/pages/ProductDetails.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  int value = 0;

  List<Map> _items = [
    {"value": 0, "text": 'All'},
    {"value": 1, "text": 'snacks'},
    {"value": 2, "text": 'bread & rusk'},
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;

    double h = size.height;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("All Products"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                hint: Container(
                    width: w / 100 * 80,
                    height: 20,
                    child: Text("Select Category")),
                items: _items
                    .map((item) => DropdownMenuItem(
                          value: item["value"],
                          child: Text(item["text"]),
                        ))
                    .toList(),
                onChanged: (v) => setState(() {
                  value = v;
                }),
                value: value,
              ),
            ),
            Container(
                width: w,
                height: h / 100 * 80,
                child: FutureBuilder<QuerySnapshot>(
                  future:
                      FirebaseFirestore.instance.collection("popular").get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> data = snapshot.data.docs;
                      print(data);
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            print(data);
                            final _data = data[index].data();

                            if (_data['status'] &&
                                _data["category"] == _items[value]['text']) {
                              return GestureDetector(
                                onTap: () {
                                  print(_data['price']);
                                  Get.to(ProductDetails(
                                    product: Product(
                                        name: "he",
                                        description: "h",
                                        img: "",
                                        category: "d",
                                        price: _data["price"],
                                        rating: _data['rating']),
                                  ));
                                },
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                      width: w / 32,
                                      height: h / 3.2,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: w,
                                              height: h / 4,
                                              child: _data['img'] != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: _data["img"],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    )
                                                  : Container(),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ListTile(
                                              title: Text(_data["name"]),
                                              subtitle: SmoothStarRating(
                                                  allowHalfRating: false,
                                                  onRated: (v) {},
                                                  starCount: 5,
                                                  rating: 4.0,
                                                  size: 20.0,
                                                  isReadOnly: true,
                                                  color: Colors.green,
                                                  borderColor: Colors.green,
                                                  spacing: 0.0),
                                              trailing: Text(
                                                  _data["price"].toString() +
                                                      " PKR"),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              );
                            } else if (_data['status'] &&
                                _items[value]['text'] == "All") {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ProductDetails(
                                    product: Product(
                                        name: _data['name'],
                                        description: _data['description'],
                                        img: _data['img'] != null
                                            ? _data['img']
                                            : "",
                                        category: _data["category"],
                                        price: _data['price'],
                                        rating: _data['rating']
                                        // price: double.parse(_data["price"]),
                                        // rating: double.parse(_data["rating"]),
                                        ),
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
                                            child: CachedNetworkImage(
                                              imageUrl: _data["img"],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(_data["name"]),
                                            subtitle: SmoothStarRating(
                                                allowHalfRating: false,
                                                onRated: (v) {},
                                                starCount: 5,
                                                rating: 4.0,
                                                size: 20.0,
                                                isReadOnly: true,
                                                color: Colors.green,
                                                borderColor: Colors.green,
                                                spacing: 0.0),
                                            trailing: Text(
                                                _data["price"].toString() +
                                                    " PKR"),
                                          )
                                        ],
                                      )),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
