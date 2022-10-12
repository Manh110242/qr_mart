import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
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
          title: Text('Sản phẩm yêu thích')
        ),
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
                  childAspectRatio: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?  0.60 : 0.67,
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
