import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_manh.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'layouts/grid_view_custom.dart';
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
          if (!snapshot.hasData) {
            return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return Container(
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
            );
          }
          return GridViewCustom(
            itemCount: snapshot.data.length,
            maxWight: 180,
            mainAxisExtent: 300,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemBuilder: (context, index) =>
                ItemProductGrid(snapshot.data[index]),
          );
        },
      ),
    );
  }
}
