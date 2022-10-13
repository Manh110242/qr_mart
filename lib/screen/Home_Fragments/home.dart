import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gcaeco_app/bloc/banner_bloc.dart';
import 'package:gcaeco_app/bloc/bloc_home_new.dart';
import 'package:gcaeco_app/bloc/category_bloc.dart';
import 'package:gcaeco_app/bloc/follow_prd.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/category_screen.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/layouts/CountdownTimer.dart';
import 'package:gcaeco_app/screen/layouts/products/cart_header.dart';
import 'package:gcaeco_app/screen/layouts/products/item_category.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';
import 'package:gcaeco_app/screen/layouts/products/item_search.dart';
import 'package:gcaeco_app/screen/layouts/webview/WebViewContainer.dart';
import 'package:gcaeco_app/screen/qrcode/payment_account.dart';
import 'package:gcaeco_app/screen/qrcode/payment_account_service.dart';
import 'package:gcaeco_app/screen/qrcode/payment_order.dart';
import 'package:gcaeco_app/screen/screen_cart.dart';
import 'package:gcaeco_app/screen/screen_flash_sale.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:gcaeco_app/screen/screen_search.dart';
import 'package:gcaeco_app/screen/slider/slider_home_main.dart';
import 'package:gcaeco_app/screen/wallet/add_voucher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:gcaeco_app/screen/prd_by_voucher.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences prefs;

  HomePage({this.prefs});

  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CategoryBloc category_bloc;
  ProductBloc product_bloc;
  QrBloc qr_bloc;
  BannerBloc banner_bloc;

  BlocHomeNew blocHome = new BlocHomeNew();
  ScrollController scrollController = new ScrollController();
  final List<String> imgList = [];
  YoutubePlayerController sc;
  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 + 43200000;

  @override
  initState() {
    super.initState();
    category_bloc = new CategoryBloc();
    product_bloc = new ProductBloc();
    qr_bloc = new QrBloc();
    banner_bloc = new BannerBloc();
    banner_bloc.getBannerPopup('12', '1', '').then((value) async {
      //print(value);
      if(value['data'] != null){
        if (value['data'].length > 0) {
          Future.delayed(Duration(seconds: 1))
              .then((delay) => _showAds(context, value));
        }
      }
    });
  }

  getvideo(String url) {
    sc = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url),
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }

  Future<void> urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Lỗi $url';
    }
  }

  void _showAds(BuildContext context, dynamic data) async {
    if (data['type'] == "video") {
      await getvideo(data['data'][0]['link']);
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        content: Stack(
          alignment: Alignment.center,
          children: [
            data['type'] == 'video'
                ? YoutubePlayer(
                    controller: sc,
                  )
                : Image.network(
                    data['data'][0]['src'],
                    fit: BoxFit.cover,
                  ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    category_bloc.dispose();
    product_bloc.dispose();
    qr_bloc.dispose();
    banner_bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Config().colorMain,
        leading: Padding(
            padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewContainer(
                              '${Const().domain}/', '$appName Company')));
                },
                child: Image.asset(
                  "assets/images/Group 8220.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ))),
        title: Padding(
          padding: const EdgeInsets.all(0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Search_Screen(
                            keySearch: '',
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Tìm kiếm sản phẩm...",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Const.web_api.checkLogin().then((value) async {
                      if (value != '1') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Screen()));
                      } else {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Cart()));
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment(1, -1),
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      CartHeader()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: main(),
    );
  }

  Widget main() {
    return SingleChildScrollView(
        child: Container(
      color: Colors.transparent,
      child: Column(
        children: [
          actions(),
          SliderHome1(),
          charity(),
          Divider(),
          category_menu(),
          flashSale(),
          product_hot(),
          category_product(),
          search_hot(),
          Padding(
            padding: EdgeInsets.only(bottom: 90),
          )
        ],
      ),
    ));
  }

  Widget actions() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Config().colorMain,
              // borderRadius: new BorderRadius.only(
              // bottomLeft: const Radius.circular(30.0),
              // bottomRight: const Radius.circular(40.0),
              // )
              borderRadius: BorderRadius.vertical(
                  bottom: new Radius.elliptical(
                      MediaQuery.of(context).size.width, 50.0))),
          height: 50,
        ),
        Center(
            child: Container(
          width: 4 * MediaQuery.of(context).size.width / 5,
          margin: EdgeInsets.only(top: 5, left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Const.web_api.checkLogin().then((value) async {
                      if (value == '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Screen()));
                      } else {
                        _scanVoucher(context);
                      }
                    });
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/qr-code-scan.png',
                          width: 30,
                          height: 30,
                          color: Config().colorMain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            'QR-Voucher',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff5E3900)),
                          ),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Const.web_api.checkLogin().then((value) async {
                      if (value == '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Screen()));
                      } else {
                        _scan(context);
                      }
                    });
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/qr-code.png',
                          width: 30,
                          height: 30,
                          color: Config().colorMain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text('Chuyển V',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff5E3900))),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Const.web_api.checkLogin().then((value) async {
                      if (value == '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Screen()));
                      } else {
                        _scanService(context);
                      }
                    });
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Group 596.png',
                          width: 30,
                          height: 30,
                          color: Config().colorMain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text('QR-DV',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff5e3900))),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Const.web_api.checkLogin().then((value) async {
                      if (value == '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login_Screen()));
                      } else {
                        _scanOrder(context);
                      }
                    });
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Group.png',
                          width: 30,
                          height: 30,
                          color: Config().colorMain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text('Mã QR',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff5E3900))),
                        )
                      ]),
                ),
              )
            ],
          ),
        ))
      ],
    );
  }

  Widget charity() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _coppy(context);
              showToast("Copy link giới thiệu thành công", context,
                  Colors.yellow, Icons.check_circle);
            },
            child: Row(
              children: [
                Text(
                  'OCOP AFFILIATE  ',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.copy,
                  color: Colors.grey,
                  size: 17,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewContainer(
                          '${Const().domain}/site/charity.html',
                          'Ocop Charity'.toUpperCase())));
            },
            child: FutureBuilder(
                future: category_bloc.getCharity(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ocop CHARITY'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          snapshot.data,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ocop CHARITY'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "0 đ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    );
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget category_menu() {
    return FutureBuilder(
        future: category_bloc.getCategoryShowHome(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                shrinkWrap: true,
                childAspectRatio: 1,
                crossAxisCount: 2,
                children: List.generate(snapshot.data.length, (i) {
                  return displayCategoryItem(snapshot.data[i]);
                }),
              ),
            );
          } else {
            return Center();
          }
        });
  }

  Widget product_hot() {
    return FutureBuilder(
      future: product_bloc.getProductHot(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Color(0xff2F80ED),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Sản phẩm hot",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    height: 290.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          displayProductItem(
                        item: snapshot.data[index],
                        check: false,
                      ),
                      itemCount: snapshot.data.length,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Center();
        }
      },
    );
  }

  Widget category_product() {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: banner_bloc.getBanner('10', '20', ''),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            int banner_count = snap.data.length;
            return FutureBuilder(
              future: product_bloc.getProductByListCategoryHome(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: List.generate(
                        snapshot.data.length,
                        (index) => Container(
                                child: SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 20.0, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17.0,
                                                color: Colors.orange),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          Category_screen(
                                                            category_id:
                                                                snapshot
                                                                    .data[index]
                                                                    .id,
                                                            title: snapshot
                                                                .data[index]
                                                                .name,
                                                            banner: snapshot.data[index].bgr_path !=
                                                                    null
                                                                ? Const()
                                                                        .image_host +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .bgr_path +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .bgr_name
                                                                : '',
                                                            limit: 12,
                                                          )));
                                            },
                                            child: Text('Xem thêm >',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54)),
                                          )
                                        ],
                                      ),
                                    ),
                                    GridView.count(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: MediaQuery.of(context)
                                                    .size
                                                    .width >
                                                MediaQuery.of(context)
                                                    .size
                                                    .height
                                            ? 0.60
                                            : 0.65,
                                        crossAxisCount:
                                            ((MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            170) -
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                170)
                                                            .floor()) >
                                                    0.8
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        170)
                                                    .round()
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        170)
                                                    .floor(),
                                        primary: false,
                                        children: List.generate(
                                          snapshot.data[index].products.length,
                                          (index1) => ItemProductGrid(snapshot
                                              .data[index].products[index1]),
                                        )),
                                    banner_count > index
                                        ? InkWell(
                                            onTap: () {
                                              if (snap.data[index].link !=
                                                      null &&
                                                  snap.data[index].link !=
                                                      "null" &&
                                                  snap.data[index].link != "") {
                                                if (snap.data[index].link
                                                    .startsWith(
                                                        Const().domain)) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebViewContainer(
                                                                  snap
                                                                      .data[
                                                                          index]
                                                                      .link,
                                                                  "Danh mục")));
                                                } else {
                                                  urlLauncher(
                                                      snap.data[index].link);
                                                }
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: Image.network(
                                                  snap.data[index].src),
                                            ),
                                          )
                                        : Text(''),
                                  ],
                                ),
                              ),
                            ))),
                  );
                } else {
                  return Center();
                }
              },
            );
          } else {
            return Text('');
          }
        });
  }

  Widget search_hot() {
    return FutureBuilder(
      future: product_bloc.getSearchtHot(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Xu hướng tìm kiếm",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    height: 200.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          displaySearchItem(snapshot.data[index]),
                      itemCount: snapshot.data.length,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Center();
        }
      },
    );
  }

  Future _coppy(context) async {
    var user_id = await Const.web_api.getUserId();
    Clipboard.setData(ClipboardData(
        text: '${Const().domain}/dang-ky.html?user_id=' + user_id));
  }

  Future _scanVoucher(context) async {
    await Permission.camera.request();
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);

    if (barcode != "-1" && !barcode.startsWith(Const().domain)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrdByVoucher(
            code: barcode,
          ),
        ),
      );
    }
  }

  Future _scan(context) async {
    await Permission.camera.request();
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);

    if (barcode != "-1") {
      Map infoToken = await qr_bloc.getInfoToken(barcode);
      if (infoToken['code'] == 200) {
        if (infoToken['type'] == 'user') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentAccount(barcode)));
        } else {
          MsgDialog.showMsgDialog(context, 'Mã QR không hợp lệ', 'Lỗi!');
        }
      } else {
        MsgDialog.showMsgDialog(context, infoToken['errors'], 'Lỗi!');
      }
    }
  }

  Future _scanService(context) async {
    await Permission.camera.request();
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    if (barcode != "-1") {
      Map infoToken = await qr_bloc.getInfoToken(barcode);
      if (infoToken['code'] == 200) {
        if (infoToken['type'] == 'user_service') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentAccountService(barcode)));
        } else {
          MsgDialog.showMsgDialog(context, 'Mã QR không hợp lệ', 'Lỗi!');
        }
      } else {
        MsgDialog.showMsgDialog(context, infoToken['errors'], 'Lỗi!');
      }
    }
  }

  Future _scanOrder(context) async {
    await Permission.camera.request();
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    if (barcode != "-1") {
      Map orderItem = await qr_bloc.getOrder(barcode);
      if (orderItem['code'] == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PaymentOrder(barcode, orderItem['order'])));
      } else {
        MsgDialog.showMsgDialog(context, orderItem['errors'], 'Lỗi!');
      }
    }
  }

  Widget flashSale() {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: blocHome.getFlashSale(1),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.products != null &&
                  snapshot.data.products.length > 0
              ? Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: size.width,
                      color: Color(0xffd9e4f4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/flas.png"),
                          SizedBox(
                            width: 10,
                          ),
                          CountdownTimerItem(snapshot.data.enddate, 15),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 0.2,
                      color: Colors.white,
                    ),
                    Container(
                      color: Color(0xffd9e4f4),
                      height: 310.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) =>
                            displayProductItem(
                          item: snapshot.data.products[index],
                          check: true,
                        ),
                        itemCount: snapshot.data.products.length,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ScreenFlashSale(snapshot.data)));
                      },
                      child: Container(
                        color: Color(0xffd9e4f4),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Xem tất cả',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black)),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }
}
