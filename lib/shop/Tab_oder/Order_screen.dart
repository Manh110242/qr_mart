import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/shop/Tab_oder/Cancle.dart';
import 'package:gcaeco_app/shop/Tab_oder/New_order_fragment.dart';
import 'package:gcaeco_app/shop/Tab_oder/Ship_done.dart';
import 'package:gcaeco_app/shop/Tab_oder/Shipping.dart';
import 'package:gcaeco_app/shop/Tab_oder/Wait_receive.dart';

class OrderShop extends StatefulWidget {
  OrderShop({this.index});

  int index;

  @override
  _Oder createState() => _Oder();
}

class _Oder extends State<OrderShop> with TickerProviderStateMixin {
  TabController _tabController;
  int abc = 0;

  @override
  void initState() {
    super.initState();
    abc = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController =
        new TabController(length: 5, vsync: this, initialIndex: abc);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text("Đơn hàng"),
          bottom: TabBar(
            labelColor: Colors.white,
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            onTap: (a) {},
            tabs: [
              Tab(
                child: Text("Đơn hàng mới"),
              ),
              Tab(
                child: Text("Chờ lấy hàng"),
              ),
              Tab(
                child: Text("Đang giao"),
              ),
              Tab(
                child: Text("Đã giao"),
              ),
              Tab(
                child: Text("Đã hủy"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            New_order_shop(
              onClick: (e) {
               getView(e);
              },
              onCancel: (){
                getCancel();
              },
            ),
            Wait_receiveShop(
              onClick: (e) {
                getView(e);
              },
              onCancel: (){
                getCancel();
              },
            ),
            ShippingShop(
              onClick: (e) {
                getView(e);
              },
              onCancel: (){
                getCancel();
              },
            ),
            ShipDoneShop(
              onClick: (e) {
                getView(e);
              },
              onCancel: (){
                getCancel();
              },
            ),
            CancleShop(
              onClick: (e) {
                getView(e);
              },
              onCancel: (){
                getCancel();
              },
            ),
          ],
        ),
      ),
    );
  }

  getView(e) {
    _tabController.animateTo((e));
    abc = _tabController.index;
    setState(() {});
  }
  getCancel(){
    _tabController.animateTo((4));
    abc = _tabController.index;
    setState(() {});
  }
}
