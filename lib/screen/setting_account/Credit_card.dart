import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/fade_on_scroll.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_posts.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_purchase.dart';

import '../screen_cart.dart';
import '../screen_profile.dart';
import '../screen_home.dart';

class Credit_card extends StatefulWidget {

  @override
  _Credit_card createState() => _Credit_card();
}

class _Credit_card extends State<Credit_card>  {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mda = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title:Text( "Tài khoản/thẻ ngân hàng"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
          child: Column(
            children: [
              ListView.builder(
                  controller: new ScrollController(),
                  // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  itemCount:5,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Thẻ ngân hàng: ",
                                    style: TextStyle(

                                        color: Colors.black,
                                        fontSize: 14
                                    ),
                                  ),
                                  Container(
                                    width: mda/1.7,
                                    child: Text("BIDV",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                            //-----------------
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Chủ thẻ:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14
                                    ),
                                  ),
                                  Container(
                                    width: mda/1.7,
                                    child: Text("thắng"+index.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                            //---------------------------
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Số tài khoản: ",
                                    style: TextStyle(

                                        fontSize: mda/25
                                    ),
                                  ),
                                  Container(
                                    width: mda/1.7,
                                    child: Text("124234343242",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                            //--------------------
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Điện thoại: ",
                                    style: TextStyle(
                                        fontSize: mda/25
                                    ),
                                  ),
                                  Container(
                                    width: mda/1.7,
                                    child: Text("342334344",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                            //-----------------------------
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Chi nhánh: ",
                                    style: TextStyle(

                                        fontSize: mda/25
                                    ),
                                  ),
                                  Container(
                                    width: mda/1.7,
                                    child: Text("hà nội",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  width: mda/4,
                                  height: 35,
                                  color: Colors.blue,
                                  child: FlatButton(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.description,
                                          color: Colors.white,
                                          size: mda/25,
                                        ),
                                        Text(
                                          'Cập nhật',
                                          style: TextStyle(fontSize: mda / 35,color:Colors.white,),
                                        ),
                                      ],
                                    ),
                                    //color: Colors.blue,
                                    textColor: Colors.white,
                                    onPressed: () {
                                    },
                                  ),
                                ),
                                // Container(
                                //   height: 35,
                                //   color:Colors.red,
                                //   margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                //   width: mda/5,
                                //   child: FlatButton(
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Icon(
                                //           Icons.cancel,
                                //           color: Colors.white,
                                //           size: mda/25,
                                //         ),
                                //         Text(
                                //           'Xóa ',
                                //           style: TextStyle(fontSize: mda / 35,color: Colors.white),
                                //         ),
                                //       ],
                                //     ),
                                //     //  color: Colors.red,
                                //     textColor: Colors.white,
                                //     onPressed: () {
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){

                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Thêm địa chỉ mới"),
                          Icon(Icons.add,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 50,)
            ],

          ),
        ),
      ),
    );
  }
}
