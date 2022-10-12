import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/shop/address_shop.dart';
import 'package:gcaeco_app/shop/update_shop.dart';
import 'item_shop/address.dart';

class ShopLocation extends StatefulWidget {
  @override
  _ShopLocationState createState() => _ShopLocationState();
}

class _ShopLocationState extends State<ShopLocation> {
  ShopBloc bloc = new ShopBloc();
  int page = 1;
  ScrollController sc = new ScrollController();
  bool load;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sc.addListener(() async {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        load = true;
        setState(() {});
        page = page + 1;
        await bloc.getAddress(page);
        load = false;
        setState(() {});
      }
    });
  }
  toast(res){
    if(res){
      setState(() {});
      showToast("Xóa địa chỉ thành công", context, Colors.grey, Icons.check);
    }else{
      showToast("Xóa địa chỉ thất bại", context, Colors.grey, Icons.error_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc.getAddress(page);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Địa chỉ"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                var res = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddressShop()));
                if (res != null) {
                  setState(() {});
                }
              }),
        ],
      ),
      body: StreamBuilder(
          stream: bloc.addressShop,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                controller: sc,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.justify,
                        maxLines: 5,
                        text: TextSpan(
                          text: 'Gợi ý: ',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                          children: const <TextSpan>[
                            TextSpan(
                                text:
                                " Nếu bạn có nhiều hơn 1 doanh nghiệp. Bạn có thêm các địa chỉ doanh nghiệp đó vào đây. Lưu ý, chọn địa chỉ mặc định là nơi cung cấp chính.",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            AddressItem item =snapshot.data[index];
                            return load == true &&
                                index == (snapshot.data.length - 1)
                                ? Center(
                              child: CircularProgressIndicator(),
                            )
                                : ItemAddress(
                              item: snapshot.data[index],
                              update: () async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateAddressShop(
                                              item: snapshot.data[index],
                                            )));
                                if (res != null) {
                                  setState(() {});
                                }
                              },
                              isdefault: () async {
                                await bloc.postAddres(item.id,item.name_contact, item.phone, item.province_id, item.district_id, item.ward_id, item.address, 1);
                                setState(() {});
                              },
                              delete: ()async{
                                showDialog(context: (context), builder: (context) =>AlertDialog(
                                  title: Text("Xóa địa chỉ"),
                                  content: Text("Bạn có chắc chắn muốn xóa địa chỉ này không"),
                                  actions: [
                                    FlatButton(onPressed: ()async{
                                      Navigator.pop(context);
                                      var res = await bloc.deleteAddress(item.id);
                                      toast(res);
                                    }, child: Text("Đồng ý")),
                                    FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Đóng")),
                                  ],
                                ));
                              },
                            );
                          }),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}