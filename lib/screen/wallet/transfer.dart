/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/bloc/wallet_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:intl/intl.dart';

class Transfer extends StatefulWidget {
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  var walletBloc;
  var qrBloc;
  ScrollController _scrollController = new ScrollController();
  int page = 1;
  int limit = 15;
  bool isLoading = false;
  final TextEditingController _moneyController = TextEditingController();
  final _passController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    walletBloc = new WalletBloc();
    qrBloc = new QrBloc();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        walletBloc.historyV(limit, page);
      }
    });
  }

  @override
  void dispose() {
    _moneyController.dispose();
    _passController.dispose();
    _userController.dispose();
    walletBloc.dispose();
    qrBloc.dispose();
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
          'Chuyển Voucher',
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
        constraints:
            BoxConstraints(minHeight: 1000),
        decoration: BoxDecoration(color: Color(0xff005030)),
        child: Column(
          children: [
            myvoucher(),
            transferInfomation(context),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text('Lịch sử giao dịch',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: history(),
            )
          ],
        ),
      ),
    );
  }

  Widget myvoucher() {
    return FutureBuilder(
        future: walletBloc.getVoucher(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['code'] == 200) {
              return Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số dư khả dụng',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          snapshot.data['data']['text_coin'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(
                        color: Colors.black26,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phí chuyển',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '1 OV',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
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
        });
  }

  //Nhập các thông tin chuyển V
  Widget transferInfomation(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          child: StreamBuilder(
            stream: walletBloc.passStream,
            builder: (_context, snap) => TextFormField(
              controller: _passController,
              obscureText: true,
              style: TextStyle(fontSize: 15, color: Colors.black),
              decoration: new InputDecoration(
                suffixIcon:IconButton(
                  onPressed: () => _passController.clear(),
                  icon: Icon(Icons.clear),
                ),
                hintText: "Nhập mật khẩu cấp 2",
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
                errorText: snap.hasError ? snap.error : null,
              ),

            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: StreamBuilder(
            stream: walletBloc.coinStream,
            builder: (_context, snap) => TextField(
              controller: _moneyController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style: TextStyle(fontSize: 15, color: Colors.black),
              decoration: new InputDecoration(
                hintText: "Nhập số V cần chuyển...",
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
                errorText: snap.hasError ? snap.error : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 10),
          child: StreamBuilder(
            stream: walletBloc.userStream,
            builder: (_context, snapshot) => TextField(
              controller: _userController,
              style: TextStyle(fontSize: 15, color: Colors.black),
              decoration: new InputDecoration(
                hintText: "Nhập ID hoặc tên tài khoản hoặc tên doanh nghiệp",
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
                errorStyle: TextStyle(color: Colors.orange, fontSize: 14),
                errorText: snapshot.hasError ? snapshot.error : null,
              ),
            ),
          ),
        ),
        StreamBuilder(
          stream: walletBloc.userInfo,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.hasData ? userInfo(snapshot) : Text('');
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                checkUser();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Kiểm tra người nhận',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                transfer(context);
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
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
        )
      ],
    );
  }

  Widget userInfo(AsyncSnapshot<dynamic> s) {
    if (s.data['code'] == 200) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tên tài khoản',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                Text(
                  s.data['data']['user_name'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Divider(
                color: Colors.black26,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tên doanh nghiệp',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                Text(
                  s.data['data']['shop_name'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Divider(
                color: Colors.black26,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                Text(
                  s.data['data']['email'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Text(
          s.data['errors'],
          style: TextStyle(color: Colors.orange),
        ),
      );
    }
  }

  // Lịch sử giao dịch
  Widget history() {
    walletBloc.historyTransfer(limit, page);
    return StreamBuilder(
      stream: walletBloc.allHistory,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? listHistory(snapshot)
            : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
      },
    );
  }

  Widget listHistory(AsyncSnapshot<dynamic> s) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: s.data.length,
        itemBuilder: (_context, index) {
          var date = new DateTime.fromMillisecondsSinceEpoch(
              int.parse(s.data[index].created_at) * 1000);
          var date_created = DateFormat.d().format(date) +
              '/' +
              DateFormat.M().format(date) +
              '/' +
              DateFormat.y().format(date);
          double price = double.parse(s.data[index].gca_coin);
          return InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(
                      date_created,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    s.data[index].data,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                price > 0
                    ? Text(
                        '+' + s.data[index].text_gca_coin,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        s.data[index].text_gca_coin,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                Divider(
                  color: Colors.white70,
                ),
              ],
            ),
          );
        });
  }

  checkUser() async {
    String user = _userController.text;
    if (walletBloc.isValidUser(user,'user')) {
      walletBloc.searchUser(user);
    } else {
      walletBloc.removesearchUser();
    }
  }

  transfer(context) async{
    String user = _userController.text;
    String coin = _moneyController.text;
    var pass = _passController.text;
    if (walletBloc.isValidUser(pass,'password') && walletBloc.isValidUser(coin,'coin') && walletBloc.isValidUser(user,'user')) {
      LoadingDialog.showLoadingDialog(context, "Loading...");
      final checkUs = await walletBloc.checkUser(user);
      LoadingDialog.hideLoadingDialog(context);
      if(checkUs['code'] == 200){
        walletBloc.transfer(context,coin,pass,checkUs['id']);
      }else{
        MsgDialog.showMsgDialog(context, checkUs['errors'], 'Lỗi!');
      }
    }
  }
}
