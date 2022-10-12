import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/address_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';

// ignore: camel_case_types, must_be_immutable
class Item_Address_Delivery extends StatefulWidget {

  @override
  _AddressState createState() => _AddressState();
}
class _AddressState extends State<Item_Address_Delivery> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new AddressBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text("Giỏ hàng"),
        ),
        body: new Column(
          children: [
            Text('ok')
          ],
        ));
        // bottomNavigationBar: bottomNavigationBar());
  }
  Widget bottomNavigationBar() {
    return StreamBuilder(
      stream: bloc.allAddress,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData ? totalPrice(snapshot) : Text('0');
      },
    );
  }

  Widget totalPrice(AsyncSnapshot<dynamic> s) {
    double screenWidth = MediaQuery.of(context).size.width;
    if(s.data > 0){
      return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Container(
                width: screenWidth / 2,
                alignment: Alignment.center,
                color: Colors.orange,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Tổng tiền:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(Config().formatter.format(80000) + 'đ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Payment_Screen()),
                // );
              },
              child: Container(
                width: screenWidth / 2,
                alignment: Alignment.center,
                color: Config().colorMain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("THANH TOÁN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }else{
      return Text('');
    }
  }
}