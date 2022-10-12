import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/address_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/screen/location_manh/item_location_manh.dart';
class DiaChiScreen extends StatefulWidget {
  String title;
  DiaChiScreen({this.title});

  @override
  _DiaChiScreen_State createState() => _DiaChiScreen_State();
}

class _DiaChiScreen_State extends State<DiaChiScreen> {
  var bloc;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new AddressBloc();
    getBloc();
  }
getBloc()async{
  await bloc.fetchAddress();
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
        body: SingleChildScrollView(
          controller: _sc,
          child: Column(
            children: [
              addAress(),
              addressListBuild(),
            ],
          ),
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
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
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
    );
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemLocationManh(
                  addressItem: address_item,
                  title: "Cập nhật địa chỉ",
                )));
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

  Widget addAress() {
    var address_item = new AddressItem(
      id: '',
      name_contact: '',
      phone: '',
      email: '',
      province_name: '',
      district_name: '',
      ward_name: '',
      address: '',
      isdefault: '',
      province_id: '',
      district_id: '',
      ward_id: '',
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => ItemLocationManh(
                        title: "Thêm địa chỉ mới",
                        addressItem: address_item,
                      )));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thêm địa chỉ mới",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.add,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
