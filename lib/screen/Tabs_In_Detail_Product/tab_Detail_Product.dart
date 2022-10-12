import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/model/detail_product.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';

// ignore: camel_case_types, must_be_immutable
class Tab_Detail_Product extends StatefulWidget {
  DetailProduct detailProduct;

  // ignore: non_constant_identifier_names
  String name_category;

  // ignore: non_constant_identifier_names
  Tab_Detail_Product({Key key, this.detailProduct, this.name_category})
      : super(key: key);

  @override
  Tab_Detail_Product_State createState() => Tab_Detail_Product_State();
}

// ignore: camel_case_types
class Tab_Detail_Product_State extends State<Tab_Detail_Product> {
  ScrollController scrollController = new ScrollController();

  var dateConvert;
  Fetch_Data fetchDataCategories =
      new Fetch_Data("/app/home/get-productcat-showhome", {});

  // ignore: non_constant_identifier_names
  Fetch_Data fetch_data_product_in_shop =
      new Fetch_Data("/app/product/get-products", {});

  // ignore: non_constant_identifier_names
  Fetch_Data fetch_data_favorite_products =
      new Fetch_Data("/app/product/get-products", {});

  // ignore: non_constant_identifier_names
  String name_category = "Cập nhật";

  Future productsInShopFuture;
  Future favoriteProductsFuture;
  bool canCallProductsInShop = true;
  bool canCallFavoriteProducts = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    canCallProductsInShop = true;
    canCallFavoriteProducts = true;
    fetchDataCategories.getCategories().then((value) {
      for (int i = 0; i < value.length; i++) {
        if (widget.detailProduct.category_id == value[i].id) {
          setState(() {
            name_category = value[i].name;
          });
        }
      }
    });
    favoriteProductsFuture = fetch_data_favorite_products.getProducts(
        "2", "6", "null", "null", "null", widget.detailProduct.ishot);
    productsInShopFuture = fetch_data_product_in_shop.getProducts(
        "1", "6", "null", "null", widget.detailProduct.shop_id, "null");

    dateConvert = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.detailProduct.created_at) * 1000);

    if (widget.detailProduct.status == "1") {
      widget.detailProduct.status = "Còn hàng";
    } else {
      widget.detailProduct.status = "Hết hàng";
    }

    if (widget.detailProduct.description == "null") {
      widget.detailProduct.description = "";
    }
  }

  // ignore: non_constant_identifier_names
  @override
  Widget build(BuildContext context) {
    final double itemHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Danh mục           :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(name_category),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Ngày đăng bán  :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(Config().formatterDate.format(dateConvert)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Trạng thái           :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(widget.detailProduct.status))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Giao hàng từ      :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(widget.detailProduct.shop.ward_name +
                            " - " +
                            widget.detailProduct.shop.district_name +
                            " - " +
                            widget.detailProduct.shop.province_name),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Html(
                    data: widget.detailProduct.description.trim(),
                    // textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ Color(0xff124CB9),Color(0xff112573),],
                begin: const FractionalOffset(1, 0.4),
                end: const FractionalOffset(0.3, 0.4),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
                  child: Text(
                    'Sản phẩm khác của công ty'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder(
                    future: canCallProductsInShop ? productsInShopFuture : null,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        canCallProductsInShop = false;
                        return GridView.count(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
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
                            children: List.generate(
                              snapshot.data.length,
                                  (index) => ItemProductGrid(snapshot.data[index]),
                            ));
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10,top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'sản phẩm có thể bạn thích'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: canCallFavoriteProducts ? favoriteProductsFuture : null,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        canCallProductsInShop = false;
                        return GridView.count(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
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
                            children: List.generate(
                              snapshot.data.length,
                                  (index) => ItemProductGrid(snapshot.data[index]),
                            ));
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
