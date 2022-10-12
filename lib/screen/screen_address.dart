import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/address_bloc.dart';
import 'package:gcaeco_app/bloc/cart_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/screen/screen_home.dart';

class Address_screen extends StatefulWidget {
  String title;

  Address_screen({this.title});

  @override
  _Address_Screen_State createState() => _Address_Screen_State();
}

class _Address_Screen_State extends State<Address_screen> {
  var bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new AddressBloc();
    bloc.fetchAddress();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            addressListBuild(),
          ],
        ));
  }

  Widget addressListBuild() {
    return StreamBuilder(
      stream: bloc.allAddress,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? addressListViewWidget(snapshot)
            : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
      },
    );
  }

  Widget addressListViewWidget(AsyncSnapshot<dynamic> s) {
    return new Expanded(
        child: ListView.builder(
      itemCount: s.data.length,
      itemBuilder: (_, index) {
        return InkWell(
            onTap: () {
              setAddressDefault(s.data[index]);
            },
            child: Container(
                margin: EdgeInsets.all(1),
                child: Card(
                    child: Column(
                  children: <Widget>[
                    ListTile(
                        isThreeLine: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Text(s.data[index].name_contact),
                            ),
                            Expanded(
                              flex: 2,
                              child: getaddressDefault(
                                  s.data[index].isdefault.toString()),
                            )
                          ],
                        ),
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(s.data[index].phone,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey)),
                            Text(s.data[index].address,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 8,
                                  child: Text(
                                    s.data[index].ward_name +
                                        ', ' +
                                        s.data[index].district_name +
                                        ', ' +
                                        s.data[index].province_name,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ],
                        ))
                  ],
                ))));
      },
    ));
  }

  Widget setAddressDefault(s) {
    var address_item = new AddressItem(
      id: s.id,
      name_contact: s.name_contact,
      phone: s.phone,
      email: s.email,
      province_name: s.province_name,
      district_name: s.district_name,
      ward_name: s.ward_name,
      address: s.address,
      isdefault: s.isdefault,
      province_id: s.province_id,
      district_id: s.district_id,
      ward_id: s.ward_id,
    );
    // bloc.setDefault(address_item);
    Navigator.pop(context, address_item);
  }

  Widget getaddressDefault(String stt) {
    String res = '';
    if (stt == '1') {
      res = '[Mặc định]';
    }
    return Text(
      res,
      style: TextStyle(fontSize: 13, color: Colors.red),
      textAlign: TextAlign.end,
    );
  }
}
