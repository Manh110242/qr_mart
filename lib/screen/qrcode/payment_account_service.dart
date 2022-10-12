import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/qrcode/payment_account_success.dart';

import '../../main.dart';

class PaymentAccountService extends StatefulWidget {
  String token;

  PaymentAccountService(this.token);

  @override
  _PaymentAccountServiceState createState() =>
      _PaymentAccountServiceState(this);
}

class _PaymentAccountServiceState extends State<PaymentAccountService> {
  PaymentAccountService paymentAccount;

  _PaymentAccountServiceState(this.paymentAccount);

  final TextEditingController _moneyController = TextEditingController();
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
          title: Text("Thông tin thanh toán"),
        ),
        body: Display());
  }

  Widget Display() {
    bloc.getVoucher();
    return SingleChildScrollView(
      child: Container(
          height: 1000,
          padding: EdgeInsets.only(top: 25, left: 15, right: 15),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Config().colorMain, Colors.green])),
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
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.red)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data['code'] == 200) {
                              return Text(snapshot.data['v'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white));
                            } else {
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
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.money,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                        ),
                        Text(
                          'Thông tin giao dịch',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      '1 OV = 1000 VND',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: StreamBuilder(
                    stream: bloc.moneyStream,
                    builder: (_context, snap) => TextField(
                      controller: _moneyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      decoration: new InputDecoration(
                        hintText: "Nhập số VND cần chuyển ",
                        hintStyle: TextStyle(color: Colors.black87),
                        filled: true,
                        suffixText: "VND",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 1, color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.red)),
                        errorStyle: TextStyle(color: Colors.orange),
                        errorText: snap.hasError ? snap.error : null,
                      ),
                    ),
                  )),
              FutureBuilder(
                future: bloc.getInfoToken(paymentAccount.token),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['code'] == 200) {
                      return Container(
                        margin: EdgeInsets.only(top: 0, bottom: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 15, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Text(
                                      'Thanh toán cho',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Text(
                                      snapshot.data['shop']['name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Divider(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Text(
                                      'Thưởng tiêu dùng',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Text(
                                      snapshot.data['product_service'] !=
                                                  null &&
                                              snapshot.data['product_service']
                                                      ['affiliate_safe'] !=
                                                  null
                                          ? snapshot.data['product_service']
                                                  ['affiliate_safe'] +
                                              '%'
                                          : '0%',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Divider(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Text(
                                      '$appName Charity',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Text(
                                      snapshot.data['product_service'] !=
                                                  null &&
                                              snapshot.data['product_service']
                                                      ['affiliate_charity'] !=
                                                  null
                                          ? snapshot.data['product_service']
                                                  ['affiliate_charity'] +
                                              '%'
                                          : '0%',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Divider(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Text(
                                      'Phí chuyển tiền',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Text(
                                      snapshot.data['fee_tranpost'] != null
                                          ? snapshot.data['fee_tranpost']
                                              ['value_text']
                                          : '0đ',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                          margin: EdgeInsets.only(top: 10, bottom: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(snapshot.data['errors']),
                          ));
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),

              ButtonTheme(
                  minWidth: double.infinity,
                  child: FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(12.0),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {
                      payment();
                    },
                    child: Text(
                      "Xác nhận",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )),
            ],
          )),
    );
  }

  payment() async {
    String pass = _passController.text;
    String money = _moneyController.text;
    if (bloc.isValidPassInfo(pass) && bloc.isValidMoneyInfo(money)) {
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      var res = await bloc.payment(pass, money, paymentAccount.token);
      if (res != null) {
        LoadingDialog.hideLoadingDialog(context);
        if (res == 'success') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentAccountSuccess()));
        } else {
          MsgDialog.showMsgDialog(context, res, 'Lỗi!');
        }
      } else {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, 'Kết nối server thất bại', 'Lỗi!');
      }
    }
  }
}
