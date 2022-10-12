import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/item_share/item_suggested_product_in_detail_home.dart';
import 'package:gcaeco_app/model/categories_and_its_products.dart';

// ignore: camel_case_types, must_be_immutable
class Item_Category_And_Its_Products extends StatelessWidget {
  CategoryAndItsProducts categoryAndItsProducts;
  Item_Category_And_Its_Products(this.categoryAndItsProducts);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width:2* MediaQuery.of(context).size.width /3,
                child: Text(
                  categoryAndItsProducts.name,
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              Text(
                'Xem tất cả',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        categoryAndItsProducts.products.length == 0?
            Text("Không có sản phẩm")
            :GridView.count(
          controller: new ScrollController(),
          padding: EdgeInsets.only(top: 20, bottom: 15, left: 7, right: 7),
          childAspectRatio: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?  0.60 : 0.67,
          mainAxisSpacing: 20,
          shrinkWrap: true,
          crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
          children: List.generate(categoryAndItsProducts.products.length, (i) {
            return Item_Suggested_Product_In_Detail_Home(categoryAndItsProducts.products[i], "fromHome");
          }),
        ),
      ],
    );
  }
}
