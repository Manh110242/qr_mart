import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';

class ItemDonHangWidget extends StatelessWidget {
  OrderItem orderItem;
  String status;

  ItemDonHangWidget({this.orderItem, this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color(0xffdbbf6d),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 7,
                      child: Row(
                        children: [
                          Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: (orderItem.s_avatar_path != null ||
                                      orderItem.s_avatar_name != null)
                                  ? BoxDecoration(
                                      color: Colors.blueAccent,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          Const().image_host +
                                              orderItem.s_avatar_path +
                                              orderItem.s_avatar_name,
                                        ),
                                      ))
                                  : new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red)),
                          Flexible(
                            flex: 8,
                            child: Text(
                              orderItem.s_name.toString() == "null" ? "Đang cập nhật" : '  ${orderItem.s_name}',
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                    flex: 3,
                    child: Text(
                      (orderItem.status == '0')
                          ? 'Đã hủy'
                          : (orderItem.status == '1')
                              ? 'Chờ xác nhận'
                              : (orderItem.status == '2')
                                  ? 'Chờ lấy hàng'
                                  : (orderItem.status == '3')
                                      ? 'Đang giao'
                                      : (orderItem.status == '4')
                                          ? 'Đã giao'
                                          : status,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
