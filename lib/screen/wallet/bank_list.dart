import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bank_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/wallet/bankItem.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class BankList extends StatefulWidget {
  @override
  _BankList_State createState() => _BankList_State();
}

class _BankList_State extends State<BankList> {
  var bankBloc = new BankBloc();

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
          'Danh sách ngân hàng',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return FutureBuilder(
        future: bankBloc.getBank(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      setBank(snapshot.data[index]);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      padding: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      child: Text(snapshot.data[index].name),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget setBank(s) {
    var bank_item = new Bank(
      id: s.id,
      name: s.name,
    );
    Navigator.pop(context, bank_item);
  }
}
