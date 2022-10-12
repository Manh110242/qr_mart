import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/address_bloc.dart';
import 'package:gcaeco_app/bloc/payment_bloc.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/location_manh/location_manh.dart';
import 'package:gcaeco_app/screen/screen_address.dart';
import 'package:gcaeco_app/screen/screen_login.dart';

// ignore: camel_case_types, must_be_immutable
class PayByVoucher extends StatefulWidget {
  ProductItem model;
  String code;

  PayByVoucher({this.model, this.code});

  @override
  _PayByVoucher_State createState() => _PayByVoucher_State();
}

class _PayByVoucher_State extends State<PayByVoucher> {
  AddressBloc address_bloc = new AddressBloc();
  PaymentBloc payment_bloc = new PaymentBloc();
  var payment_method = '';
  var add_item = new AddressItem();
  var productList = new Map();
  ScrollController _sc = new ScrollController();
  final TextEditingController _passLv2Controller = TextEditingController();

  @override
  void initState() {
    Const.web_api.checkLogin().then((value) async {
      if (value == '') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login_Screen()));
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    address_bloc.dispose();
    payment_bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text("Thanh toán"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                addressListBuild(),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                paymentMethodBuild(),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                ordersListBuild(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigationBar());
  }

  Widget addressListBuild() {
    address_bloc.fetchAddress();
    return StreamBuilder(
      stream: address_bloc.addressDefaultStream,
      builder: (context, AsyncSnapshot<AddressItem> snapshot) {
        return snapshot.hasData
            ? shipping(snapshot)
            : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
      },
    );
  }

  Widget shipping(AsyncSnapshot<dynamic> s) {
    add_item = s.data;
    if (s.data.id != '' && s.data.id != null) {
      return Container(
        decoration: new BoxDecoration(color: Colors.white),
        height: 120,
        child: InkWell(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Address_screen(
                        title: "Chọn địa chỉ",
                      )),
            );
            if (result != null) {
              address_bloc.setDefault(result);
              add_item = result;
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5, left: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 20,
                      color: Config().colorMain,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 5, right: 0, bottom: 0),
                      child: Text(
                        'THÔNG TIN GIAO HÀNG',
                        style: TextStyle(
                            color: Config().colorMain,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Config().colorMain,
              ),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  s.data.name_contact + ' | ' + s.data.phone,
                  style: TextStyle(fontSize: 16, color: Color(0xff5a5a5a)),
                ),
              )),
              Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(left: 15, top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 9,
                            child: Text(
                              s.data.address,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xff5a5a5a)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(Icons.chevron_right),
                          ),
                        ],
                      ))),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.only(left: 15, top: 2),
                child: Text(
                  s.data.ward_name +
                      ', ' +
                      s.data.district_name +
                      ', ' +
                      s.data.province_name,
                  style: TextStyle(fontSize: 16, color: Color(0xff5a5a5a)),
                ),
              )),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: FlatButton(
          color: Colors.orange,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DiaChiScreen(
                        title: 'Địa chỉ',
                      )),
            );
          },
          child: Text(
            'Thêm địa chỉ giao hàng',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget paymentMethodBuild() {
    payment_bloc.fetchMethod();
    return Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, left: 15),
            child: Row(
              children: [
                Icon(
                  Icons.money,
                  size: 20,
                  color: Config().colorMain,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 5, right: 0, bottom: 0),
                  child: Text(
                    'HÌNH THỨC THANH TOÁN',
                    style: TextStyle(
                        color: Config().colorMain, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Config().colorMain,
          ),
          StreamBuilder(
            stream: payment_bloc.getAllMethod,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? payment_list(snapshot)
                  : Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  Widget payment_list(AsyncSnapshot<dynamic> s) {
    for (var element in s.data) {
      payment_bloc.setdefaultMethod(element.method_key);
      payment_method = element.method_key;
      break;
    }
    return StreamBuilder(
      stream: payment_bloc.getMethodDefault,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> list = new List<Widget>();
        s.data.forEach((element) {
          if (element.method_key == "MEMBERIN") {
            list.add(
              Column(
                children: [
                  RadioListTile(
                    dense: true,
                    title: Text(
                      element.method_name,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    value: element.method_key,
                    groupValue: snapshot.data,
                    onChanged: (value) {
                      payment_method = value;
                      payment_bloc.setdefaultMethod(value);
                    },
                  ),
                  payment_method == "MEMBERIN"
                      ? FutureBuilder(
                          future: QrBloc().getVoucher(),
                          builder: (_, snap) {
                            if (snap.hasData) {
                              return Container(
                                margin: EdgeInsets.only(left: 70, right: 15),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Số dư khả dụng: "),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      snap.data['v'].toString().toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        )
                      : Container(),
                ],
              ),
            );
          } else {
            list.add(RadioListTile(
              dense: true,
              title: Text(
                element.method_name,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              value: element.method_key,
              groupValue: snapshot.data,
              onChanged: (value) {
                payment_method = value;
                payment_bloc.setdefaultMethod(value);
              },
            ));
          }
        });
        return Column(
          children: list,
        );
      },
    );
  }

  Widget ordersListBuild() {
    return Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, left: 15),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 20,
                  color: Config().colorMain,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 5, right: 0, bottom: 0),
                  child: Text(
                    'ĐƠN HÀNG CỦA BẠN',
                    style: TextStyle(
                        color: Config().colorMain, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Config().colorMain,
          ),
          Card(
            child: ListTile(
              leading: buildImage(Const().image_host +
                  widget.model.avatar_path.toString() +
                  widget.model.avatar_name.toString()),
              title: Text(
                widget.model.name,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
              ),
              subtitle: Text(
                Config().formatter.format(widget.model.price) + 'đ',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              trailing: Text('x1'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String url) {
    return Image.network(
      url,
      height: 40,
      width: 40,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 40,
          width: 40,
          color: Colors.white,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 30,
              color: Colors.grey,
            ),
          ),
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Platform.isIOS
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget bottomNavigationBar() {
    return Container(
      color: Colors.white,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Tổng thanh toán',
                ),
                Text(
                  Config().formatter.format(widget.model.price) + 'đ',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showPasslv2(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              alignment: Alignment.center,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Thanh toán",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showPasslv2(BuildContext context) {
    _passLv2Controller.text = '';
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 10, left: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Text('Nhập mật khẩu cấp 2',
                            style: TextStyle(fontSize: 15)),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                          iconSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  //autofocus: true,
                  obscureText: true,
                  controller: _passLv2Controller,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_passLv2Controller.text.isNotEmpty) {
                    payment(context, _passLv2Controller.text);
                  } else {
                    MsgDialog.showMsgDialog(
                      context,
                      "Vui lòng nhập mật khẩu cấp 2 để tiếp tục",
                      "Lỗi",
                    );
                  }
                },
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  payment(context, String pass) async {
    Map order = {
      "user_address_id": add_item.id,
      "payment_method": payment_method,
      "payment_method_child": "",
      "otp": "$pass"
    };
    Map shop = {
      "${widget.model.shopData.id}": {
        "shop_adress_id": 0,
        "transport_type": 0,
        "discount_code": widget.code,
      },
    };

    Map prd = {
      "${widget.model.shopData.id}": [
        {
          "id": widget.model.id,
          "quantity": 1,
        },
      ],
    };
    await payment_bloc.payment(context, order, shop, prd);
  }
}
