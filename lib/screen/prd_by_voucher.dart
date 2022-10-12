import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';

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
        builder: (_,AsyncSnapshot snap){
          if(!snap.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return GridView.count(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 10.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?  0.60 : 0.65,
              crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                  (MediaQuery.of(context).size.width / 170)
                      .floor()) >
                  0.8
                  ? (MediaQuery.of(context).size.width / 170).round()
                  : (MediaQuery.of(context).size.width / 170).floor(),
              primary: false,
              children: List.generate(
                snap.data.length,
                    (index) => InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>PayByVoucher(
                              model: snap.data[index],
                              code: code,
                            )),);
                        },
                        child: ItemProductGrid(snap.data[index],check: false,hasOnTap: false,),
                    ),
              ));
        },
      ),
    );
  }
}
