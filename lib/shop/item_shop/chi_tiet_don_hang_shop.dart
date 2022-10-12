import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_shop_don_hang_manh.dart';
import 'package:gcaeco_app/screen/layouts/donhang_manh/item_products_manh.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class ItemChiTietDonHangShop extends StatefulWidget {
  int nextpage;
  OrderItem data;
  ItemChiTietDonHangShop({this.data,this.nextpage});

  @override
  _ItemChiTietDonHangShopState createState() => _ItemChiTietDonHangShopState();
}

class _ItemChiTietDonHangShopState extends State<ItemChiTietDonHangShop> {
  ShopBloc bloc = new ShopBloc();

  String textDonHang(item) {
    if (item == "1") {
      return 'Đơn hàng đang chờ xác nhận';
    } else if (item == "2") {
      return 'Đơn hàng chờ lấy hàng';
    } else if (item == "3") {
      return 'Đơn hàng đang được giao';
    } else if (item == "4") {
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Thông tin đơn hàng'),
        backgroundColor: Config().colorMain,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){
          Navigator.pop(context,widget.nextpage-1);
        }),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Orderlabel(),
              Diachinhan(),
              SizedBox(
                height: 10,
              ),
              ThongTinShop(),
              ThongTinDonHang(),
              ThanhToan(),
              SizedBox(
                height: 10,
              ),
              PhuongThucThanhToan(),
              SizedBox(
                height: 10,
              ),
              ThoiGianDatHang(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.nextpage == 5 || widget.nextpage == 4 ? null:Row(
        children: [
          InkWell(
            onTap: () async {
              LoadingDialog.showLoadingDialog(context, 'Đang cập nhật');
              var res = await bloc.updateOrderShop(widget.data.id);
              LoadingDialog.hideLoadingDialog(context);
              Navigator.pop(context, widget.nextpage);
              if(res){
                showToast("Chuyển trạng thái thành công", context, Colors.grey, Icons.check);
              }else{
                showToast("Lỗi dữ liệu", context, Colors.grey, Icons.error_outline);
              }
            },
            child: Container(
              height: 50,
              width: size.width/2,
              color: Config().colorMain,
              child: Center(child: Text("Chuyển trạng thái".toUpperCase(), style: TextStyle(color: Colors.white),)),
            ),
          ),
          InkWell(
            onTap: () async {
              LoadingDialog.showLoadingDialog(context, 'Đang cập nhật');
              var res = await bloc.cancelOrderShop(widget.data.id);
              LoadingDialog.hideLoadingDialog(context);
              Navigator.pop(context, 5);
              if(res){
                showToast("Hủy đơn hàng thành công", context, Colors.grey, Icons.check);
              }else{
                showToast("Lỗi dữ liệu", context, Colors.grey, Icons.error_outline);
              }
            },
            child: Container(
              height: 50,
              width: size.width/2,
              decoration: BoxDecoration(
                border: Border.all(color: Config().colorMain, width: 1),
                color: Colors.white
              ),
              child: Center(child: Text("Hủy đơn hàng".toUpperCase(), style: TextStyle(color: Config().colorMain),)),
            ),
          ),
        ],
      ),
    );
  }

  Widget Orderlabel() {
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
                      textDonHang(widget.data.status),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Mã đơn: ${widget.data.order_label}.",
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

  Widget Diachinhan() {
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
                        widget.data.name,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: Config().colortextchitietdonhang,
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.data.phone,
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
                        widget.data.address,
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
            orderItem: widget.data,
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
      itemCount: widget.data.products.length,
      itemBuilder: (_context, index) {
        return ListProductWidget(
          productItem: widget.data.products[index],
        );
      },
    );
  }

  Widget ThanhToan() {
    double tongtien = double.parse(widget.data.order_total);
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

  Widget PhuongThucThanhToan() {
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
                  (widget.data.payment_method == '2')
                    ? 'Thanh toán khi nhận hàng' :
                widget.data.payment_method == 'MEMBERIN'?
                'Thanh toán bằng $appName Voucher' : "Đang cập nhật"
                ,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget ThoiGianDatHang() {
    int time = int.parse(widget.data.created_at) * 1000;
    String date = DateFormat('dd-MM-yyyy HH: mm a', 'en_US')
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
                date,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              )
            ],
          ),
        ],
      ),
    );
  }
}
