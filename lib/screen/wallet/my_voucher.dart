/**
 * Created by trungduc.vnu@gmail.com.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/wallet_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:intl/intl.dart';
class MyVoucher extends StatefulWidget {
  @override
  _MyVoucherState createState() => _MyVoucherState();
}

class _MyVoucherState extends State<MyVoucher> {
  var walletBloc;
  ScrollController _scrollController = new ScrollController();
  int page = 1;
  int limit = 15;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    walletBloc = new WalletBloc();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        page++;
        walletBloc.historyV(limit, page);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    walletBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Config().colorMain,
        title: Text(
          'Voucher của tôi',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        decoration: BoxDecoration(color: Color(0xff005030)),
        child: Column(
          children: [
            myvoucher(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 20,
                    ),
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
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)),
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
                margin:
                    EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số dư OV',
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
                          'Số dư E.VGA',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          snapshot.data['data']['text_coin_sale'],
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
                          'Số dư OVr khả dụng',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          snapshot.data['data']['text_coin_red'],
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
                          'Số dư OVr tạm khóa',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          snapshot.data['data']['text_coin_red_waiting'],
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

  Widget history() {
    walletBloc.historyV(limit, page);
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
          var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(s.data[index].created_at) * 1000);
          var date_created = DateFormat.d().format(date) +'/'+ DateFormat.M().format(date) +'/'+ DateFormat.y().format(date);
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
                price > 0 ?
                Text(
                  '+'+s.data[index].text_gca_coin,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ):
                Text(
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
}
