import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/screen/before_login.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:gcaeco_app/screen/wallet/add_voucher.dart';
import 'package:gcaeco_app/screen/wallet/bank_account.dart';
import 'package:gcaeco_app/screen/wallet/convert_voucher.dart';
import 'package:gcaeco_app/screen/wallet/my_voucher.dart';
import 'package:gcaeco_app/screen/wallet/notifi.dart';
import 'package:gcaeco_app/screen/wallet/transfer.dart';
import 'package:gcaeco_app/screen/wallet/voucher_red.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class Wallet extends StatefulWidget {

  final SharedPreferences prefs;

  Wallet({this.prefs});


  @override
  _Wallet_State createState() => _Wallet_State();
}

// ignore: camel_case_types
class _Wallet_State extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Config().colorMain,
        centerTitle: true,
        title: Text(
          'Voucher',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green,Config().colorMain,Colors.cyan])),
        child: FutureBuilder<String>(
          future: Const.web_api.checkLogin(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if(snapshot.hasData){
              if(snapshot.data == '1'){
                return body();
              }else{
                return BeforeLogin(
                  prefs: widget.prefs,
                );
              }
            }else{
              return Text('');
            }
          },
        ),
      ),
    );
  }

  Widget body() {
    return CustomScrollView(
      primary: false,
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
            childAspectRatio: 1.5,
            children: <Widget>[
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => MyVoucher()));
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet,color: Colors.orange,),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Voucher $appName của tôi',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => VoucherRed()));
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.monetization_on,color: Colors.red,),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Rút Voucher $appName Red',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Transfer()));
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.screen_share,color: Colors.orange,),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Chuyển, tặng Voucher $appName',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => ConvertVoucher()));
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_protected_setup,color: Colors.orange,),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Chuyển đổi Voucher $appName',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => AddVoucher()));
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.food_bank_outlined,color: Colors.orange,),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Nạp tiền',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => BankAccount()));
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.food_bank_outlined,color: Colors.orange,),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Tài khoản ngân hàng',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
