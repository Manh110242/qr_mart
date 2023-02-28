import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';

import 'layouts/grid_view_custom.dart';
import 'layouts/products/item_product_grid.dart';
import 'qrcode/pay_by_voucher.dart';

class PrdByVoucher extends StatelessWidget {
  String code;
  PrdByVoucher({
    @required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Danh sách sản phẩm của Voucher"),
      ),
      body: FutureBuilder(
        future: QrBloc.getPrdVoucher(code),
        builder: (_, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          } else if (snap.data.length == 0) {
            return Container(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Không tìm thấy sản phẩm',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            );
          }
          return GridViewCustom(
            itemCount: snap.data.length,
            maxWight: 180,
            mainAxisExtent: 300,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PayByVoucher(
                            model: snap.data[index],
                            code: code,
                          )),
                );
              },
              child: ItemProductGrid(
                snap.data[index],
                check: false,
                hasOnTap: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
