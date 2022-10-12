import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/model/Product_API.dart';
import 'package:gcaeco_app/screen/screen_detail_product.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: camel_case_types, must_be_immutable
class Item_Suggested_Product_In_Detail_Home extends StatelessWidget {
  Product_Api product;
  String from;
  Item_Suggested_Product_In_Detail_Home(this.product, this.from);

  @override
  Widget build(BuildContext context) {
    if(product.rate == "null"){
      product.rate = "0";
    }

    return Padding(
      padding: const EdgeInsets.only(top:8.0, left: 8, right: 8, bottom: 0),
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if(from == "fromHome" || from == "fromCategory") {

            Navigator.push(context, new MaterialPageRoute(builder: (context) => Detail_Product(product.id, prefs.getString(Dbkeys.phone))));
          } else if(from =="fromDetail") {
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Detail_Product(product.id, prefs.getString(Dbkeys.phone))));
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Colors.white,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width ,
                    child: Image.network(
                      Const().domain +
                          "static" +
                          product.avatar_path +
                          product.avatar_name,
                      fit: BoxFit.fill,
                      height: 150,

                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                child: Text(product.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: Text(
                  Config().formatter.format(double.parse(product.price))+ ' đ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBar(
                      itemSize: 14,
                      initialRating: double.parse(product.rate),
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          empty: Icon(Icons.star, color: Colors.grey,),
                          half: Icon(Icons.star, color: Colors.grey,)
                      ),
                      onRatingUpdate: (rating) {
                        // ratePoint = rating.toString();
                      },
                    ),
                    // product.canShare
                    //     ?
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Color(0xffb89f58),
                            size: 25,
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 12,
                          )
                        ],
                      ),
                    )
                    // : Container()
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
