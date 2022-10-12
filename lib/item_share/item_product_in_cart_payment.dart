import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/product_in_cart/product_in_cart.dart';

// ignore: camel_case_types, must_be_immutable
class Item_Product_In_Cart_Payment extends StatelessWidget {
  // ignore: non_constant_identifier_names
  Products_In_Cart products_in_cart;

  Item_Product_In_Cart_Payment(this.products_in_cart);

  double totalOfOne = .0;

  @override
  Widget build(BuildContext context) {
    totalOfOne = products_in_cart.priceP * products_in_cart.quantityP;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment(0.8,0),
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  child: Container(
                    height: 120,
                    child: Image.network(
                      products_in_cart.imageP,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    width: (1.5 * MediaQuery.of(context).size.width / 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            products_in_cart.nameP,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                Config().formatter.format(totalOfOne) + " đ",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Text("x  " + products_in_cart.quantityP.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
