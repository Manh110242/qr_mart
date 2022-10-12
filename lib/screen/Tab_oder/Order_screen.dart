import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/fade_on_scroll.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/screen/Tab_oder/New_order_fragment.dart';
import 'package:gcaeco_app/screen/Tab_oder/Shipping.dart';
import 'package:gcaeco_app/screen/Tab_oder/Ship_done.dart';
import 'package:gcaeco_app/screen/Tab_oder/Wait_receive.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_posts.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_purchase.dart';

import '../screen_cart.dart';
import '../screen_profile.dart';
import 'Cancle.dart';

class Order_Screen extends StatefulWidget {
  Order_Screen({ this.index});
  int index;
  @override
  _Oder createState() => _Oder();
}

class _Oder extends State<Order_Screen> with TickerProviderStateMixin {
  TabController _tabController;

@override
  void initState() {
  _tabController = new TabController(length: 5, vsync: this, initialIndex: widget.index-1);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text("Đơn hàng"),
          bottom:  TabBar(
            labelColor: Colors.white,
            controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(child: Text("Đơn hàng mới"),),
              Tab(child: Text("Chờ lấy hàng"),),
              Tab(child: Text("Đang giao"),),
              Tab(child: Text("Đã giao"),),
              Tab(child: Text("Đã hủy"),),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            New_order_fragment(),
            Wait_receive(),
            Shipping(),
            Ship_done(),
            Cancle(),
          ],
        ),
      ),
    );
  }
}
