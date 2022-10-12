import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_location_mah.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/location_manh/list_loacation.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenShopSign extends StatefulWidget {
  String title;

  ScreenShopSign({this.title});

  @override
  _ScreenShopSignState createState() => _ScreenShopSignState();
}

class _ScreenShopSignState extends State<ScreenShopSign> {
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List _list = [
    "Phổ thông",
    "Quy chẩn việt nam",
    "Công nghệ truy xuất",
    "Xuất khẩu"
  ];
  List _listQuymo = ["Nhỏ", "Trung bình", "Lớn", "Rất Lớn"];
  String scale = "Nhỏ";
  LocationBloc bloc = new LocationBloc();
  String valueLocation;
  String key1;
  String key2;
  String key3;

  List listtype = [];
  List<int> list2 = [];

  String valueTinh;
  String valueQuan;
  String valuePhuong;

  UserBloc _userBloc = new UserBloc();
  TextEditingController name = TextEditingController();
  TextEditingController name_contact = TextEditingController();
  TextEditingController cmt = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dkkd = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController des = TextEditingController();
  TextEditingController addressAuth = TextEditingController();
  TextEditingController tinh = TextEditingController();
  TextEditingController quan = TextEditingController();
  TextEditingController phuong = TextEditingController();

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
        title: Text(widget.title),
      ),
      key: _scaffoldKey1,
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
                      'Tạo doanh nghiệp',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8f8b21),
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // ten
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tên doanh nghiệp (*)",
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
                              return 'Tên doanh nghiệp không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //loai doanh nghiep
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Loại doanh nghiệp (*)",
                          style:
                              TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        listtype.length > 0
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1, color: Color(0xff8f8b21))),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
                                  padding: EdgeInsets.all(5),
                                  childAspectRatio: 6,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  children: List.generate(
                                      listtype.length,
                                      (index) => Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey),
                                            child: Center(
                                                child: Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      if (listtype[index]
                                                              .toString() ==
                                                          _list[0].toString()) {
                                                        list2.removeAt(index);
                                                      } else if (listtype[index]
                                                              .toString() ==
                                                          _list[1].toString()) {
                                                        list2.removeAt(index);
                                                      } else if (listtype[index]
                                                              .toString() ==
                                                          _list[2].toString()) {
                                                        list2.removeAt(index);
                                                      } else if (listtype[index]
                                                              .toString() ==
                                                          _list[3].toString()) {
                                                        list2.removeAt(index);
                                                      }
                                                      listtype.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Text(
                                                    listtype[index],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            )),
                                          )),
                                ),
                              )
                            : Center(),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField(
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
                            if (listtype.length > 0) {
                              if (!listtype.contains(value)) {
                                if (listtype.length < 4) {
                                  listtype.add(value);
                                  if (value == _list[0]) {
                                    list2.add(1);
                                  } else if (value == _list[1]) {
                                    list2.add(2);
                                  } else if (value == _list[2]) {
                                    list2.add(3);
                                  } else if (value == _list[3]) {
                                    list2.add(4);
                                  }
                                }
                              }
                            } else {
                              if (listtype.length < 4) {
                                listtype.add(value);
                                if (value == _list[0]) {
                                  list2.add(1);
                                } else if (value == _list[1]) {
                                  list2.add(2);
                                } else if (value == _list[2]) {
                                  list2.add(3);
                                } else if (value == _list[3]) {
                                  list2.add(4);
                                }
                              }
                            }
                            setState(() {});
                          },
                          items: _list
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Loại doanh nghiệp không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
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
                          controller: name_contact,
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
                  // CMT
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Số CMT (*)",
                          style:
                              TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: cmt,
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
                              return 'Số CMT không được để trống';
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
                  //Quy mo doanh nghiep
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quy mô doanh nghiệp",
                          style:
                              TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField(
                          value: scale,
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
                            scale = value;
                          },
                          items: _listQuymo
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  // Giấy CNDKKD
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Số giấy CNDKKD (*)",
                          style:
                              TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: dkkd,
                          style: TextStyle(fontSize: 16),
                          keyboardType: TextInputType.number,
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
                              return 'Số giấy CNDKKD không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  // Ngày cấp
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ngày cấp (*)",
                          style:
                              TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: date,
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            ).then((value) {
                              setState(() {
                                if (value != null) {
                                  // birth_param = value;
                                  final dateFormat =
                                      new DateFormat('dd-MM-yyyy');
                                  date.text =
                                      dateFormat.format(value).toString();
                                }
                              });
                            });
                          },
                          style: TextStyle(fontSize: 16),
                          // keyboardType: TextInputType.number,
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
                              return 'Ngày cấp không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  // Nơi cấp
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nơi cấp (*)",
                          style:
                              TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 16),
                          controller: addressAuth,
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
                                          title: "Nơi cấp",
                                          idTinh: '',
                                          idQuan: '',
                                          index: "",
                                        )));
                            if (result != null) {
                              addressAuth.text = result.name;
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Nơi cấp không được để trống';
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
                            if (result != null) {
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
                            if (tinh.text != "") {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListLocation(
                                            title: "Quận/Huyện",
                                            idTinh: key1,
                                            idQuan: '',
                                            index: "",
                                          )));
                              if (result != null) {
                                quan.text = result.name;
                                key2 = result.id;
                                phuong.text = "";
                              }
                            } else {
                              showToast("Vui nhập tĩnh thành phố ", context,
                                  Colors.grey, Icons.error_outline);
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
                            if (tinh.text != "" && quan.text != "") {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListLocation(
                                            title: "Phường/Xã",
                                            idTinh: '',
                                            idQuan: key2,
                                            index: "",
                                          )));
                              if (result != null) {
                                phuong.text = result.name;
                                key3 = result.id;
                              }
                            } else {
                              showToast("Vui nhập tĩnh thành phố và quận huyện",
                                  context, Colors.grey, Icons.error_outline);
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
                  // thong tin chi tiet
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thông tin chi tiết",
                          style:
                              TextStyle(color: Color(0xff8f8b21), fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: des,
                          maxLines: 8,
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
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState.validate()) {
                            Future<SharedPreferences> _prefs =
                                SharedPreferences.getInstance();
                            final SharedPreferences prefs = await _prefs;
                            LoadingDialog.showLoadingDialog(
                                context, "Loading...");
                            var res = await _userBloc.insertShop(
                              name.text,
                              list2,
                              key1,
                              key2,
                              key3,
                              name_contact.text,
                              phone.text,
                              cmt.text,
                              address.text,
                              des.text,
                              scale,
                              dkkd.text,
                              date.text,
                              addressAuth.text,
                            );

                            LoadingDialog.hideLoadingDialog(context);
                            if (res != null) {
                              if (res['code'] == 1) {
                                showToast("Tạo doanh nghiệp thành công",
                                    context, Colors.greenAccent, Icons.check);
                                await prefs.remove("isShop");
                                await prefs.remove("name_Shop");
                                await prefs.setBool("isShop", true);
                                await prefs.setString("name_Shop", name.text);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(
                                      page: 4,
                                      prefs: prefs,
                                    ),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                MsgDialog.showMsgDialog(
                                    context, res['error'] != null && res['error'] != ""
                                    ? res['error']
                                    : "Lỗi dữ liệu", "Lỗi");
                              }
                            } else {
                              await prefs.remove("name_Shop");
                              await prefs.setString("name_Shop", name.text);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(
                                    page: 4,
                                    prefs: prefs,
                                  ),
                                ),
                                    (Route<dynamic> route) => false,
                              );
                            }
                          }
                        },
                        child: Text(
                          'Tạo doanh nghiệp',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
