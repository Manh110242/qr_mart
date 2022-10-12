import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_manh.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'layouts/products/item_product_grid.dart';

class CategoryManh extends StatefulWidget {
  String categoryItem_id;

  CategoryManh(this.categoryItem_id);

  @override
  _CategoryManhState createState() => _CategoryManhState(this);
}

class _CategoryManhState extends State<CategoryManh> {
  CategoryManh categoryManh;

  _CategoryManhState(this.categoryManh);

  ScrollController _sc = new ScrollController();
  int _page = 1;
  var bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new BlocTest();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _page++;
        bloc.getProductDetail(categoryManh.categoryItem_id, _page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc.getProductDetail(categoryManh.categoryItem_id, _page);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Manh Test"),
      ),
      body: StreamBuilder(
        stream: bloc.allAddress,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? GridView.count(
                  controller: _sc,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?  0.60 : 0.67,
                  crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
                  primary: false,
                  children: List.generate(snapshot.data.length,
                      (index) => ItemProductGrid(snapshot.data[index])))
              : Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
        },
      ),
    );
  }
}
