
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/don_hang_bloc.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/chi_tiet_don_hang.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_buttom_products.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_shop_don_hang_manh.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_products_manh.dart';
import 'package:gcaeco_app/shop/item_shop/chi_tiet_don_hang_shop.dart';

class ShippingShop extends StatefulWidget {
  Function onClick;
  Function onCancel;
  ShippingShop({this.onClick,this.onCancel});

  @override
  _ShippingShop createState() => _ShippingShop();
}

class _ShippingShop extends State<ShippingShop> with TickerProviderStateMixin {
  String status = "order_waiting_add_more";
  var bloc;
  ScrollController _sc = new ScrollController();
  int _page = 1;

  bool load= true;
  @override
  void initState() {
    super.initState();
    bloc = new ShopBloc();
    bloc.ordershop(status, _page);
    // _sc.addListener(() {
    //   if (_sc.position.pixels == _sc.position.maxScrollExtent) {
    //     setState(() {
    //       load = true;
    //     });
    //     _page++;
    //     bloc.ordershop(status, _page);
    //     setState(() {
    //       load = false;
    //     });
    //   }
    // });


  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.orderPrdShop,
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
              status: "Đang giao",
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
                    onTap: () async  {
                      var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemChiTietDonHangShop(
                              data: snapshot.data[index],
                              nextpage: 3,
                            )),
                      );
                      if(res != null){
                        if(res != 5){
                          widget.onClick(res);
                        }else{
                          widget.onCancel();
                        }
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
                    onTap: () async  {
                      var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemChiTietDonHangShop(
                              data: snapshot.data[index],
                              nextpage: 3,
                            )),
                      );
                      if(res != null){
                        if(res != 5){
                          widget.onClick(res);
                        }else{
                          widget.onCancel();
                        }
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
                : Text('Không Có đơn hàng nào đang giao.'));
      },
    );
  }
}
