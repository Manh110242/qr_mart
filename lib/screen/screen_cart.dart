import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/cart_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:gcaeco_app/screen/screen_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../main.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget {
  List<CartItem> productList = new List<CartItem>();

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CartBloc bloc = new CartBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CartItem>()..getList();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text("Giỏ hàng"),
        ),
        body: ordersListBuild(),
        bottomNavigationBar: bottomNavigationBar());
  }

  Widget bottomNavigationBar() {
    return StreamBuilder(
      stream: bloc.totalPriceStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData ? totalPrice(snapshot) : Text('0');
      },
    );
  }

  Widget totalPrice(AsyncSnapshot<dynamic> s) {
    if (s.data > 0) {
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
                    Config().formatter.format(s.data) + 'đ',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Payment_Screen()),
                );
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
    } else {
      return Text('');
    }
  }

  Widget ordersListBuild() {
    bloc.fetchProducts();
    return StreamBuilder(
      stream: bloc.products,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? listProduct(snapshot)
            : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
      },
    );
  }

  Widget listProduct(AsyncSnapshot<dynamic> s) {
    if (s.data.length == 0) {
      return new Container(
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
              'Không có sản phẩm trong giỏ hàng.',
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
                SharedPreferences prefss =
                    await SharedPreferences.getInstance();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              page: 2,
                              prefs: prefss,
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
    } else {
      return ListView.builder(
        itemCount: s.data.length,
        itemBuilder: (_context, index) {
          var productImageUrl = s.data[index].image_url;
          return Container(
            margin: EdgeInsets.only(left: 0, top: 2, bottom: 0, right: 0),
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      child: ListTile(
                        leading: new Container(
                            child: productImageUrl != null
                                ? new Container()
                                : new Center(
                                    child: Text(
                                      'ok',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                            width: 40.0,
                            height: 40.0,
                            decoration: productImageUrl != null
                                ? new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            new NetworkImage(productImageUrl)))
                                : new BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red)),
                        title: Text(
                          s.data[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                        subtitle: Text(
                          Config().formatter.format(s.data[index].price) + 'đ',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.black26)),
                      height: 25,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: IconButton(
                                  icon: Icon(Icons.remove,
                                      color: Colors.black, size: 9),
                                  onPressed: () {
                                    bloc.cartAbatement(
                                        context, s.data[index].product_id);
                                  })),
                          Expanded(
                              child: Center(
                            child: Text(
                              s.data[index].quantity.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          )),
                          Expanded(
                              child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: Colors.black, size: 9),
                                  onPressed: () {
                                    bloc.cartAdd(s.data[index].product_id);
                                  })),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        showAlertDialog(_context, s.data[index].product_id);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  showAlertDialog(BuildContext context, int product_id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Hủy"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Xác nhận"),
      onPressed: () {
        bloc.cartRemove(product_id);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Xóa sản phẩm?"),
      content:
          Text("Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng của bạn?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
