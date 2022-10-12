import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/screen/chat_room.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';
import 'package:gcaeco_app/screen/layouts/products/star_rating.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types, must_be_immutable
class ShopDetail extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String shop_id;
  int limit = 12;
  final currentUserNo;
  final shopNo;

  ShopDetail({this.shop_id, this.limit, this.currentUserNo, this.shopNo});

  @override
  _ShopDetailState createState() => _ShopDetailState(this);
}

// ignore: camel_case_types
class _ShopDetailState extends State<ShopDetail>
    with SingleTickerProviderStateMixin {
  ShopDetail shopDetail;

  _ShopDetailState(this.shopDetail);

  ScrollController _scrollController;
  int page = 1;
  bool isLoading = false;
  var shopBloc;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    shopBloc = new ShopBloc();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    shopBloc.fetchProducts(page.toString(), shopDetail.shop_id, 12);
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  dispose() {
    super.dispose();
    shopBloc.dispose();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page++;
      shopBloc.fetchProducts(page.toString(), shopDetail.shop_id, 12);
    }
  }

  DataModel _cachedModel;

  DataModel getModel() {
    _cachedModel ??= DataModel(widget.currentUserNo);
    return _cachedModel;
  }

  // bloc.fetchShop(shopDetail.shop_id);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width - 30) / 2;
    Completer<GoogleMapController> _controller = Completer();

    return ScopedModel<DataModel>(
      model: getModel(),
      child: ScopedModelDescendant<DataModel>(
        builder: (context, child, _model){
          _cachedModel = _model;

          return FutureBuilder(
            future: shopBloc.fetchShop(shopDetail.shop_id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data['code'] == 1) {
                  String avatar_url = Const().image_host +
                      snapshot.data['data']['avatar_path'] +
                      snapshot.data['data']['avatar_name'];
                  String banner_url = Const().image_host +
                      snapshot.data['data']['image_path'] +
                      snapshot.data['data']['image_name'];
                  String shop_name = snapshot.data['data']['name'];
                  double rating = snapshot.data['data']['rate'] != null
                      ? double.parse(snapshot.data['data']['rate'].toString())
                      : 0;
                  int rate_count = snapshot.data['data']['rate_count'] != null
                      ? snapshot.data['data']['rate_count']
                      : 0;
                  //latlng

                  double lat ;
                  double long ;
                  var latlng ;
                  if(snapshot.data['data']['latlng'] != "" && snapshot.data['data']['latlng'] != null){
                    latlng = snapshot.data['data']['latlng'].split(",");
                    lat = double.parse(latlng[0]);
                    long = double.parse(latlng[1]);
                  }
                  // Lấy mã QR
                  List<Widget> list = new List<Widget>();
                  snapshot.data['data']['_qrimages'].forEach((k, v) {
                    if (v != '') {
                      String title = '';
                      String us_id = '';
                      if (k == 'qr_senv') {
                        title = 'Mã QR chuyển V';
                      }
                      if (k == 'qr_service') {
                        title = 'Mã QR dịch vụ';
                      }
                      if (k == 'qr_gtshop') {
                        title = 'Mã QR giới thiệu';
                        us_id = snapshot.data['data']['user_id'].toString();
                      }
                      list.add(itemQr(title, v, us_id, itemWidth, itemHeight));
                    }
                  });
                  return Scaffold(
                      floatingActionButton: FloatingActionButton(
                        backgroundColor: Config().colorMain,
                        child: Icon(
                          Icons.message,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          if(widget.currentUserNo == null){
                            HelperFunctions.toast(
                                'Vui lòng đăng nhập để tiếp tục');
                          }else  if (widget.shopNo ==
                              widget.currentUserNo) {
                            HelperFunctions.toast(
                                'Bạn không thể tự chat với chính mình');
                          } else if (widget.currentUserNo == null) {
                            HelperFunctions.toast(
                                'Vui lòng đăng nhập để bắt đầu nhắn tin');
                          } else {
                            FirebaseFirestore.instance
                                .collection(DbPaths.collectionusers)
                                .doc(widget.shopNo)
                                .get()
                                .then((user) {
                              if (user.exists &&
                                  user.data().containsKey(Dbkeys.phone)) {
                                if (user.exists) {
                                  // var peer = user;
                                  _cachedModel.addUser(user);
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        prefs: prefs,
                                        unread: 0,
                                        currentUserNo: prefs.getString("phone") ?? "",
                                        model: _cachedModel,
                                        peerNo:
                                        widget.shopNo,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                HelperFunctions.toast(
                                    'Shop hiện chưa mở khóa chức năng nhắn tin');
                              }
                            }).catchError((err) {
                              HelperFunctions.toast('Lỗi không xác định');
                            });
                          }
                        },
                      ),
                      body: NestedScrollView(
                        headerSliverBuilder: (context, value) {
                          return [
                            new SliverAppBar(
                              title: Text(shop_name),
                              floating: true,
                              pinned: true,
                              snap: true,
                              flexibleSpace: FlexibleSpaceBar(
                                  background: Container(
                                    color: Config().colorMain,
                                  )),
                              bottom: TabBar(
                                isScrollable: true,
                                controller: _tabController,
                                labelColor: Colors.orange,
                                unselectedLabelColor: Colors.white,
                                tabs: <Widget>[
                                  Tab(
                                    child: Text(
                                      'Sản phẩm',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Giới thiệu',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Liên hệ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'QR Code',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: header(avatar_url, banner_url, shop_name, rating,
                                    rate_count)),
                          ];
                        },
                        body: Container(
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              listProduct(),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Doanh nghiệp: ' + shop_name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Divider(),
                                    Text(snapshot.data['data']['description'])
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        'Doanh nghiệp: ' + shop_name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      'Địa chỉ: ' +
                                          snapshot.data['data']['address'] +
                                          ', ' +
                                          snapshot.data['data']['district_name'] +
                                          ', ' +
                                          snapshot.data['data']['province_name'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10,),
                                    Expanded(
                                      child: snapshot.data['data']['latlng'] != "" && snapshot.data['data']['latlng'] != null?Container(
                                        width: double.infinity,
                                        child: GoogleMap(
                                            mapType: MapType.normal,
                                            initialCameraPosition: CameraPosition(
                                                target: LatLng(lat, long),
                                                zoom: 17
                                            ),
                                            markers: {Marker(
                                              markerId: MarkerId(shop_name),
                                              position: LatLng(lat, long),
                                              infoWindow: InfoWindow(title: shop_name),
                                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                                            )}
                                        ),
                                      ): Container(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: GridView.count(
                                    crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
                                    childAspectRatio: 0.67,
                                    padding: const EdgeInsets.all(4.0),
                                    mainAxisSpacing: 4.0,
                                    crossAxisSpacing: 4.0,
                                    children: list),
                              ),
                            ],
                          ),
                        ),
                      ));
                }
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget header(String avatar_url, String banner_url, String shop_name,
      double rating, int rating_count) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 150,
              child: Image.network(
                banner_url,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 10,
                child: Container(
                  height: 80,
                  width: 80,
                  child: Image.network(
                    avatar_url,
                    fit: BoxFit.cover,
                  ),
                ))
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: Text(
                  shop_name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StarRating(
                    rating: rating,
                    color: Colors.orange,
                    size_icon: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('($rating_count)',
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Widget listProduct() {

    return StreamBuilder(
        stream: shopBloc.allProducts,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    snapshot.data.length > 0
                        ? SliverPadding(
                            padding: EdgeInsets.all(10),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 0.67,
                                crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return ItemProductGrid(snapshot.data[index]);
                                },
                                childCount: snapshot.data.length,
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(
                                  'Không tìm thấy sản phẩm',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                  ],
                )
              : Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
        });
  }

  Widget itemQr(title, url, user_id, itemWidth, itemHeight) {
    return Column(
      children: [
        Image.network(
          url,
          height: itemWidth - 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: Colors.black, fontSize: 13.0),
          ),
        ),
        Text(
          user_id,
          style: TextStyle(color: Colors.red),
        ),
        Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 5, top: 5),
            child: InkWell(
              onTap: () {
                downloadImage(url);
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.orange),
                child: Text(
                  'Tải ảnh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
      ],
    );
  }

  downloadImage(url) async {
    try {
      var imageId = await ImageDownloader.downloadImage(url);
      showToast(
          "Tải ảnh thành công", context, Colors.green, Icons.check_circle);
    } catch (error) {
      showToast(
          "Tải ảnh thất bại", context, Colors.yellow, Icons.error_outline);
    }
  }
}
