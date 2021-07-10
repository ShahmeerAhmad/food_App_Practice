import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/client/model/product.dart';
import 'package:food_app/client/model/profiledata.dart';
import 'package:http/http.dart' as http;

class DataBaseService {
  String uid;
  DataBaseService({this.uid});
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference featured =
      FirebaseFirestore.instance.collection("feature");
  CollectionReference popular =
      FirebaseFirestore.instance.collection("popular");
  CollectionReference cart = FirebaseFirestore.instance.collection("cart");
  CollectionReference order = FirebaseFirestore.instance.collection("ship");
  CollectionReference history =
      FirebaseFirestore.instance.collection("history");
  Future<void> addUser(String username, email, address, phone) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          "name": username,
          "email": email,
          "address": address,
          "phone": phone
        })
        .then((value) => print("user Added"))
        .catchError((error) => print("failed $error"));
  }

  ProfileData getProfileData(DocumentSnapshot e) {
    return ProfileData(
        name: e.data()["name"] ?? "",
        email: e.data()["email"] ?? "",
        address: e.data()["address"] ?? "",
        phone: e.data()["phone"]);
  }

  Stream<ProfileData> get getProData {
    return users
        .doc(uid)
        .snapshots(includeMetadataChanges: true)
        .map(getProfileData);
  }

  List<Product> getAll(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Product(
          docId: doc.id ?? "",
          name: doc.data()["name"] ?? "",
          img: doc.data()['img'] ?? "",
          category: doc.data()['category'] ?? "",
          price: doc.data()['price'] ?? 0,
          rating: doc.data()['rating'] ?? 0,
          description: doc.data()["description"] != null
              ? doc.data()["description"]
              : "",
          status: doc.data()["status"] ?? true);
    }).toList();
  }

  Stream<List<Product>> get getAllData {
    return featured.snapshots(includeMetadataChanges: true).map(getAll);
  }

  List<Product> getAllPopular(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Product(
          docId: doc.id.toString() ?? "",
          name: doc.data()["name"] ?? "",
          img: doc.data()['img'] ?? "",
          category: doc.data()['category'] ?? "",
          price: doc.data()['price'] ?? 0,
          rating: doc.data()['rating'] ?? 0,
          status: doc.data()["status"]);
    }).toList();
  }

  Stream<List<Product>> get getAllPopularData {
    return popular.snapshots(includeMetadataChanges: true).map(getAllPopular);
  }

  Future<void> addCart(String name, img, category, int price, rating) {
    return cart
        .doc()
        .set({
          "name": name,
          "img": img,
          "category": category,
          "price": price,
          "rating": rating
        })
        .then((value) => print("Cart Added"))
        .catchError((error) => print("failed $error"));
  }

  // List<Product> getAllCart(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return Product(
  //         name: doc.data()["name"] ?? "",
  //         img: doc.data()['img'] ?? "",
  //         category: doc.data()['category'] ?? "",
  //         price: doc.data()['price'] ?? 0,
  //         rating: doc.data()['rating'] ?? 0);
  //   }).toList();
  // }

  // Stream<List<Product>> get getAllCartData {
  //   return cart.snapshots(includeMetadataChanges: true).map(getAllCart);
  // }
  var serverToken =
      "AAAAOVljoc0:APA91bGhwEciaUxFNV8g_s5WFnnclEVoEC7_mIcF3UJHJBZK8iGPMRPWR0cw0t-ifWWtL38u1HVEH-MyTvpOs-35R0WQpAnyXB6SfU_Jyce1kkCW5o2-j_jluOboJgYazTqWyBe1OElT";

  sendNotfiy(String title, String body) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body.toString(),
            'title': title.toString()
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'to':
              "AAAAOVljoc0:APA91bGhwEciaUxFNV8g_s5WFnnclEVoEC7_mIcF3UJHJBZK8iGPMRPWR0cw0t-ifWWtL38u1HVEH-MyTvpOs-35R0WQpAnyXB6SfU_Jyce1kkCW5o2-j_jluOboJgYazTqWyBe1OElT",
        },
      ),
    );
    print("send");
  }

  Future<void> addOrder(
      String name, address, img, int item, phone, price, bool status) {
    history
        .doc(uid)
        .collection("userhistory")
        .add(({
          "name": name,
          "address": address,
          "img": img,
          "item": item,
          "price": price,
          "phone": phone,
          "status": status
        }))
        .then((value) => print("Cart Added"))
        .catchError((error) => print("failed $error"));

    sendNotfiy("Order", "Order Reciedved");
    order
        .doc()
        .set(({
          "name": name,
          "address": address,
          "img": img,
          "item": item,
          "price": price,
          "phone": phone,
          "uid": uid
        }))
        .then((value) => print("Cart Added"))
        .catchError((error) => print("failed $error"));
  }

  // List<Shipping> getShipping(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     print(doc.data()["address"]);
  //     return Shipping(
  //         name: doc.data()['name'],
  //         address: doc.data()["address"],
  //         img: doc.data()['img'],
  //         item: doc.data()["item"],
  //         phone: doc.data()["phone"],
  //         price: doc.data()['price']);
  //   }).toList();
  // }

  // Stream<List<Shipping>> get getAllShipping {
  //   return order.snapshots(includeMetadataChanges: true).map(getShipping);
  // }
}
