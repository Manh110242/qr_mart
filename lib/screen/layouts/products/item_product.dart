import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/general.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/screen/layouts/products/star_rating.dart';
import 'package:gcaeco_app/screen/screen_detail_product.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class displayProductItem extends StatefulWidget {
  ProductItem item;
  bool check;
  bool checkFlashSale;

  displayProductItem({this.item, this.check, this.checkFlashSale = false});

  @override
  _displayProductItemState createState() => _displayProductItemState();
}

class _displayProductItemState extends State<displayProductItem> {
  bool in_wish = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    in_wish = widget.item.in_wish != null && widget.item.in_wish != "null"
        ? widget.item.in_wish
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, bottom: 10.0, right: 0.0),
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detail_Product(
                    widget.item.id,
                    prefs.getString(Dbkeys.phone))),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ]),
          child: Container(
            width: 160.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    widget.item.avatar_path != '' &&
                        widget.item.avatar_path != null
                        ? Container(
                        height: 185.0,
                        width: 160.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                          child: Image.network(
                              Const().image_host +
                                  widget.item.avatar_path +
                                  's400_400/' +
                                  widget.item.avatar_name,
                              fit: BoxFit.cover),
                        ))
                        : Container(
                        height: 185.0,
                        width: 160.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                          child: Image.asset(
                              'assets/images/no-image.png',
                              fit: BoxFit.cover),
                        )),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: General()
                          .converSale(widget.item.price,
                          widget.item.price_market) > 0 ? Container(
                        height: 25.5,
                        width: 55.0,
                        decoration: BoxDecoration(
                            color: Color(0xFFD7124A),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                topLeft: Radius.circular(5.0))),
                        child: Center(
                            child: Text(
                              General()
                                  .converSale(widget.item.price,
                                  widget.item.price_market)
                                  .toString() +
                                  "%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )),
                      ) : SizedBox(),
                    ),
                    widget.item.logo_vip != "" && widget.item.vip_active == "1"
                        ? Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 30,
                        width: 50,
                        child: Image.network(
                          widget.item.logo_vip,
                          height: 30,
                          width: 50,
                        ),
                      ),
                    )
                        : SizedBox(),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    widget.item.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black54,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 1.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    Config().formatter.format(widget.item.price) + 'đ',
                    style: TextStyle(
                        fontFamily: "Sans",
                        color: Colors.red,
                        fontSize: 13.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StarRating(
                        rating: widget.item.rate,
                        color: Colors.orange,
                      ),
                      Container(
                        child: widget.item.in_wish == null
                            ? Container()
                            : in_wish
                            ? InkWell(
                          onTap: () {
                            addWishlist(context, widget.item.id);
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.orange,
                            size: 14,
                          ),
                        )
                            : InkWell(
                          onTap: () {
                            addWishlist(context, widget.item.id);
                          },
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.black38,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.check != null && widget.check
                    ? Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Config().colorMain,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      "Đã bán ${widget.item.quantity_selled_promotion_sale}/${widget.item.quantity_promotion_sale}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontSize: 15),
                    ),
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addWishlist(context, product_id) async {
    Const.web_api.checkLogin().then((value) async {
      if (value == '') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login_Screen()));
      } else {
        var user_id = await Const.web_api.getUserId();
        var token = await Const.web_api.getTokenUser();
        Map<String, dynamic> request_body = new Map<String, dynamic>();
        request_body['user_id'] = user_id;
        request_body['product_id'] = product_id;
        var response = await Const.web_api
            .postAsync("/app/user/wish-product", token, request_body);
        if (response != null) {
          if (response['code'] == 1) {
            in_wish = true;
            showToast(
                response['message'], context, Colors.green, Icons.check_circle);
            setState(() {});
          } else {
            in_wish = false;
            showToast(response['error'], context, Colors.yellow, Icons.error);
            setState(() {});
          }
        } else {
          in_wish = false;
          showToast(
              "Kết nối server thất bại", context, Colors.yellow, Icons.error);
          setState(() {});
        }
      }
    });

  }
}
