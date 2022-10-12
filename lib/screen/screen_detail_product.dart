import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/bloc/create_acount_chat.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/MarqueeWidget.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/general.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/Product_API.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/model/detail_product.dart';
import 'package:gcaeco_app/screen/Tabs_In_Detail_Product/tab_Detail_Product.dart';
import 'package:gcaeco_app/screen/Tabs_In_Detail_Product/tab_Evaluate_Product.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/layouts/products/cart_header.dart';
import 'package:gcaeco_app/screen/screen_cart.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:gcaeco_app/screen/send_comment.dart';
import 'package:gcaeco_app/screen/shop_detail.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'chat_room.dart';
import 'package:provider/provider.dart';

class Detail_Product extends StatefulWidget {
  final currentUserNo;

  // ignore: non_constant_identifier_names
  String id_product;

  Detail_Product(this.id_product, this.currentUserNo);

  @override
  _Detail_Product_State createState() => _Detail_Product_State();
}

class _Detail_Product_State extends State<Detail_Product> {
  var product_bloc;

  Future<void> _addToCart() async {
    Const.web_api.checkLogin().then((value) async {
      if (value == '') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login_Screen()));
      } else {
        var id_prd = int.parse(widget.id_product);
        var cart = new CartItem();
        cart.addToCart(CartItem(product_id: id_prd, quantity: 1));
        context.read<CartItem>()..getList();
        showToast("Thêm vào giỏ hàng thành công", context, Colors.yellow,
            Icons.check_circle);
      }
    });
  }

  Future<void> _buyNow() async {
    Const.web_api.checkLogin().then((value) async {
      if (value == '') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login_Screen()));
      } else {
        var id_prd = int.parse(widget.id_product);
        var cart = new CartItem();
        cart.addToCart(CartItem(product_id: id_prd, quantity: 1));
        context.read<CartItem>()..getList();
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Cart()));
      }
    });
  }

  List<Widget> tabs;
  Config config = new Config();
  Fetch_Data fetch_data_detail_product =
      new Fetch_Data("/app/product/data-page-detail-product", {});
  Future detailproductFuture;
  bool canCallDetail = true;
  bool canCallDetailInTabView = true;
  String linkvideo;

  YoutubePlayerController sc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product_bloc = new ProductBloc();
    canCallDetail = true;
    canCallDetailInTabView = true;
    detailproductFuture =
        fetch_data_detail_product.getDetailProduct(widget.id_product);
    var tabDetail = Tabbar("CHI TIẾT SẢN PHẨM");
    var tabProducer = Tabbar("NHÀ SẢN XUẤT");
    var tabVideo = Tabbar("VIDEO");
    var tabEvaluate = Tabbar("ĐÁNH GIÁ");
    tabs = new List();
    tabs.add(tabDetail);
    tabs.add(tabProducer);
    tabs.add(tabVideo);
    tabs.add(tabEvaluate);
  }

  getvideo() {
    if (linkvideo != null) {
      if (linkvideo != '') {
        sc = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(linkvideo),
          flags: YoutubePlayerFlags(
            autoPlay: false,
          ),
        );
      } else {
        linkvideo = null;
      }
    }
  }

  Widget Tabbar(String name) {
    return Container(
      height: 50,
      child: Center(
        child: Text(name,
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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

  DataModel _cachedModel;

  DataModel getModel(phone) {
    _cachedModel ??= DataModel(phone);
    return _cachedModel;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: canCallDetail ? detailproductFuture : null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DetailProduct detailproduct = snapshot.data['prd'];
            linkvideo = snapshot.data['videos'];
            if (detailproduct.rate == "null") {
              detailproduct.rate = "0";
            }
            canCallDetail = false;
            return DefaultTabController(
              length: tabs.length,
              child: Body(detailproduct, snapshot),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  _getTabBar() {
    var tabControllerAppBar = Container(
      color: Color(0xff5DA2FE),
      child: new TabBar(
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: tabs,
        indicator: BoxDecoration(
          color: Color(0xff2F80ED),
          boxShadow: const [BoxShadow(color: Color(0x2F80ED), blurRadius: 6.0)],
        ),
      ),
    );

    return tabControllerAppBar;
  }

  List<Product_Api> products = [];
  String category = "";

  _getTabBarView(String shopName, snapshot) {
    getvideo();
    var tabControllerBody = TabBarView(children: [
      SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Tab_Detail_Product(
            detailProduct: snapshot.data['prd'],
            name_category: snapshot.data['prd'].category_id,
          ),
        ),
      ),
      SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: new Text(shopName),
            )
          ],
        ),
      ),
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text("VIDEO SẢN PHẨM"),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: linkvideo != null
                  ? YoutubePlayer(
                      controller: sc,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(child: Text('Chưa có video sản phẩm')),
                    ),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Tab_Evaluate_Product(
            producId: widget.id_product,
          ),
        ),
      ),
    ]);
    return tabControllerBody;
  }

  Widget buildImage(image) {
    return Container(
      child: Image.network(
        Const().image_host + image.path + image.name,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 70,
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
      ),
    );
  }

  Body(DetailProduct detailproduct, snapshot) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config().colorMain,
        child: Icon(
          Icons.message,
        ),
        onPressed: () => openChat(detailproduct),
      ),
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: MarqueeWidget(
          child: Text(
            detailproduct.name,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          direction: Axis.horizontal,
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
                      if (value == '') {
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: _addToCart,
              child: Container(
                width: screenWidth / 2,
                alignment: Alignment.center,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add_shopping_cart, color: Color(0xff2F80ED)),
                    Text("Thêm vào giỏ hàng",
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _buyNow,
              child: Container(
                width: screenWidth / 2,
                alignment: Alignment.center,
                color: Color(0xff2F80ED),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("MUA NGAY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          height: MediaQuery.of(context).size.height * 0.3,
                          viewportFraction: 1.0,
                        ),
                        items: List.generate(
                            snapshot.data['images'].length,
                            (index) =>
                                buildImage(snapshot.data["images"][index])),
                      ),
                      int.parse(detailproduct.price) ==
                                  int.parse(detailproduct.price_market) ||
                              General().converSale(
                                      int.parse(detailproduct.price),
                                      int.parse(detailproduct.price_market)) ==
                                  0
                          ? Text('')
                          : Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 25,
                                width: 55.0,
                                decoration: BoxDecoration(
                                    color: Color(0xFFD7124A),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                        topLeft: Radius.circular(5.0))),
                                child: Center(
                                    child: Text(
                                  General()
                                          .converSale(
                                              int.parse(detailproduct.price),
                                              int.parse(
                                                  detailproduct.price_market))
                                          .toString() +
                                      "%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )),
                              ),
                            )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Divider(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Text(
                      detailproduct.name,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SendComment(
                                                id: widget.id_product,
                                              )));
                                },
                                child: RatingBar(
                                  itemSize: 17,
                                  initialRating:
                                      double.parse(detailproduct.rate),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  ratingWidget: RatingWidget(
                                      full: Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      empty: Icon(
                                        Icons.star,
                                        color: Colors.grey,
                                      ),
                                      half: Icon(
                                        Icons.star,
                                        color: Colors.grey,
                                      )),
                                  onRatingUpdate: null,
                                ),
                              ),
                              Text(" " + detailproduct.rate + '   |   '),
                              Icon(
                                Icons.remove_red_eye,
                                size: 17,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(detailproduct.viewed),
                              ),
                            ],
                          ),
                        ),
                        detailproduct.affiliate_gt_product != null
                            ? InkWell(
                                onTap: () async {
                                  Share.share(Const().domain +
                                      "/" +
                                      detailproduct.alias +
                                      "-p" +
                                      detailproduct.id +
                                      ".html");
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Color(0xff5f94c9),
                                        ),
                                        Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 13,
                                        )
                                      ],
                                    ),
                                    Text(
                                      detailproduct.affiliate_gt_product + '%',
                                      style:
                                          TextStyle(color: Color(0xff5f94c9)),
                                    )
                                  ],
                                ),
                              )
                            : Text('')
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Giá: " +
                                Config()
                                    .formatter
                                    .format(double.parse(detailproduct.price)) +
                                ' đ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        //Text("Chia sẻ", style: TextStyle(color: Color(0xffdbbf6d), fontWeight: FontWeight.bold, fontSize: 15),),
                        //SizedBox(height: 10,),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  String url =
                                      "https://www.facebook.com/sharer/sharer.php?u=${Const().domain}/${detailproduct.alias}-p${detailproduct.id}.html";
                                  urlLauncher(url);
                                },
                                child: Image.asset(
                                  "assets/images/facebook.png",
                                  width: 30,
                                  height: 30,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {
                                  // String url =
                                  //     "https://plus.google.com/share?url=${Const().domain}/${detailproduct.alias}-p${detailproduct.id}.html";
                                  //
                                  // urlLauncher(url);
                                  Share.share(
                                      "${Const().domain}/${detailproduct.alias}-p${detailproduct.id}.html");
                                },
                                child: Image.asset(
                                  "assets/images/zalo_sharelogo.png",
                                  width: 30,
                                  height: 30,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {
                                  String url = "https://vdiarybook.vn";

                                  urlLauncher(url);
                                },
                                child: Image.asset(
                                  "assets/images/64x64.png",
                                  width: 30,
                                  height: 30,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {
                                  String url =
                                      "https://twitter.com/share?url=${Const().domain}/${detailproduct.alias}-p${detailproduct.id}.html";
                                  urlLauncher(url);
                                },
                                child: Image.asset(
                                  "assets/images/twitter.png",
                                  width: 30,
                                  height: 30,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {
                                  String url =
                                      "https://pinterest.com/pin/create/bookmarklet/?url=${Const().domain}/${detailproduct.alias}-p${detailproduct.id}.html";
                                  print(url);
                                  urlLauncher(url);
                                },
                                child: Image.asset(
                                  "assets/images/pinterest.png",
                                  width: 30,
                                  height: 30,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      color: Colors.grey.shade200,
                      height: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(Const().domain +
                                  "static" +
                                  detailproduct.shop.avatar_path +
                                  detailproduct.shop.avatar_name),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    detailproduct.shop.name,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: RatingBar(
                                      itemSize: 13,
                                      initialRating: double.parse('5'),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      ratingWidget: RatingWidget(
                                          full: Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          empty: Icon(
                                            Icons.star,
                                            color: Colors.grey,
                                          ),
                                          half: Icon(
                                            Icons.star,
                                            color: Colors.grey,
                                          )),
                                      onRatingUpdate: null),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          children: [
                            RaisedButton(
                              color: Color(0xff2F80ED),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShopDetail(
                                              shop_id: detailproduct.shop.id,
                                              currentUserNo: prefs.getString(
                                                Dbkeys.phone,
                                              ),
                                              shopNo:
                                                  detailproduct.shop.phoneUser,
                                            )));
                              },
                              child: Text(
                                "Xem Shop",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      color: Colors.grey.shade200,
                      height: 20,
                    ),
                  ),
                  _getTabBar(),
                ])),
              ];
            },
            body: _getTabBarView(snapshot.data['shop'].name, snapshot));
      }),
    );
  }

  openChat(DetailProduct detailproduct) async {
    print(detailproduct.shop.phone);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = await Const.web_api.getUserPhone();

    if (phone == null) {
      HelperFunctions.toast('Vui lòng đăng nhập để tiếp tục');
    } else {
      try {
        _cachedModel = getModel(phone);
        LoadingDialog.showLoadingDialog(context, "Đang tải");
        await BlocCreateChat.createAndUpdate(
          email: detailproduct.shop.email,
          phone: detailproduct.shop.phone,
          id: detailproduct.shop.id,
          username: detailproduct.shop.phone,
        );
        LoadingDialog.hideLoadingDialog(
          context,
        );
        if (detailproduct.shop.phone == phone) {
          HelperFunctions.toast('Bạn không thể tự chat với chính mình');
        } else {
          FirebaseFirestore.instance
              .collection(DbPaths.collectionusers)
              .doc(detailproduct.shop.phone)
              .get()
              .then((user) async {
            if (user.exists && user.data().containsKey(Dbkeys.phone)) {
              if (user.exists) {
                _cachedModel.addUser(user);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoom(
                      prefs: prefs,
                      unread: 0,
                      linkPrd: Const().domain +
                          "/" +
                          detailproduct.alias +
                          "-p" +
                          detailproduct.id +
                          ".html",
                      currentUserNo: prefs.getString("phone") ?? "",
                      model: _cachedModel,
                      detaiPrd: detailproduct,
                      peerNo: detailproduct.shop.phone,
                    ),
                  ),
                );
              }
            } else {
              HelperFunctions.toast(
                  'Shop hiện chưa mở khóa chức năng nhắn tin');
            }
          });
        }
      } catch (e) {
        HelperFunctions.toast('Lỗi không xác định');
      }
    }
  }
}
