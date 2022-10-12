import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bank_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/wallet/bankAccountItem.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class BankListByAccount extends StatefulWidget {
  @override
  _BankListByAccount_State createState() => _BankListByAccount_State();
}

class _BankListByAccount_State extends State<BankListByAccount> {
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

  Widget body(){
    bankBloc.getListBank(100,1);
    return StreamBuilder(
      stream: bankBloc.allBank,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? listBank(snapshot)
            : Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator());
      },
    );
  }
  Widget listBank(AsyncSnapshot<dynamic> s) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: ListView.builder(
        itemCount: s.data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              setBank(s.data[index]);
            },
            child: Container(
              padding: EdgeInsets.only(top: 5,bottom: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.food_bank_outlined,size: 30,color: Colors.black38,),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.data[index].bank_name,
                                    style: TextStyle(color: Colors.black,fontSize: 15),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      s.data[index].number,
                                      style: TextStyle(color: Colors.black54,fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                          )
                        ],
                      ),
                      Icon(Icons.chevron_right,color: Colors.black54,)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Divider(
                      // color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          );
        },
        shrinkWrap: true,
        physics: ScrollPhysics(),
      ),
    );
  }

  Widget setBank(s) {
    var bank_item = new BankItem(
      bank_id: s.bank_id,
      bank_name: s.bank_name,
    );
    Navigator.pop(context, bank_item);
  }
}
