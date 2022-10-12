import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';
import 'package:gcaeco_app/screen/tab_search/search_prd.dart';
import 'package:gcaeco_app/screen/tab_search/search_shop.dart';

// ignore: camel_case_types
class Search_Screen extends StatefulWidget {
  String keySearch;

  Search_Screen({this.keySearch});

  @override
  _Search_Screen_State createState() => _Search_Screen_State();
}

// ignore: camel_case_types
class _Search_Screen_State extends State<Search_Screen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: Config().colorMain,
            title: Text("Tìm kiếm"),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: Text("Sản phẩm"),
                  ),
                  Tab(
                    child: Text("Doanh nghiệp"),
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              SearchPrd(),
              SearchShop(),
            ],
          )),
    );
  }
}
