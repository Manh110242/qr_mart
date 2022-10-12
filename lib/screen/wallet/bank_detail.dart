import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/wallet/bankAccountItem.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class BankDetail extends StatefulWidget {
  BankItem bankItem;
  BankDetail(this.bankItem);

  @override
  _BankDetailState createState() => _BankDetailState(this);
}

class _BankDetailState extends State<BankDetail> {

  BankDetail bankDetail;
  _BankDetailState(this.bankDetail);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Config().colorMain,
        title: Text(
          'Tài khoản ngân hàng',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: body(context),
    );
  }

  Widget body(context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text('Tên chủ tài khoản',style:TextStyle(
                color: Colors.black,
              fontSize: 15
            )),
          ),
          Text(bankDetail.bankItem.name,style: TextStyle(
            color: Colors.black54,
            fontSize: 14
          ),),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text('Số tài khoản',style:TextStyle(
                color: Colors.black,
                fontSize: 15
            )),
          ),
          Text(bankDetail.bankItem.number,style: TextStyle(
              color: Colors.black54,
              fontSize: 14
          ),),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text('Tên ngân hàng',style:TextStyle(
                color: Colors.black,
                fontSize: 15
            )),
          ),
          Text(bankDetail.bankItem.bank_name,style: TextStyle(
              color: Colors.black54,
              fontSize: 14
          ),),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text('Chi nhánh',style:TextStyle(
                color: Colors.black,
                fontSize: 15
            )),
          ),
          Text(bankDetail.bankItem.address,style: TextStyle(
              color: Colors.black54,
              fontSize: 14
          ),),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text('Số điện thoại',style:TextStyle(
                color: Colors.black,
                fontSize: 15
            )),
          ),
          Text(bankDetail.bankItem.phone,style: TextStyle(
              color: Colors.black54,
              fontSize: 14
          ),),
          Divider(),
        ],
      ),
    );
  }
}
