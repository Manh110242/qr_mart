import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_location_mah.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/locaiton_manh.dart';
import 'package:gcaeco_app/screen/location_manh/list_loacation.dart';
import 'package:gcaeco_app/screen/location_manh/location_manh.dart';

class ItemLocationManh extends StatefulWidget {
  AddressItem addressItem;
  String title;

  ItemLocationManh({this.addressItem, this.title});

  @override
  _ItemLocationManhState createState() => _ItemLocationManhState();
}

class _ItemLocationManhState extends State<ItemLocationManh> {
  TextEditingController hoten = new TextEditingController();
  TextEditingController sodienthoai = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController diachicuthe = new TextEditingController();
  var loca = new LocationManh();
  var loca1 = new LocationManh();
  var loca2 = new LocationManh();
  var bloc;
  String idTinh, idQuan, txtQuan;
  int isdefault = 0;
  bool click = false;

  void diachi() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (hoten.text == '') {
      showToast("Xin vui lòng nhập Họ & Tên.", context, Colors.orange,
          Icons.error_outline);
    } else if (sodienthoai.text == '') {
      showToast("Xin vui lòng nhập Số điện thoại.", context, Colors.orange,
          Icons.error_outline);
    } else if (sodienthoai.text.length > 12) {
      showToast("Số điện thoại không được vượt quá 12 ký tự.", context,
          Colors.orange, Icons.error_outline);
    } else if (sodienthoai.text.length < 10) {
      showToast("Số điện thoại không được dưới 10 ký tự.", context,
          Colors.orange, Icons.error_outline);
    } else if (email.text == '') {
      showToast(
          "Vui lòng nhập Email.", context, Colors.orange, Icons.error_outline);
    } else if (loca == null && widget.addressItem.id == '') {
      showToast("Vui lòng nhập Tỉnh/Thành phố.", context, Colors.orange,
          Icons.error_outline);
    } else if (loca1 == null && widget.addressItem.id == '') {
      showToast("Vui lòng nhập Quận/Huyện.", context, Colors.orange,
          Icons.error_outline);
    } else if (loca2 == null && widget.addressItem.id == '') {
      showToast("Vui lòng nhập Phường/Xã.", context, Colors.orange,
          Icons.error_outline);
    } else if (diachicuthe.text == '') {
      showToast("Vui lòng nhập địa chỉ cụ thể.", context, Colors.orange,
          Icons.error_outline);
    } else {
      if (widget.addressItem.id == '') {
        await addAress();
      } else if (loca != null &&
          loca1 != null &&
          loca2 != null &&
          widget.addressItem.id != "") {
        await updateArssloca();
      } else if (loca != null && loca1 == null && loca2 == null) {
        await updateArssloca1();
      } else if (loca != null && loca1 != null && loca2 == null) {
        await updateArssloca2();
      } else if (loca == null && loca1 == null && loca2 == null) {
        await updateAress();
      } else if (widget.addressItem.id != "") {
        await updateAress();
      } else {
        showToast("Lỗi. Vui lòng kiểm tra lại thông tin bên trên.", context,
            Colors.orange, Icons.error_outline);
      }
    }
  }

  updateArssloca() async {
    var res = await bloc.locationUpdate(
        widget.addressItem.id,
        hoten.text,
        sodienthoai.text,
        email.text,
        loca.id,
        loca1.id,
        loca2.id,
        diachicuthe.text,
        isdefault);
    checkrescode(res);
  }

  updateArssloca1() async {
    var res = await bloc.locationUpdate(
        widget.addressItem.id,
        hoten.text,
        sodienthoai.text,
        email.text,
        loca.id,
        widget.addressItem.district_id,
        widget.addressItem.ward_id,
        diachicuthe.text,
        isdefault);
    checkrescode(res);
  }

  updateArssloca2() async {
    var res = await bloc.locationUpdate(
        widget.addressItem.id,
        hoten.text,
        sodienthoai.text,
        email.text,
        loca.id,
        loca1.id,
        widget.addressItem.ward_id,
        diachicuthe.text,
        isdefault);
    checkrescode(res);
  }

  updateAress() async {
    var location = widget.addressItem;
    var res = await bloc.locationUpdate(
        location.id,
        hoten.text,
        sodienthoai.text,
        email.text,
        location.province_id,
        location.district_id,
        location.ward_id,
        diachicuthe.text,
        isdefault);
    checkrescode(res);
  }

  addAress() async {
    var res = await bloc.locationPost(hoten.text, sodienthoai.text, email.text,
        loca.id, loca1.id, loca2.id, diachicuthe.text, isdefault);
    checkrescode(res);
  }

  deleteAress() async {
    var res = await bloc.locationDelete(widget.addressItem.id.toString());
    if (res != null) {
      if (res["code"] == 1) {
        showToast("Xóa địa chỉ thành công", context, Colors.green, Icons.check);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DiaChiScreen(title: "Địa chỉ")),
          ModalRoute.withName('/'),
        );
      } else {
        showToast(res["error"].toString(), context, Colors.orange,
            Icons.error_outline);
      }
    } else {
      showToast('Lỗi kết nối.', context, Colors.orange, Icons.error_outline);
    }
  }

  checkrescode(dynamic res) {
    if (res != null) {
      if (res["code"] == 1) {
        showToast(
            "Cập nhật địa chỉ thành công", context, Colors.green, Icons.check);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DiaChiScreen(title: "Địa chỉ")),
          ModalRoute.withName('/'),
        );
      } else {
        showToast(res["error"].toString(), context, Colors.orange,
            Icons.error_outline);
      }
    } else {
      showToast('Lỗi kết nối.', context, Colors.orange, Icons.error_outline);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new LocationBloc();
    bloc.loacationBlocTinh();
    bloc.locationQuan(idTinh);

    if (widget.addressItem.id != '') {
      hoten.text = widget.addressItem.name_contact;
      sodienthoai.text = widget.addressItem.phone;
      email.text = widget.addressItem.email;
      diachicuthe.text = widget.addressItem.address;
      if (widget.addressItem.isdefault == '1') {
        setState(() {
          click = true;
        });
      } else {
        setState(() {
          click = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Hoten(),
            SizedBox(
              height: 1,
            ),
            Sodienthoai(),
            SizedBox(
              height: 1,
            ),
            Email(),
            SizedBox(
              height: 1,
            ),
            TinhThanhPho(),
            SizedBox(
              height: 1,
            ),
            QuanHuyen(),
            SizedBox(
              height: 1,
            ),
            PhuongXa(),
            SizedBox(
              height: 1,
            ),
            Diachicuthe(),
            SizedBox(
              height: 5,
            ),
            (widget.addressItem.id != "") ? Xoadiachi() : Container(),
            SizedBox(
              height: 5,
            ),
            MacDinh(),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () {
                  diachi();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: Config().colorMain,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Xác Nhận',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Hoten() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 2,
              child: Text(
                "Họ & Tên",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 14),
              )),
          Flexible(
            flex: 7,
            child: TextField(
              controller: hoten,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'Họ & Tên',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Sodienthoai() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 2,
              child: Text(
                "Số điện thoại",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 14),
              )),
          Flexible(
            flex: 7,
            child: TextField(
              controller: sodienthoai,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  hintText: 'Số điện thoại', border: InputBorder.none),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget Email() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 2,
              child: Text(
                "Email",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 14),
              )),
          Flexible(
            flex: 7,
            child: TextField(
              controller: email,
              textAlign: TextAlign.right,
              decoration:
                  InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      ),
    );
  }

  Widget TinhThanhPho() {
    return StreamBuilder(
        stream: bloc.addTinhDefaultStream,
        builder: (context, AsyncSnapshot<LocationManh> snapshot) {
          loca = snapshot.data;
          return Container(
            color: Colors.white,
            height: 50,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 4,
                    child: Text(
                      "Tỉnh/Thành phố",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )),
                Flexible(
                  flex: 6,
                  child: InkWell(
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
                        bloc.setDefault(result);
                        loca = result;
                        idTinh = loca.id;
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                            flex: 6,
                            child: (widget.addressItem.id != '' && loca == null)
                                ? Text(
                                    widget.addressItem.province_name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  )
                                : (loca == null)
                                    ? Text(
                                        "Điền Tỉnh/Thành phố",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      )
                                    : Text(
                                        loca.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )),
                        Flexible(
                            flex: 4,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black54,
                              size: 20,
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget QuanHuyen() {
    return StreamBuilder(
        stream: bloc.addQuanDefaultStream,
        builder: (context, AsyncSnapshot<LocationManh> snapshot) {
          loca1 = snapshot.data;
          return Container(
            color: Colors.white,
            height: 50,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 4,
                    child: Text(
                      "Quận/Huyện",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )),
                Flexible(
                  flex: 6,
                  child: InkWell(
                    onTap: () async {
                      if (loca != null ||
                          widget.addressItem.province_id != "") {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListLocation(
                                      title: "Quận/Huyện",
                                      idTinh: (widget.addressItem.province_id !=
                                                  "" &&
                                              loca == null)
                                          ? widget.addressItem.province_id
                                          : idTinh,
                                      idQuan: '',
                                  index: "",
                                    )));
                        if (result != null) {
                          bloc.setDefaultQuan(result);
                          loca1 = result;
                          idQuan = loca1.id;
                        }
                      } else {
                        showToast("Vui lòng nhập Tỉnh/Thành phố.", context,
                            Colors.grey, null);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 7,
                          child: (widget.addressItem.id != '' && loca1 == null)
                              ? Text(
                                  widget.addressItem.district_name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )
                              : (loca1 == null)
                                  ? Text(
                                      "Điền Quận/Huyện",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    )
                                  : Text(
                                      loca1.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // "Phường/Xã"
  Widget PhuongXa() {
    return StreamBuilder(
        stream: bloc.addPhuongDefaultStream,
        builder: (context, AsyncSnapshot<LocationManh> snapshot) {
          loca2 = snapshot.data;
          return Container(
            color: Colors.white,
            height: 50,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 4,
                    child: Text(
                      "Phường/Xã",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )),
                Flexible(
                  flex: 6,
                  child: InkWell(
                    onTap: () async {
                      if (loca1 != null ||
                          widget.addressItem.district_id != "") {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListLocation(
                                      title: "Phường/Xã",
                                      idTinh: '',
                                      idQuan: (widget.addressItem.district_id !=
                                                  "" &&
                                              loca == null)
                                          ? widget.addressItem.district_id
                                          : idQuan,
                                  index: "",
                                    )));
                        if (result != null) {
                          bloc.setDefaultPhuong(result);
                          loca2 = result;
                        }
                      } else {
                        showToast("Vui lòng nhập Quận/Huyện.", context,
                            Colors.grey, null);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                            flex: 6,
                            child:
                                (widget.addressItem.id != '' && loca2 == null)
                                    ? Text(
                                        widget.addressItem.ward_name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )
                                    : (loca2 == null)
                                        ? Text(
                                            "Điền Phường/Xã",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          )
                                        : Text(
                                            loca2.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )),
                        Flexible(
                            flex: 4,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black54,
                              size: 20,
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget Diachicuthe() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Địa chỉ cụ thể",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          Text(
            "Số nhà, tên tòa nhà, tên đường, tên khu vực",
            style: TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: diachicuthe,
            decoration: InputDecoration(
                hintText: 'Nhập địa chỉ cụ thể', border: InputBorder.none),
          ),
        ],
      ),
    );
  }

  Widget MacDinh() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 7,
            child: Text(
              "Đặt làm địa chỉ mặc định",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          CupertinoSwitch(
            activeColor: Config().colorMain,
            value: click,
            onChanged: (value) {
              setState(() {
                click = value;
                if (value == true) {
                  isdefault = 1;
                } else {
                  isdefault = 0;
                }
              });
            },
          )
        ],
      ),
    );
  }

  Widget Xoadiachi() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          deleteAress();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Text(
            "Xóa địa chỉ",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.red, fontSize: 14),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
