import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_poultry/Config/config.dart';
import 'package:my_poultry/models/address.dart';
import 'package:my_poultry/models/productModel.dart';
import 'package:my_poultry/pages/home.dart';
import 'package:my_poultry/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class PaymentPage extends StatefulWidget {

  final String addressId;
  final int totalAmount;
  final Product product;
  final AddressModel model;

  PaymentPage({Key key, this.model, this.product, this.totalAmount, this.addressId}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {

  bool loading = false;

  //
  // addOrderDetails() {
  //   writeOrderDetailsForUser({
  //     MyPoultry.addressID: widget.addressId,
  //     MyPoultry.totalAmount: widget.totalAmount,
  //     "orderBy": MyPoultry.sharedPreferences.getString(MyPoultry.userUID),
  //     MyPoultry.productID: MyPoultry.sharedPreferences.getStringList(MyPoultry.userCartList),
  //     MyPoultry.paymentDetails: "Cash on delivery",
  //     MyPoultry.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
  //     MyPoultry.isSuccess: true,
  //   });
  //
  //   writeOrderDetailsForAdmin({
  //     MimiShop.addressID: widget.addressId,
  //     MimiShop.totalAmount: widget.totalAmount,
  //     "orderBy": MimiShop.sharedPreferences.getString(MimiShop.userUID),
  //     MimiShop.productID: MimiShop.sharedPreferences.getStringList(MimiShop.userCartList),
  //     MimiShop.paymentDetails: "Cash on delivery",
  //     MimiShop.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
  //     MimiShop.isSuccess: true,
  //   }).whenComplete(() => {
  //     emptyCartNow()
  //   });
  // }

  // emptyCartNow() {
  //
  //   MimiShop.sharedPreferences.setStringList(MimiShop.userCartList, ["garbageValue"]);
  //   List tempList = MimiShop.sharedPreferences.getStringList(MimiShop.userCartList);
  //
  //   Firestore.instance.collection("users").document(MimiShop.sharedPreferences.getString(MimiShop.userUID))
  //       .updateData({
  //     MimiShop.userCartList: tempList,
  //   }).then((value) {
  //     MimiShop.sharedPreferences.setStringList(MimiShop.userCartList, tempList);
  //    // Provider.of<CartItemCounter>(context, listen: false).displayResult();
  //   });
  //
  //   Fluttertoast.showToast(msg: "Congratulations! Your order has been placed successfully");
  //
  //   Route route = MaterialPageRoute(builder: (context) => StoreHome());
  //   Navigator.pushReplacement(context, route);
  // }

  // Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
  //   await MimiShop.firestore.collection(MimiShop.collectionUser)
  //       .document(MimiShop.sharedPreferences.getString(MimiShop.userUID))
  //       .collection(MimiShop.collectionOrders)
  //       .document(MimiShop.sharedPreferences.getString(MimiShop.userUID) + data['orderTime'])
  //       .setData(data);
  // }
  //
  // Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
  //   await MimiShop.firestore
  //       .collection(MimiShop.collectionOrders)
  //       .document(MimiShop.sharedPreferences.getString(MimiShop.userUID) + data['orderTime'])
  //       .setData(data);
  // }

  addOrderDetails() async {
    setState(() {
      loading = true;
    });

    final model = AddressModel(
      name: widget.model.name,
      state: widget.model.state,
      pincode: widget.model.pincode,
      phoneNumber: widget.model.phoneNumber,
      flatNumber: widget.model.flatNumber,
      city: widget.model.city,
    ).toJson();

    await Firestore.instance.collection("admins")
        .document(widget.product.publisherID).collection("orders")
        .document(widget.product.productId).setData(
        {
          "shortInfo": widget.product.shortInfo,
          "longDescription": widget.product.longDescription,
          "price": widget.product.price,
          "publishedDate": widget.product.publishedDate,
          "status": "available",
          "category": widget.product.category,
          "productId": widget.product.productId,
          "thumbnailUrl": widget.product.thumbnailUrl,
          "title": widget.product.title,
          "publisher": widget.product.publisher,
          "publisherID": widget.product.publisherID,
          "phone": widget.product.phone,
          "city": widget.product.city,
          "country": widget.product.country,
        }).then((value) async {
        await Firestore.instance.collection("admins")
            .document(widget.product.publisherID).collection("orders")
            .document(widget.product.productId).collection("address")
            .add(model).then((value) => Fluttertoast.showToast(msg: "Ordered Successfully"));
    });


    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("assets/cash.png"),
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.pink,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.pinkAccent,
                onPressed: addOrderDetails,
                child: Text("Place Order", style: TextStyle(fontSize: 30.0),),
              ),
              loading ? circularProgress() : Text("")
            ],
          ),
        ),
      ),
    );
  }
}
