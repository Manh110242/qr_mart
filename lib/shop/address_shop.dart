import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_location_mah.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/location_manh/list_loacation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressShop extends StatefulWidget {
  @override
  _AddressShopState createState() => _AddressShopState();
}

class _AddressShopState extends State<AddressShop> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  List _list = ["Mặc định","Không chọn"];
  String isdefault = "Không chọn";
  LocationBloc bloc = new LocationBloc();
  ShopBloc shopBloc = new ShopBloc();

  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController tinh = new TextEditingController();
  TextEditingController quan = new TextEditingController();
  TextEditingController phuong = new TextEditingController();
  TextEditingController address = new TextEditingController();

  String key1;
  String key2;
  String key3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.loacationBlocTinh();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Địa chỉ doanh nghiệp"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 10, right: 10, bottom: 30),
              child: Column(
                children: [
                  SizedBox(
                    child: Text(
                      'Tạo địa chỉ doanh nghiệp',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8f8b21),
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // nguoi lien he
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tên người liên hệ (*)",
                          style:
                          TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: name,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tên người liên hệ không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //sdt
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Số điện thoại (*)",
                          style:
                          TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: phone,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Số điện thoại không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //Tinh/thanh pho
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tĩnh/Thành Phố",
                          style:
                          TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 16),
                          controller: tinh,
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          readOnly: true,
                          showCursor: false,
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListLocation(
                                      title: "Tỉnh/Thành Phố",
                                      idTinh: '',
                                      idQuan: '',
                                      index: "",
                                    )));
                            if(result != null){
                              tinh.text = result.name;
                              key1 = result.id;
                              quan.text = "";
                              phuong.text = "";
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tĩnh/Thành Phố không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //quan/huyen
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quận/Huyện",
                          style:
                          TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 16),
                          controller: quan,
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          readOnly: true,
                          showCursor: false,
                          onTap: () async {
                            if(tinh.text != ""){
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListLocation(
                                        title: "Quận/Huyện",
                                        idTinh: key1,
                                        idQuan: '',
                                        index: "",
                                      )));
                              if(result != null){
                                quan.text = result.name;
                                key2 = result.id;
                              }
                            }else{
                              showToast("Vui nhập tĩnh thành phố ", context, Colors.grey, Icons.error_outline);
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Quận/Huyện không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //phuong/xa
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phường/Xã",
                          style:
                          TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 16),
                          controller: phuong,
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          readOnly: true,
                          showCursor: false,
                          onTap: () async {
                            if(tinh.text != ""&& quan.text != ""){
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListLocation(
                                        title: "Phường/Xã",
                                        idTinh: '',
                                        idQuan: key2,
                                        index: "",
                                      )));
                              if(result != null){
                                phuong.text = result.name;
                                key3 = result.id;
                              }
                            }else{
                              showToast("Vui nhập tĩnh thành phố và quận huyện", context, Colors.grey, Icons.error_outline);
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Phường/Xã không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  // dia chi
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Địa chỉ (*)",
                          style:
                          TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: address,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tên người liên hệ không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //google map
                  // Container(
                  //   padding:
                  //   const EdgeInsets.only(top: 20, left: 10, right: 10),
                  //   width: double.infinity,
                  //   height: 300,
                  //   child: GoogleMap(
                  //       mapType: MapType.normal,
                  //       initialCameraPosition: CameraPosition(
                  //           target: LatLng(21.0244247, 105.7938073),
                  //           zoom: 17
                  //       ),
                  //       markers: {Marker(
                  //         markerId: MarkerId("Tên Shop"),
                  //         position: LatLng(21.0244247, 105.7938073),
                  //         infoWindow: InfoWindow(title: "Tên Shop"),
                  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  //       )}
                  //   ),
                  // ),
                  //mac dinh
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mặc định",
                          style:
                          TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField(
                          value: isdefault,
                          style: TextStyle(color: Color(0xff8f8b21)),
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          hint: Text(
                            "--Chọn loại doanh nghiêp--",
                            style: TextStyle(color: Color(0xff8f8b21)),
                          ),
                          onChanged: (value) {
                            isdefault = value;
                          },
                          items: _list
                              .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  // tạo doanh nghiep
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: FlatButton(
                        color: Config().colorMain,
                        onPressed: () async {
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmShop()));
                          if (_formKey.currentState.validate()) {
                          var res = await shopBloc.postAddres(null,name.text, phone.text, key1, key2, key3, address.text, isdefault == "Không chọn"?0:1);
                          if(res){
                            Navigator.pop(context,"ok");
                            showToast("Thêm địa chỉ thành công", context, Colors.grey, Icons.check);
                          }else{
                            showToast("Thêm địa chỉ thất bại", context, Colors.grey, Icons.error_outline);

                          }
                          }
                        },
                        child: Text(
                          'Tạo địa chỉ doanh nghiệp',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
