import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/shop/create_coupon.dart';
import 'package:gcaeco_app/shop/item_shop/item_des_table.dart';
import 'package:gcaeco_app/shop/item_shop/item_header_table.dart';

class Promotion extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  //Decode your json string
  TextEditingController s = TextEditingController();
  ShopBloc bloc = new ShopBloc();
  bool xoa = false;
  int page = 1;
  ScrollController sc = new ScrollController();
  double width = 412;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.coupon(page, 12, s.text, false, xoa);
    sc.addListener(() async {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        page = page + 1;
        await bloc.coupon(page, 12, s.text, false, xoa);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Quản lý khuyến mãi"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: sc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 40,
                  width: size.width * 0.8,
                  child: TextField(
                    controller: s,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 5, left: 10),
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập mã",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only( right: 10),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Config().colorMain,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.white,),
                      onPressed: () async {
                        await bloc.coupon(
                            page, 12, s.text, true , xoa);
                      },
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Color(0xffd3dff4),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          ItemHeaderTable(
                            title: "Mã",
                            width: width * 0.4,
                          ),
                          ItemHeaderTable(
                            title: "Thời gian",
                            width: width * 0.6,
                          ),
                          ItemHeaderTable(
                            title: "Giá trị giảm",
                            width: width * 0.3,
                          ),
                          ItemHeaderTable(
                            title: "Áp dụng với",
                            width: width * 0.4,
                          ),
                          ItemHeaderTable(
                            title: "Trạng thái",
                            width: width * 0.3,
                          ),
                          ItemHeaderTable(
                            title: "Thao tác",
                            width: width * 0.3,
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: bloc.couponsShop,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.length > 0) {
                            return Column(
                              children: List.generate(
                                  snapshot.data.length,
                                  (index) => Row(
                                        children: <Widget>[
                                          ItemDesTable(
                                            des: snapshot.data[index].id,
                                            width: width * 0.4,
                                          ),
                                          ItemDesTable(
                                            des: "Từ: " +
                                                snapshot.data[index].time_start,
                                            des1: "Đến: " +
                                                snapshot.data[index].time_end,
                                            width: width * 0.6,
                                          ),
                                          ItemDesTable(
                                            des: snapshot.data[index]
                                                        .type_discount ==
                                                    "1"
                                                ? Config().formatter.format(int.parse(snapshot.data[index].value)) +
                                                    " đ"
                                                : snapshot.data[index].value +
                                                    " %",
                                            width: width * 0.3,
                                          ),
                                          ItemDesTable(
                                            des: snapshot.data[index].all == "1"
                                                ? "Tất cả sản phẩm"
                                                : snapshot.data[index].products,
                                            width: width * 0.4,
                                          ),
                                          ItemDesTable(
                                            des: "Đã dùng: " +
                                                snapshot.data[index].count +
                                                "/" +
                                                snapshot
                                                    .data[index].count_limit,
                                            width: width * 0.3,
                                          ),
                                          action1(width * 0.3, "Xóa",
                                              snapshot.data[index].id),
                                        ],
                                      )),
                            );
                          } else {
                            return Container(
                              height: 100,
                              width: size.width,
                              child: Center(child: Text("Không có mã giá nào")),
                            );
                          }
                        } else {
                          return Container(
                            height: 100,
                            width: size.width,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config().colorMain,
        child: Icon(Icons.add),
        onPressed: () async{
          var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateCoupon()));
          if(res != null){
            xoa = true;
           setState(() {});
          }
        }
      ),
    );
  }

  Widget action1(
    double width,
    title,
    id,
  ) {
    return Container(
      height: 80,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1)),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Center(
                      child: Text("Xóa mã giảm giá"),
                    ),
                    content: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Bạn có muỗn xóa mã : ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(text: id, style: TextStyle(color: Colors.red)),
                      ]),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Đồng ý'),
                        onPressed: () async {
                            xoa = true;
                            setState(() {});
                            var res = await bloc.deleteCoupon(id);
                            xoa = false;

                          if (res) {
                            showToast("Xóa thành công", context, Colors.grey,
                                Icons.check);
                            await bloc.coupon(page, 12, s.text, true, xoa);
                          } else {
                            showToast("Xóa thất bại", context, Colors.grey,
                                Icons.error_outline);
                          }
                          Navigator.of(context).pop(MsgDialog);
                        },
                      ),
                      FlatButton(
                        child: Text('Đóng'),
                        onPressed: () {
                          Navigator.of(context).pop(MsgDialog);
                        },
                      )
                    ],
                  ));
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ),
      ),
    );
  }
}
