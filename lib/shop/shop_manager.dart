import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/shop/Tab_oder/Order_screen.dart';
import 'package:gcaeco_app/shop/affiliate_shop.dart';
import 'package:gcaeco_app/shop/business_profile.dart';
import 'package:gcaeco_app/shop/products_manager.dart';
import 'package:gcaeco_app/shop/promotion.dart';
import 'package:gcaeco_app/shop/screen_confirm_shop.dart';
import 'package:gcaeco_app/shop/shop_loca.dart';
import 'package:gcaeco_app/shop/transport.dart';
import 'package:gcaeco_app/shop/upload_avatar_shop.dart';

class ShopManager extends StatefulWidget {
  @override
  _ShopManagerState createState() => _ShopManagerState();
}

class _ShopManagerState extends State<ShopManager> {

  var name;
  var res;
  getIdShop() async {
    name = await Const.web_api.getNameShop();
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdShop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Quản lý doanh nghiệp"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30,),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                child: Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                           res = await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => OrderShop(
                                      index: 0,
                                    )));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Icon(Icons.insert_drive_file,color: Colors.orange,
                                      size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Quản lý đơn hàng",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),),
                                  ],),
                                  Icon(
                                    Icons.navigate_next,
                                    color: Colors.grey,
                                    size: 25,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => ProductsManager()));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Icon(Icons.receipt_long,color: Colors.orange,
                                      size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Quản lý sản phẩm",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),),
                                  ],),
                                  Icon(
                                    Icons.navigate_next,
                                    color: Colors.grey,
                                    size: 25,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Promotion()));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Icon(Icons.receipt_long,color: Colors.orange,
                                      size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Mã giảm giá",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),),
                                  ],),
                                  Icon(
                                    Icons.navigate_next,
                                    color: Colors.grey,
                                    size: 25,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      ConfigurableExpansionTile(
                        animatedWidgetFollowingHeader: Padding(
                          padding: const EdgeInsets.only(right: 11),
                          child: const Icon(
                            Icons.expand_more,
                            color: const Color(0xFF707070),
                          ),
                        ),
                        headerExpanded:
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width - 45,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(children: [
                              Icon(Icons.home_outlined,color: Colors.orange,
                                size: 25,),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(name!= null? name:"",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black
                                  ),),
                              ),
                            ],),
                          ),
                        ),
                        header:  Container(
                          margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width - 45,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(children: [
                              Icon(Icons.home_outlined,color: Colors.orange,
                                size: 25,),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(name!= null? name:"",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black
                                  ),),
                              ),
                            ],),
                          ),
                        ),
                        headerBackgroundColorStart: Colors.white,
                        expandedBackgroundColor: Colors.white,
                        headerBackgroundColorEnd: Colors.white,
                        children: [
                          // ho so
                          InkWell(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessProfile()));
                            },
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 10),
                              child: Text("Hồ sơ doanh nghiệp"),
                            ),
                          ),
                          //avatar shop
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadAvatarShop()));
                            },
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 10),
                              child: Text("Ảnh doanh nghiệp"),
                            ),
                          ),
                          // chung thuc
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmShop()));
                            },
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 10),
                              child: Text("Chứng thực doanh ngiệp"),
                            ),
                          ),
                          // dia chi
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopLocation()));
                            },
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 10),
                              child: Text("Địa chỉ doanh nghiệp"),
                            ),
                          ),
                          // Affiliate
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AffiliateShop()));
                            },
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 10),
                              child: Text("Affiliate"),
                            ),
                          ),
                          // gia han
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}
