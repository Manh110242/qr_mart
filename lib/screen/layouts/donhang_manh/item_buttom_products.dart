import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';

class ItemButtomProducts extends StatelessWidget {
  OrderItem orderItem1;

  ItemButtomProducts({this.orderItem1});

  @override
  Widget build(BuildContext context) {
    double a = double.parse(orderItem1.order_total);
    var tien = (a).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Thành tiền:',style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
          Text(Config().formatter.format(tien) + ' đ', style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }
}
