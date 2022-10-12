import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/don_hang_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/historys_don_hang.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/model/products_dom_hang.dart';
import 'package:gcaeco_app/model/user.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_shop_don_hang_manh.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_products_manh.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';

class ItemChiTietDonHang extends StatefulWidget {
  OrderItem orderItem;
  List<ProductsDonHang> productItem;

  ItemChiTietDonHang({this.orderItem, this.productItem});

  @override
  _ItemChiTietDonHangState createState() => _ItemChiTietDonHangState();
}

class _ItemChiTietDonHangState extends State<ItemChiTietDonHang> {
  Donhang bloc = new Donhang();
  User user;

  String textDonHang() {
    if (widget.orderItem.status == "1") {
      return 'Đơn hàng đang chờ xác nhận';
    } else if (widget.orderItem.status == "2") {
      return 'Đơn hàng chờ lấy hàng';
    } else if (widget.orderItem.status == "3") {
      return 'Đơn hàng đang được giao';
    } else if (widget.orderItem.status == "4") {
      return 'Đơn hàng đã được giao';
    } else {
      return 'Đơn hàng đã hủy';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Thông tin đơn hàng'),
        backgroundColor: Config().colorMain,
        actions: [
          widget.orderItem.status != "0" && widget.orderItem.status != "4"
              ? FlatButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => new Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 20),
                                    child: Text(
                                      "Bạn có muốn hủy đơn hàng này không",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                            top: BorderSide(color: Colors.grey),
                                            right:
                                                BorderSide(color: Colors.grey),
                                          )),
                                          child: FlatButton(
                                              onPressed: () async {
                                                Navigator.pop(context,);
                                                Navigator.pop(context,  widget.orderItem.id.toString());
                                              },
                                              child: Text("Đồng ý")),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                            top: BorderSide(color: Colors.grey),
                                            //right: BorderSide(color: Colors.grey),
                                          )),
                                          child: FlatButton(
                                              onPressed: () async {
                                                Navigator.pop(context, "ok");
                                              },
                                              child: Text("Đóng")),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ));
                  },
                  child: Text(
                    "Hủy đơn",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container()
        ],
      ),
      body: FutureBuilder(
        future: bloc.getThongTinDonHang(widget.orderItem.id.toString()),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data != 0
                ? SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Orderlabel(widget.orderItem),
                          Diachinhan(snapshot),
                          SizedBox(
                            height: 10,
                          ),
                          ThongTinShop(),
                          ThongTinDonHang(),
                          ThanhToan(),
                          SizedBox(
                            height: 10,
                          ),
                          PhuongThucThanhToan(snapshot),
                          SizedBox(
                            height: 10,
                          ),
                          ThoiGianDatHang(snapshot),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text("Lỗi! Không tìm thấy đơn hàng"),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget Orderlabel(OrderItem orderItem1) {
    return Column(
      children: [
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          color: Colors.teal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 13, bottom: 10, left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textDonHang(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Mã đơn: ${orderItem1.order_label}.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget Diachinhan(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      User user = snapshot.data;
      return Container(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.place_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              Flexible(
                flex: 7,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Địa chỉ nhân hàng',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          '${user.username}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Config().colortextchitietdonhang,
                        ),
                      ),
                      Container(
                        child: Text(
                          '${user.phone}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Config().colortextchitietdonhang,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          '${user.address}',
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Config().colortextchitietdonhang,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Align(
          alignment: Alignment.center,
          child: (snapshot.data == null)
              ? CircularProgressIndicator()
              : Text('Không có thông tin người nhận.'));
    }
  }

  Widget ThongTinShop() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Container(
                    child: Text(
                      'Thông tin đơn hàng',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(),
          ),
          ItemDonHangWidget(
            orderItem: widget.orderItem,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(),
          ),
        ],
      ),
    );
  }

  Widget ThongTinDonHang() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: widget.productItem.length,
      itemBuilder: (_context, index) {
        ProductsDonHang prd = widget.productItem[index];
        return ListProductWidget(
          productItem: prd,
        );
      },
    );
  }

  Widget ThanhToan() {
    double tongtien = double.parse(widget.orderItem.order_total);
    var tongtien1 = tongtien.round();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng tiền hàng',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              Text(
                '${Config().formatter.format(tongtien1)} đ',
                style: TextStyle(color: Colors.black54, fontSize: 17),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phí vận chuyển',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              Text(
                '0 đ',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giảm giá phí vận chuyển',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              Text(
                '- 0 đ',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thành tiền',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '${Config().formatter.format(tongtien1)} đ',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget PhuongThucThanhToan(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      User user = snapshot.data;
      return Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.payment,
                size: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phương thức thanh toán.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  (user.payment_method == '2')
                      ? 'Thanh toán khi nhận hàng' :
                  user.payment_method == 'MEMBERIN'?
                       'Thanh toán bằng $appName Voucher' : "Đang cập nhật",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return Align(
          alignment: Alignment.center,
          child: (snapshot.data == null)
              ? CircularProgressIndicator()
              : Text('Không có thông tin người nhận.'));
    }
  }

  Widget ThoiGianDatHang(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data.info.historys.length > 0) {
        User user = snapshot.data;
        HistorysDonHang historysDonHang = user.info.historys[0];
        int time = int.parse(historysDonHang.time) * 1000;
        String ngay = DateFormat('dd-MM-yyyy', 'en_US')
            .format(DateTime.fromMillisecondsSinceEpoch(time));
        String gio = DateFormat('HH: mm a', 'en_US')
            .format(DateTime.fromMillisecondsSinceEpoch(time));
        return Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.timer_rounded,
                  size: 20,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thời gian đặt hàng.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '$gio $ngay',
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  )
                ],
              ),
            ],
          ),
        );
      } else {
        return Align(
            alignment: Alignment.center,
            child: (snapshot.data == null)
                ? CircularProgressIndicator()
                : Text(''));
      }
    } else {
      return Align(
          alignment: Alignment.center,
          child: (snapshot.data == null)
              ? CircularProgressIndicator()
              : Text('Không có thông tin.'));
    }
  }
}
