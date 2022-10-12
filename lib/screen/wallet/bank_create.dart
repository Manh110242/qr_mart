import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/bank_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/general.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/wallet/bankItem.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/wallet/bank_account.dart';
import 'package:gcaeco_app/screen/wallet/bank_list.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class BankCreate extends StatefulWidget {
  @override
  _BankCreateState createState() => _BankCreateState();
}

class _BankCreateState extends State<BankCreate> {
  final bankInfo = BehaviorSubject<dynamic>();
  TextEditingController _account = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _branch = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  Bank bank;
  var bankBloc;

  @override
  void initState() {
    super.initState();
    bankBloc = new BankBloc();
  }

  @override
  void dispose() {
    bankBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Config().colorMain,
        title: Text(
          'Thêm tài khoản ngân hàng',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: body(context),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _account,
              decoration: InputDecoration(
                  hintText:
                  'Tên chủ tài khoản (Viết in hoa, không dấu - NGUYEN VAN A)',
                  hintStyle: TextStyle(fontSize: 14)),
            ),
            TextField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Số tài khoản', hintStyle: TextStyle(fontSize: 14)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 13, bottom: 8),
              child: InkWell(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BankList()),
                  );
                  if (result != null) {
                    bank = result;
                    bankInfo.sink.add(result);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text(
                        'Chọn ngân hàng',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 8,
                            child: StreamBuilder(
                              stream: bankInfo.stream,
                              builder: (context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return snapshot.hasData ? Text(
                                  snapshot.data.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ) : Text('');
                              },
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black87,
            ),
            TextField(
              controller: _branch,
              decoration: InputDecoration(
                  hintText: 'Tên chi nhánh ngân hàng',
                  hintStyle: TextStyle(fontSize: 14)),
            ),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Số điện thoại', hintStyle: TextStyle(fontSize: 14)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: RaisedButton(
                onPressed: (){
                  submit(bank);
                },
                color: Colors.orange,
                child: Text('Xác nhận',style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }

  submit(Bank bankcreate) async{
    var general = new General();
    var request = new Map();
    FocusScope.of(context).requestFocus(FocusNode());
    var account = _account.text;
    var number = _number.text;
    var branch = _branch.text;
    var phone = _phone.text;
    request['Tên tài khoản không được bỏ trống'] = account;
    request['Số tài khoản không được bỏ trống'] = number;
    request['Chi nhánh không được bỏ trống'] = branch;
    request['Số điện thoại không được bỏ trống'] = phone;
    if(general.validate(request,context)){
      if(bankcreate != null){
        Map bankInfo = {
          "bank_type": bankcreate.id,
          "number": number,
          "name": account,
          "phone": phone,
          "address": branch,
          "isdefault": 0,
        };
        var response = await bankBloc.createBank(bankInfo);
        if(response['code'] == 200){
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) => BankAccount()),
            ModalRoute.withName('/'),
          );
        }else{
          MsgDialog.showMsgDialog(context, response['errors'], 'Lỗi');
        }
      }else{
        showToast("Bạn chưa chọn ngân hàng", context, Colors.amberAccent, Icons.error_outline);
      }
    }
  }
}
