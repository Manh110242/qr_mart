// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gcaeco_app/database/database_Cart.dart';
// import 'package:gcaeco_app/helper/Config.dart';
// import 'package:gcaeco_app/helper/toast.dart';
// import 'package:gcaeco_app/model/product_in_cart/product_in_cart.dart';
// import 'package:gcaeco_app/screen/screen_confirm_delivery_address.dart';
// import 'package:gcaeco_app/screen/screen_payment.dart';
// import 'package:gcaeco_app/screen/screen_success_order.dart';
//
// // ignore: camel_case_types, must_be_immutable
// class Item_Bottom_Navigation_Payment extends StatelessWidget {
//   double total;
//   String navigateTo;
//
//   Item_Bottom_Navigation_Payment({Key key, this.total, this.navigateTo})
//       : super(key: key);
//
//   DBProductsInCart dbProductsInCart = new DBProductsInCart();
//
//   // ignore: non_constant_identifier_names
//   List<Products_In_Cart> products_in_cart_list;
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     return Container(
//       height: 56,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 border: Border.all(color: Config().colorMain)),
//             width: screenWidth / 2,
//             alignment: Alignment.center,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text("Tổng tiền:",
//                     style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16)),
//                 Padding(
//                     padding: const EdgeInsets.only(left: 4.0),
//                     child: Text(Config().formatter.format(total),
//                         style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16))),
//               ],
//             ),
//           ),
//           FutureBuilder(
//               future: dbProductsInCart.getProductsInCart(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.hasData && snapshot.data.length != 0) {
//                   products_in_cart_list = snapshot.data;
//                   return InkWell(
//                     onTap: () {
//                       if (navigateTo == "ToConfirmAddress") {
//                         Navigator.push(
//                             context,
//                             new MaterialPageRoute(
//                                 builder: (context) =>
//                                     Confirm_Delivery_Address_Screen(
//                                       total: total,
//                                     )));
//                       } else if (navigateTo == "ToPayment") {
//                         Navigator.push(
//                             context,
//                             new MaterialPageRoute(
//                                 builder: (context) => Payment_Screen(
//                                       total: total,
//                                     )));
//                       } else if (navigateTo == "ToSuccessOrder") {
//                         for (int i = 0; i < products_in_cart_list.length; i++) {
//                           dbProductsInCart.deleteProductsInCart(
//                               products_in_cart_list[i].idP);
//                         }
//                         Navigator.push(
//                             context,
//                             new MaterialPageRoute(
//                                 builder: (context) => Screen_Success_Order()));
//                       }
//                     },
//                     child: Container(
//                       width: screenWidth / 2,
//                       alignment: Alignment.center,
//                       color: Config().colorMain,
//                       child: Text("THANH TOÁN",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                     ),
//                   );
//                 } else if (snapshot.hasData && snapshot.data.length == 0) {
//                   return InkWell(
//                     onTap: () {
//                       showToast("Không có sản phẩm nào trong giỏ hàng", context,
//                           Colors.grey.shade400, Icons.warning);
//                     },
//                     child: Container(
//                       width: screenWidth / 2,
//                       alignment: Alignment.center,
//                       color: Config().colorMain,
//                       child: Text("THANH TOÁN",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                     ),
//                   );
//                 }
//                 return CircularProgressIndicator();
//               }),
//         ],
//       ),
//     );
//   }
// }
