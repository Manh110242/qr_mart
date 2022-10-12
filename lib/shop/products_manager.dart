import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/shop/add_prd.dart';
import 'package:gcaeco_app/shop/tab_prd_manager/all_prd.dart';
import 'package:gcaeco_app/shop/tab_prd_manager/out_of_stock.dart';
import 'package:gcaeco_app/shop/tab_prd_manager/stocking.dart';

class ProductsManager extends StatefulWidget {
  @override
  _ProductsManagerState createState() => _ProductsManagerState();
}

class _ProductsManagerState extends State<ProductsManager> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text("Quản lý sản phẩm"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(child: Text("Tất cả"),),
              Tab(child: Text("Còn hàng"),),
              Tab(child: Text("Hết hàng"),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllPrd(),
            Stocking(),
            OutOfStock(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Config().colorMain,
          child: Icon(Icons.add),
          onPressed: () async {
           var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPrd()));
           if(res != null){
             setState(() {});
           }
          },
        ),
      ),
    );
  }
}
