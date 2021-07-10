import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/client/model/product.dart';
import 'package:food_app/client/pages/cartScreend.dart';
import 'package:food_app/client/pages/orderConfirm.dart';
import 'package:food_app/client/services/DatabaseService.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductDetails extends StatefulWidget {
  Product product;
  ProductDetails({this.product});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String name, description, image;
  double price;
  int item = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;

    return WillPopScope(
      onWillPop: () {
        Get.back();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(5),
              width: w,
              height: h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: w,
                            height: h / 11,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Get.to(CartScreen(title: "CartScreen"));
                                    }),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            width: 150,
                            height: 150,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: widget.product.img,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: w,
                            height: h / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Price ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.product.price.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rating ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SmoothStarRating(
                                        allowHalfRating: false,
                                        onRated: (v) {},
                                        starCount: 5,
                                        rating:
                                            widget.product.rating.toDouble(),
                                        size: 20.0,
                                        isReadOnly: true,
                                        color: Colors.green,
                                        borderColor: Colors.green,
                                        spacing: 0.0)
                                  ],
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Text(
                                  widget.product.description != null
                                      ? widget.product.description
                                      : "",
                                  maxLines: 5,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (item > 0) {
                                  item--;
                                }
                              });
                            },
                            child: CircleAvatar(
                              child: Icon(
                                Icons.remove,
                                size: 28,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (item > 0) {
                                DataBaseService().addCart(
                                    widget.product.name,
                                    widget.product.img,
                                    widget.product.category,
                                    widget.product.price,
                                    widget.product.rating);
                                Get.to(OrderConfirm(
                                  item: item,
                                  product: widget.product,
                                ));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 50,
                              color: Colors.red,
                              child: Text(
                                "Add To Cart $item",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                item++;
                              });
                            },
                            child: CircleAvatar(
                              child: Icon(
                                Icons.add,
                                size: 28,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
