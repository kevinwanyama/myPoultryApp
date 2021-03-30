import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_poultry/Address/address.dart';
import 'package:my_poultry/models/address.dart';
import 'package:my_poultry/models/productModel.dart';
import 'package:my_poultry/widgets/productLayout.dart';

class AdminShiftOrders extends StatefulWidget {

  final String name;
  final String phone;
  final String userID;

  AdminShiftOrders({this.name, this.phone, this.userID});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 3.0,
        title: Text(
          "My Orders",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.white,),
        //     onPressed: () {
        //       SystemNavigator.pop();
        //     },
        //   ),
        // ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("admins")
            .document(widget.userID)
            .collection("orders").snapshots(),
        builder: (c, snapshot) {
          if(!snapshot.hasData)
            {
              return Center(child: Text(""),);
            }
          else
            {

              List<Product> productList = [];
              snapshot.data.documents.forEach((element) {
                Product product = Product.fromDocument(element);

                productList.add(product);
              });

              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (c, index) {
                  Product product = productList[index];

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProductLayout(context: c, product: product,),
                        FutureBuilder<QuerySnapshot>(
                          future:  Firestore.instance.collection("admins")
                              .document(widget.userID)
                              .collection("orders").document(product.productId)
                              .collection("address").getDocuments(),
                          builder: (context, snap) {
                            if(!snap.hasData)
                              {
                                return Text("Loading...");
                              }
                            else{

                              return ListView.builder(
                                itemCount: snap.data.documents.length,
                                shrinkWrap: true,
                                itemBuilder: (context, ind) {

                                  return OrderAddressCard(
                                    model: AddressModel.fromJson(snap.data.documents[index].data),
                                  );
                                },
                              );
                            }
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            }
          // return snapshot.hasData
          //     ?
          // ListView.builder(
          //       itemCount: snapshot.data.documents.length,
          //       itemBuilder: (c, index) {
          //         return FutureBuilder<QuerySnapshot>(
          //           future: Firestore.instance.collection("items")
          //               .where("shortInfo", whereIn: snapshot.data.documents[index].data[MyPoultry.productID])
          //               .getDocuments(),
          //           builder: (c, snap) {
          //             return snap.hasData
          //                 ? AdminOrderCard(
          //               userID: widget.userID,
          //               phone: widget.phone,
          //               name: widget.name,
          //               itemCount: snap.data.documents.length,
          //               data: snap.data.documents,
          //               orderID: snapshot.data.documents[index].documentID,
          //               orderBy: snapshot.data.documents[index].data["orderBy"],
          //               addressID: snapshot.data.documents[index].data["addressID"],
          //             )
          //                 : Center(child: circularProgress(),);
          //           },
          //         );
          //       },
          // )
          //     : Center(child: circularProgress(),);
        },
      ),
    );
  }
}


class OrderAddressCard extends StatelessWidget {

  final AddressModel model;

  OrderAddressCard({this.model});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.pink.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            width: screenWidth * 0.8,
            child: Table(
              children: [

                TableRow(
                    children: [
                      KeyText(msg: "Name",),
                      Text(model.name)
                    ]
                ),

                TableRow(
                    children: [
                      KeyText(msg: "Phone Number",),
                      Text(model.phoneNumber)
                    ]
                ),
                TableRow(
                    children: [
                      KeyText(msg: "Flat Number",),
                      Text(model.flatNumber)
                    ]
                ),
                TableRow(
                    children: [
                      KeyText(msg: "City",),
                      Text(model.city)
                    ]
                ),
                TableRow(
                    children: [
                      KeyText(msg: "State",),
                      Text(model.state)
                    ]
                ),
                TableRow(
                    children: [
                      KeyText(msg: "Pin Code",),
                      Text(model.pincode)
                    ]
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

