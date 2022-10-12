import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/product_thang.dart';
import 'package:gcaeco_app/screen/screen_detail_product.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class Item_product_thang extends StatelessWidget {
  final Product_thang product;

  const Item_product_thang(this.product);

  @override
  Widget build(BuildContext context) {
    String newPrice = Config().formatter.format(product.price_market);
    String oldPrice = Config().formatter.format(product.price);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
      
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Image.network(
                      Const().image_host +
                          product.avatar_path +
                          product.avatar_name,
                      fit: BoxFit.cover,
                    ),
                  ),
                  product.flash_sale != "0"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)),
                              child: Container(
                                color: Colors.orange,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product.flash_sale + "%",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Text(
                  product.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Text(
                  newPrice + ' đ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8, right: 8, bottom: 10),
                child: Text(
                  oldPrice + ' đ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBar(
                      itemSize: 16,
                      initialRating:
                          product.rate != null ? double.parse(product.rate) : 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
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
                      //   (context, _) => Icon(
                      // Icons.star,
                      // color: Colors.amber,
                      // ),
                      onRatingUpdate: (rating) {
                        // ratePoint = rating.toString();
                      },
                    ),
                    true
                        ? Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color(0xffb89f58),
                                size: 18,
                              ),
                              Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 9,
                              )
                            ],
                          )
                        : Container()
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
