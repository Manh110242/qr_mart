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

class ItemProductGrid extends StatefulWidget {
  ProductItem item;
  bool check;
  bool hasOnTap;

  ItemProductGrid(this.item,{this.check = true, this.hasOnTap = true});

  @override
  _ItemProductGridState createState() => _ItemProductGridState();
}

class _ItemProductGridState extends State<ItemProductGrid> {
  bool in_wish = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    in_wish = widget.item.in_wish != null && widget.item.in_wish != "null" ? widget.item.in_wish : false;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width - 30) / 2;
    return InkWell(
      onTap: widget.hasOnTap ? () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Detail_Product(widget.item.id, prefs.getString(Dbkeys.phone))),
        );
      } : null,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF656565).withOpacity(0.15),
                blurRadius: 4.0,
                spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
              )
            ]),
        // child: Text('okkkk'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// Set Animation image to detailProduk layout
            Stack(
              children: <Widget>[
                widget.item.avatar_path != '' && widget.item.avatar_path != null
                    ? Container(
                        height: 170,
                        width: 50000,
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
                        height: itemWidth - 10,
                        width: 50000,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                          child: Image.asset('assets/images/no-image.png',
                              fit: BoxFit.cover),
                        )),
                widget.item.price == widget.item.price_market ||
                        General().converSale(widget.item.price, widget.item.price_market) == 0
                    ? Text('')
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 25,
                          width: 55.0,
                          decoration: BoxDecoration(
                              color: Color(0xFFD7124A),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  topLeft: Radius.circular(5.0))),
                          child: Center(
                              child: Text(
                            General()
                                    .converSale(widget.item.price, widget.item.price_market)
                                    .toString() +
                                "%",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
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
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text(
                widget.item.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 13.0),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5),
              child: Text(
                Config().formatter.format(widget.item.price) + 'đ',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StarRating(
                    rating: widget.item.rate,
                    color: Colors.orange,
                  ),
                 widget.check!= null && widget.check ? Container(
                   child:  in_wish
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
                 ) : Container(),
                ],
              ),
            ),
          ],
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
            showToast(
                response['message'], context, Colors.green, Icons.check_circle);
            in_wish = true;
            setState(() {});
          } else {
            showToast(response['error'], context, Colors.yellow, Icons.error);
            in_wish = false;
            setState(() {});
          }
        } else {
          showToast(
              "Kết nối server thất bại", context, Colors.yellow, Icons.error);
          in_wish = false;
          setState(() {});
        }
      }
    });

  }
}
