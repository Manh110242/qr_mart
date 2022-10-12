import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/shop/item_shop/multi_select.dart';
import 'package:gcaeco_app/shop/tab_affilate/tab1.dart';
import 'package:gcaeco_app/shop/tab_affilate/tab2.dart';

class AffiliateShop extends StatefulWidget {

  @override
  _AffiliateShopState createState() => _AffiliateShopState();
}

class _AffiliateShopState extends State<AffiliateShop> {
  List<int> prd_select = [];
  List<MultiSelectDialogItem<int>> prds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:  Config().colorMain,
          title: Text("Affiliate"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Config().colorMain,
                unselectedLabelStyle: TextStyle(color:  Colors.grey),
                tabs: [
                  Tab(
                    child: Text("Quản lý Affiliate DN"),
                  ),
                  Tab(
                    child: Text("QR-CODE dịch vụ"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Tab1(),
            Tab2(),
          ],
        ),

      ),
    );
  }
}
