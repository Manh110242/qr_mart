import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gcaeco_app/bloc/don_hang_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/fade_on_scroll.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_posts.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_purchase.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/chi_tiet_don_hang.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_buttom_products.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_shop_don_hang_manh.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_products_manh.dart';

import '../screen_cart.dart';
import '../screen_profile.dart';

class Ship_done extends StatefulWidget {
  @override
  _Ship_done createState() => _Ship_done();
}

class _Ship_done extends State<Ship_done> with TickerProviderStateMixin {
  int status = 4;
  var bloc;
  ScrollController _sc = new ScrollController();
  int _page = 1;
  bool load= true;

  @override
  void initState() {
    super.initState();
    bloc = new Donhang();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        setState(() {
          load = true;
        });
        _page++;
        bloc.getProductByListCategoryHome(status, _page, false);
        setState(() {
          load = false;
        });

      }
    });
    bloc.getProductByListCategoryHome(status, _page, false);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allAddress,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return (snapshot.hasData && snapshot.data.length > 0)
            ? ListView.builder(
          controller: _sc,
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (_context, index) {
            OrderItem orderItem = snapshot.data[index];
            List<Widget> list = new List<Widget>();
            list.add(ItemDonHangWidget(
              orderItem: snapshot.data[index],
            ));
            snapshot.data[index].products.forEach((element) {
              list.add(ListProductWidget(
                productItem: element,
              ));
            });
            if(snapshot.data.length <11){
              return Container(
                margin:
                EdgeInsets.only(left: 0, top: 5, bottom: 0, right: 0),
                child: Card(
                  child: InkWell(
                    onTap: () async {
                      var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemChiTietDonHang(
                              orderItem: orderItem,
                              productItem: snapshot.data[index].products,
                            )),
                      );
                      if(res != null){
                        await bloc.huydon(res, "0", context);
                        _page = 1;
                        await bloc.getProductByListCategoryHome(status, _page, true);
                      }
                    },
                    child: Container(
                        child: Column(
                          children: [
                            Column(
                              children: list,
                            ),
                            Divider(),
                            Container(
                              child: ItemButtomProducts(
                                orderItem1: orderItem,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              );
            } else if(index == (snapshot.data.length -1)&& load == true){

              return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }else{
              return Container(
                margin:
                EdgeInsets.only(left: 0, top: 5, bottom: 0, right: 0),
                child: Card(
                  child: InkWell(
                    onTap: () async {
                      var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemChiTietDonHang(
                              orderItem: orderItem,
                              productItem: snapshot.data[index].products,
                            )),
                      );
                      if(res != null){
                        await bloc.huydon(res, "0", context);
                        _page = 1;
                        await bloc.getProductByListCategoryHome(status, _page, true);
                      }
                    },
                    child: Container(
                        child: Column(
                          children: [
                            Column(
                              children: list,
                            ),
                            Divider(),
                            Container(
                              child: ItemButtomProducts(
                                orderItem1: orderItem,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              );
            }
          },
        )
            : Align(
                alignment: Alignment.center,
                child: (snapshot.data == null)
                    ? CircularProgressIndicator()
                    : Text('Không Có đơn hàng nào đã giao.'));
      },
    );
  }
}
