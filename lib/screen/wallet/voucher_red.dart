/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/wallet_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/general.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/wallet/bankAccountItem.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/wallet/bank_list_by_account.dart';
import 'package:gcaeco_app/screen/wallet/transfer_success.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class VoucherRed extends StatefulWidget {
  @override
  _VoucherRedState createState() => _VoucherRedState();
}

class _VoucherRedState extends State<VoucherRed> {
  var walletBloc;
  ScrollController _scrollController = new ScrollController();
  int page = 1;
  int limit = 15;
  bool isLoading = false;

  final _vrController = TextEditingController();
  final _passController = TextEditingController();
  final bankAccountInfo = BehaviorSubject<dynamic>();
  BankItem bankItem;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    walletBloc = new WalletBloc();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        page++;
        walletBloc.historyVr(limit, page);
      }
    });
  }

  @override
  void dispose() {
    _vrController.dispose();
    _passController.dispose();
    bankAccountInfo.close();
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
          'Rút Voucher Red',
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: transferInfomation(context),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child:history(),
            ),
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
        TextField(
          controller: _passController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Nhập mật khẩu cấp 2',
            hintStyle: TextStyle(
              color: Colors.black54,
              fontSize: 14
            )
          ),
        ),
        TextField(
          controller: _vrController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              hintText: 'Nhập số Vr cần rút',
              hintStyle: TextStyle(
                  color: Colors.black54,
                fontSize: 14
              )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 13, bottom: 8),
          child: InkWell(
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BankListByAccount()),
              );
              if (result != null) {
                bankItem = result;
                bankAccountInfo.sink.add(result);
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
                          stream: bankAccountInfo.stream,
                          builder: (context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return snapshot.hasData ? Text(
                              snapshot.data.bank_name,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                submit(bankItem);
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
        )
      ],
    );
  }

  submit(BankItem b)async{
    var general = new General();
    var request = new Map();
    var password = _passController.text;
    var vr = _vrController.text;
    request['Mật khẩu cấp 2 không được bỏ trống'] = password;
    request['Số Vr không được bỏ trống'] = vr;
    if(general.validate(request,context)){
      if(b != null){
        Map bankInfo = {
          "bank_id": b.bank_id,
          "coin": vr,
          "otp": password,
        };
        var response = await walletBloc.bankWithdrawal(bankInfo);
        if(response['code'] == 200){
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) => TransferSuccess('Yêu cầu rút Vr đã được gửi thành công!')),
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

  Widget history() {
    walletBloc.historyVr(limit, page);
    return StreamBuilder(
      stream: walletBloc.allHistoryVr,
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
          var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(s.data[index].created_at) * 1000);
          var date_created = DateFormat.d().format(date) +'/'+ DateFormat.M().format(date) +'/'+ DateFormat.y().format(date);
          int status = int.parse(s.data[index].status);
          return InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      date_created,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.data[index].text_value,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    status > 0 ?
                    Text(
                      'Đã thanh toán',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ):
                    Text(
                      'Chờ thanh toán',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black87,
                ),
              ],
            ),
          );
        });
  }
}
