import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/model/payment/voucherItem.dart';
import 'package:gcaeco_app/model/payment/voucherList.dart';
import 'package:gcaeco_app/model/paymentItem.dart';
import 'package:gcaeco_app/model/shopItem.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/payment_success.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentBloc {
  List<PaymentItem> methodList = new List<PaymentItem>();
  List<VoucherList> voucherList = new List<VoucherList>();
  List<ShopItem> shopProductList = new List<ShopItem>();
  int totalPrice = 0;

  StreamController _totalPricePayment = new StreamController<int>();
  Stream get totalPricePayment => _totalPricePayment.stream;

  final _ProductShopFetcher = BehaviorSubject<dynamic>();
  Stream<dynamic> get allProductsShop => _ProductShopFetcher.stream;

  final _allMethod = BehaviorSubject<dynamic>();

  Stream<dynamic> get getAllMethod => _allMethod.stream;

  final _mothodDefaultValue = BehaviorSubject<dynamic>();

  Stream<dynamic> get getMethodDefault => _mothodDefaultValue.stream;

  final _voucherValue = BehaviorSubject<dynamic>();

  Stream<dynamic> get getVoucher => _voucherValue.stream;

  final TextEditingController _voucherController = TextEditingController();

  fetchProductsShop() async {
    shopProductList = [];
    totalPrice = 0;
    var shopProduct = new Map();
    var shopName = new Map();
    var token = await Const.web_api.getToken();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String cart = prefs.getString('cart');
    if(cart != null){
      final List<CartItem> decodedData = CartItem.decode(cart);
      List product_ids = new List();
      Map<String, List> request_body = new Map<String, List>();
      Map<int, int> quantity_list = new Map<int, int>();
      decodedData.forEach((element) {
        product_ids.add(element.product_id);
        quantity_list[element.product_id] = element.quantity;
      });
      request_body['id'] = product_ids;
      if(!product_ids.isEmpty){
        var response = await Const.web_api
            .postAsync("/app/product/get-products", token, request_body);
        for (var prd in response['data']) {
          List<CartItem> cartProducts = new List<CartItem>();
          var id = prd['id'].toString();
          totalPrice += prd['price'] * quantity_list[int.parse(id)];
          var cart_item = CartItem(
              product_id: int.parse(id),
              quantity: quantity_list[int.parse(id)],
              name: prd['name'],
              image_url: Const().image_host +
                  prd['avatar_path'] +
                  prd['avatar_name'],
              price: prd['price']);
          if(shopProduct[prd['shop_id']] != null){
            cartProducts = shopProduct[prd['shop_id']];
          }
          cartProducts.add(cart_item);
          shopProduct[prd['shop_id']] = cartProducts;
          shopName[prd['shop_id']] = {'name':prd['shop']['name'],'avatar':Const().image_host+prd['shop']['avatar_path']+prd['shop']['avatar_name']};;
        }
        shopProduct.forEach((key, value) {
          var shop_item = ShopItem(
              shop_id: key,
              shop_name: shopName[key]['name'],
              avatar: shopName[key]['avatar'],
              products: value
          );
          shopProductList.add(shop_item);
        });
      }
    }
    _totalPricePayment.sink.add(totalPrice);
    _ProductShopFetcher.sink.add(shopProductList);
  }


  payment(context,order, shops, products) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var token = await Const.web_api.getToken();
    var request_body = new Map();

    request_body['Order'] = order;
    request_body['Products'] = products;
    request_body['Shop'] = shops;

    LoadingDialog.showLoadingDialog(context, "Đang tải...");
    var response = await Const.web_api
        .postAsync("/app/shopping/add-order", token, request_body);
    LoadingDialog.hideLoadingDialog(context);

    if(response != null){
      if (response['code'] == 0) {
        MsgDialog.showMsgDialog(context, response['error'], 'Thanh toán không thành công');
      }else{
        prefs.remove('cart');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentSuccess()
            ),
            ModalRoute.withName("/")
        );
      }
    }else{
      MsgDialog.showMsgDialog(context, "Lỗi kết nối", 'Lỗi!');
    }

  }

  setdefaultMethod(value) {
    _mothodDefaultValue.sink.add(value);
  }

  fetchMethod() async {
    methodList = new List<PaymentItem>();
    var token = await Const.web_api.getToken();
    var response = await Const.web_api
        .getAsync("/app/shopping/get-option-payments", token);
    response['data'].forEach((k, v) {
      var method_item = PaymentItem(method_key: k, method_name: v);
      methodList.add(method_item);
    });
    _allMethod.sink.add(methodList);
  }

  discount(BuildContext context, shop_id, shop_name, product_ids) {
    _voucherController.text = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(shop_name + ' Voucher',
                              style: TextStyle(fontSize: 15)),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                          iconSize: 14,
                          color: Colors.red,
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only( right: 15),
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            _voucherController.text = await _scanVoucher();
                          },
                          icon: Icon(CupertinoIcons.qrcode_viewfinder),
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: TextField(
                              // autofocus: true,
                              controller: _voucherController,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Nhập mã giảm giá",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        RaisedButton(
                          onPressed: () {
                            String code = _voucherController.text;
                            checkVoucher(context,shop_id, code, product_ids);
                          },
                          child: const Text('Áp Dụng',
                              style: TextStyle(fontSize: 15)),
                        )
                      ],
                    ),
                ),
                Divider(),
                StreamBuilder(
                  stream: getVoucher,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.hasData
                        ? ListVoucher(snapshot, shop_id)
                        : Align();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future _scanVoucher() async {
    await Permission.camera.request();
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    if (barcode != "-1" && !barcode.startsWith(Const().domain)) {
      return barcode;
    }
    return '';
  }
  Widget ListVoucher(AsyncSnapshot<dynamic> s, shop_id) {
    return new Expanded(
        child: ListView.builder(
      itemCount: s.data.length,
      itemBuilder: (_, index) {
        if (s.data[index].shop_id == shop_id) {
          return ListTile(
            title: Text(s.data[index].items.code),
            trailing: IconButton(
              onPressed: () {
                deleteVoucher(shop_id, s.data[index].items.code);
              },
              icon: Icon(Icons.delete),
            ),
          );
        } else {
          return Text('');
        }
      },
    ));
  }

  checkVoucher(context,shop_id, discount_code, products_ids) async {
    bool check = true;
    var token = await Const.web_api.getToken();
    var request_body = new Map();
    var prd_ids = new List();
    products_ids.forEach((element) {
      prd_ids.add(element.product_id);
    });
    request_body['products'] = prd_ids;
    request_body['discount_code'] = discount_code;
    request_body['shop_id'] = shop_id;
    var response = await Const.web_api
        .postAsync("/app/shopping/check-discount-code", token, request_body);
    if (response['code'] == 1) {
      voucherList.forEach((element) {
        if (element.shop_id == shop_id) {
          check = false;
        }
      });
      if (check) {
        voucherList.add(VoucherList(
            shop_id: shop_id,
            items: VoucherItem(
              code: response['data']['id'],
              shop_id: response['data']['shop_id'],
              type_discount: response['data']['type_discount'],
            )));
        _voucherValue.sink.add(voucherList);
      }
    }else{
      MsgDialog.showMsgDialog(context, response['error'], 'Thông báo');
    }
  }

  deleteVoucher(shop_id, code) {
    voucherList.removeWhere((item) => item.items.code == code);
    _voucherValue.sink.add(voucherList);
  }

  @override
  dispose() {
    _mothodDefaultValue.close();
    _mothodDefaultValue.close();
    _voucherValue.close();
    _totalPricePayment.close();
    _ProductShopFetcher.close();
  }
}
