import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/layouts/grid_view_custom.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';

// ignore: camel_case_types
class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

// ignore: camel_case_types
class _WishlistState extends State<Wishlist> {
  var bloc;
  int page = 1;
  int limit = 12;
  bool isLoading = false;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new ProductBloc();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page++;
      Map<String, dynamic> request_body = new Map<String, dynamic>();
      request_body['limit'] = limit;
      request_body['page'] = page;
      bloc.getWishlist(request_body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            backgroundColor: Config().colorMain,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text('Sản phẩm yêu thích')),
        body: body());
  }

  Widget body() {
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['limit'] = limit;
    request_body['page'] = page;
    bloc.getWishlist(request_body);
    return StreamBuilder(
      stream: bloc.allProducts,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
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
          controller: _scrollController,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          itemBuilder: (context, index) =>
              ItemProductGrid(snapshot.data[index]),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 0 : 1,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
