import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bank_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/wallet/bank_create.dart';
import 'package:gcaeco_app/screen/wallet/bank_detail.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class BankAccount extends StatefulWidget {
  @override
  _BankAccountState createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  var bankBloc;
  ScrollController _scrollController = new ScrollController();
  int page = 1;
  int limit = 15;

  @override
  void initState() {
    super.initState();
    bankBloc = new BankBloc();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
      }
    });
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
          'Tài khoản / Thẻ ngân hàng',
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
        constraints: BoxConstraints(minHeight: 1000),
        child: Column(
          children: [
            Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => BankCreate()
                    ));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/card-bank.png',
                            width: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Thêm tài khoản ngân hàng mới',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.red,
                      )
                    ],
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            bank(),
          ],
        ),
      ),
    );
  }

  Widget bank(){
    bankBloc.getListBank(limit,page);
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
              Navigator.push(context,MaterialPageRoute(
                  builder: (context) => BankDetail(s.data[index])
              ),);
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
}
