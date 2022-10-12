import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/cart_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:gcaeco_app/screen/screen_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

// ignore: must_be_immutable
class PaymentOrderSuccess extends StatelessWidget {
  OrderItem orderItem;

  PaymentOrderSuccess(this.orderItem);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Config().colorMain,
          title: Text("Thanh toán thành công"),
          leading: Text(''),
        ),
        body: display(context),
      ),
      onWillPop: () {},
    );
  }

  Widget display(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Center(
          child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_shopping_cart,
              size: 50,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Text(
            'Thanh toán đơn hàng thành công',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(3),
          ),
          Text('Lướt $appName, mua sắm ngay đây!'),
          Padding(
            padding: EdgeInsets.all(7),
          ),
          FlatButton(
            color: Colors.orange,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            page: 2,
                            prefs: prefs,
                          )),
                  ModalRoute.withName("/"));
            },
            child: Text('Mua sắm ngay',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.orange, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5)),
          )
        ],
      )),
    );
  }
}
