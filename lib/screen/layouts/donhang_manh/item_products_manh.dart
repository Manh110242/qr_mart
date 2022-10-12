import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/products_dom_hang.dart';
class ListProductWidget extends StatelessWidget {
  ProductsDonHang productItem;

  ListProductWidget({this.productItem});

  @override
  Widget build(BuildContext context) {
    double c = double.parse(productItem.price);
    double d = double.parse(productItem.quantity);
    var price = c.round();
    var quantity = d.round();
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment:  MainAxisAlignment.start,
        children: [
          Container(
              child: productItem.avatar_name != null
                  ? new Container()
                  : new Center(
                child: Text(
                  'ok',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              width: 50.0,
              height: 50.0,
              decoration: productItem.avatar_path != null
                  ? new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage( Const().image_host +
                          productItem.avatar_path +
                          productItem.avatar_name,)))
                  : new BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red)),
          Flexible(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productItem.name,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                            ),
                            Text(
                              Config().formatter.format(price) + ' đ',
                              style:
                              TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                        child: Text('x' + quantity.toString())),
                  ],
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Text('x' + productItem.quantity.toString()),