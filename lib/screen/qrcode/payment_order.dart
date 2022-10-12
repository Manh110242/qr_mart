import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/qrcode/payment_account_success.dart';
import 'package:gcaeco_app/screen/qrcode/payment_order_success.dart';

class PaymentOrder extends StatefulWidget {
  String token;
  OrderItem orderItem;

  PaymentOrder(this.token, this.orderItem);

  @override
  _PaymentOrder createState() => _PaymentOrder(this);
}

class _PaymentOrder extends State<PaymentOrder> {
  PaymentOrder paymentOrder;

  _PaymentOrder(this.paymentOrder);

  final TextEditingController _passController = TextEditingController();
  var bloc;

  @override
  initState() {
    super.initState();
    bloc = new QrBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Config().colorMain,
          title: Text("Thanh toán đơn hàng"),
        ),
        body: Display());
  }

  Widget Display() {
    return Container(
        padding: EdgeInsets.only(top: 25, left: 15, right: 15),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Config().colorMain, Colors.green])),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Thông tin người chuyển
              Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    'Thông tin nguồn thanh toán',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                    stream: bloc.passStream,
                    builder: (_context, snapshot) => TextField(
                      obscureText: true,
                      controller: _passController,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      decoration: new InputDecoration(
                          hintText: "Nhập mật khẩu cấp 2",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.red)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.white)),
                          errorStyle: TextStyle(color: Colors.orange),
                          errorText: snapshot.hasError ? snapshot.error : null),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Số dư khả dụng',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    FutureBuilder(
                        future: bloc.getVoucher(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if(snapshot.hasData){
                            if (snapshot.data['code'] == 200) {
                              return Text(snapshot.data['v'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white));
                            }else{
                              return Text('Đang cập nhật',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white));
                            }
                          }
                          return Center(child: CircularProgressIndicator());

                        }),
                  ],
                ),
              ),

              // Thông tin giao dịch
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    Icon(
                      Icons.money,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Thông tin đơn hàng',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ID'),
                          Text(paymentOrder.orderItem.id.toString())
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Key'), Text(paymentOrder.orderItem.key)],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng tiền'),
                          Text(paymentOrder.orderItem.order_total + ' đ')
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Hình thức thanh toán'), Text('QRCode')],
                    ),
                  ],
                ),
              ),
              ButtonTheme(
                  minWidth: double.infinity,
                  child: FlatButton(
                    color: Config().colorMain,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(12.0),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      payment();
                    },
                    child: Text(
                      "Thanh toán",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )),
            ],
          ),
        )
    );
  }

  payment() async {
    String pass = _passController.text;
    if (bloc.isValidPassInfo(pass)) {
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      var res = await bloc.paymentOrder(pass, paymentOrder.token);
      if (res != null) {
        LoadingDialog.hideLoadingDialog(context);
        if (res['code'] == 200) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentOrderSuccess(res['order'])));
        } else {
          MsgDialog.showMsgDialog(context, res['errors'], 'Lỗi!');
        }
      } else {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, 'Kết nối server thất bại', 'Lỗi!');
      }
    }
  }
}
