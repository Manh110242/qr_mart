import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/category_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/layouts/products/item_category.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';
import 'package:gcaeco_app/screen/screen_search.dart';

// ignore: camel_case_types, must_be_immutable
class Category_screen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  int category_id;
  int limit;
  String title;
  String banner;

  Category_screen({this.category_id, this.title, this.banner, this.limit = 12});

  @override
  _Category_screen_State createState() => _Category_screen_State(this);
}

// ignore: camel_case_types
class _Category_screen_State extends State<Category_screen> {
  Category_screen category_screen;

  _Category_screen_State(this.category_screen);

  ScrollController _scrollController;
  int page = 1;
  bool isLoading = false;
  CategoryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = new CategoryBloc();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  dispose() {
    super.dispose();
    bloc.dispose();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page++;
      bloc.fetchProductsByCategory(
          page.toString(), category_screen.category_id, category_screen.limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text(category_screen.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            )),
        actions: [
          FlatButton(
            minWidth: 50,
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => Search_Screen()));
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: main(),
    );
  }

  Widget main() {
    var size = MediaQuery.of(context).size;
    bloc.fetchProductsByCategory(
        page.toString(), category_screen.category_id, category_screen.limit);
    return StreamBuilder(
      stream: bloc.allProducts,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        category_screen.banner != ''
                            ? Image.network(
                                category_screen.banner,
                                  width: size.width,
                                fit: BoxFit.contain,
                              )
                            : Text(
                                '',
                                overflow: TextOverflow.ellipsis,
                              ),
                        listCategoryItem(),
                      ],
                    ),
                  ),
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
                                if (index == snapshot.data.length - 1 &&
                                    snapshot.data.length %
                                            category_screen.limit ==
                                        0) {
                                  return _buildProgressIndicator();
                                } else {
                                  return ItemProductGrid(snapshot.data[index]);
                                }
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
                                'Không tìm thấy sản phẩm thuộc danh mục',
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

  Widget listCategoryItem() {
    return FutureBuilder(
        future: bloc.getCategoryChildren(category_screen.category_id),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            if (snap.data.length > 0) {
              double width = MediaQuery.of(context).size.width;
              bool test = true;
              int count = 1;
              if(width <= 480 ){
                count = 4;
                if(snap.data.length/4 >= 2){
                  test = false;
                  count = 2;
                }
              }else  if(width <= 720 ){
                count = 7;
                if(snap.data.length/7>= 2){
                  test = false;
                  count = 2;
                }
              }else{
                count = 10;
                if(snap.data.length/10 >= 2){
                  test = false;
                  count = 2;
                }
              }
              return Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'DANH MỤC',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 175,
                            child: GridView.count(
                              physics: test ? NeverScrollableScrollPhysics() : BouncingScrollPhysics() ,
                              scrollDirection: test ? Axis.vertical: Axis.horizontal,
                              shrinkWrap: true,
                              childAspectRatio: 1,
                              crossAxisCount: count,
                              children: List.generate(snap.data.length, (it) {
                                return displayCategoryItem(snap.data[it]);
                              }),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Text('');
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
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
