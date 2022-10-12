/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/wallet_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/general.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/wallet/transfer_success.dart';

class ConvertVoucher extends StatefulWidget {
  @override
  _ConvertVoucherState createState() => _ConvertVoucherState();
}

class _ConvertVoucherState extends State<ConvertVoucher> {
  var walletBloc;
  ScrollController _scrollController = new ScrollController();
  int page = 1;
  int limit = 15;
  bool isLoading = false;

  final _vrController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    walletBloc = new WalletBloc();
  }

  @override
  void dispose() {
    _vrController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Config().colorMain,
        title: Text(
          'Chuyển đổi Voucher',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: body(context),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Color(0xff005030)),
        constraints: BoxConstraints(minHeight: 1000),
        child: Column(
          children: [
            transferInfomation(context),
          ],
        ),
      ),
    );
  }

  //Nhập các thông tin chuyển V
  Widget transferInfomation(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: walletBloc.getVoucher(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data['code'] == 200) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Số dư khả dụng',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 15)),
                        Text(
                          snapshot.data['data']['text_coin_red'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text('Đang cập nhật',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tỷ lệ chuyển đổi',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 15)),
              Text('1Vr = 1V',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16)),
            ],
          ),
        ),
        TextField(
          controller: _passController,
          style: TextStyle(fontSize: 15, color: Colors.black),
          decoration: new InputDecoration(
            hintText: "Nhập mật khẩu cấp 2...",
            hintStyle: TextStyle(color: Colors.black87),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(width: 1, color: Colors.white),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(width: 1, color: Colors.red)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(width: 1, color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.white)),
            errorStyle: TextStyle(color: Colors.orange),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
        ),
        TextField(
          controller: _vrController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          style: TextStyle(fontSize: 15, color: Colors.black),
          decoration: new InputDecoration(
            hintText: "Nhập số Vr cần chuyển...",
            hintStyle: TextStyle(color: Colors.black87),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(width: 1, color: Colors.white),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(width: 1, color: Colors.red)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(width: 1, color: Colors.white),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.white)),
            errorStyle: TextStyle(color: Colors.orange),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  submit();
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  submit() async {
    var general = new General();
    var request = new Map();
    FocusScope.of(context).requestFocus(FocusNode());
    var password = _passController.text;
    var vr = _vrController.text;
    request['Mật khẩu cấp 2 không được bỏ trống'] = password;
    request['Số Vr không được bỏ trống'] = vr;
    if (general.validate(request, context)) {
      Map bankInfo = {
        "coin": vr,
        "otp": password,
      };
      var response = await walletBloc.transfervrtov(bankInfo);
      if (response['code'] == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  TransferSuccess('Chuyển Vr sang V thành công!')),
          ModalRoute.withName('/'),
        );
      } else {
        MsgDialog.showMsgDialog(context, response['errors'], 'Lỗi');
      }
    }
  }
}
