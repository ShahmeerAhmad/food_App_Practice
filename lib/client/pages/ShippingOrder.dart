import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/client/model/User.dart';
import 'package:provider/provider.dart';

class ShippingOrder extends StatefulWidget {
  String title;
  ShippingOrder({this.title});
  @override
  _ShippingOrderState createState() => _ShippingOrderState();
}

class _ShippingOrderState extends State<ShippingOrder> {
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserId>(context).uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("history")
            .doc(uid)
            .collection('userhistory')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> data = snapshot.data.docs;

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 80,
                            child: data[index].data()['img'] != null
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: data[index].data()['img'],
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 20,
                                  ),
                          ),
                          title: Text(data[index].data()['name']),
                          subtitle:
                              Text(data[index].data()['phone'].toString()),
                          trailing: Text(data[index].data()['status']
                              ? "complete"
                              : "Pending"),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
