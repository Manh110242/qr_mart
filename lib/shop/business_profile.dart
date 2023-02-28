import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/shop/products_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_elapsed/time_elapsed.dart';

class BusinessProfile extends StatefulWidget {
  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  ShopBloc _bloc = ShopBloc();
  String quymo;
  File certificate;
  String timeNow = DateTime.now().toString();
  TextEditingController email = new TextEditingController();
  TextEditingController website = new TextEditingController();
  TextEditingController facebook = new TextEditingController();
  TextEditingController zalo = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController scale = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getType(data) {
    var type;
    if (data == "1") {
      type = "Phổ thông";
    } else if (data == "2") {
      type = "Quy chuẩn việt nam";
    } else if (data == "3") {
      type = "Công nghệ truy xuất";
    } else if (data == "4") {
      type = "Xuất khẩu";
    }
    return type;
  }

  setTime(int timestamp) {
    DateTime _timeDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String timedata = "";
    timeNow = TimeElapsed.fromDateTime(_timeDate);
    if (timeNow == "Now") {
      timedata = "Đang cập nhật";
    } else if (timeNow.substring(timeNow.length - 1, timeNow.length) == "w") {
      var time = timeNow.substring(0, timeNow.length - 1);
      int timeLast = int.parse(time);
      if (timeLast <= 4) {
        timedata = timeNow.substring(0, timeNow.length - 1) + " tuần trước";
      } else if (timeLast > 4 && ((timeLast * 7) / 30).round() <= 12) {
        timedata = ((timeLast * 7) / 30).round().toString() + " tháng trước";
      } else {
        timedata = ((timeLast * 7) / 30 / 12).round().toString() + " năm trước";
      }
    } else if (timeNow.substring(timeNow.length - 1, timeNow.length) == "d") {
      timedata = timeNow.substring(0, timeNow.length - 1) + " ngày trước";
    } else if (timeNow.substring(timeNow.length - 1, timeNow.length) == "h") {
      timedata = timeNow.substring(0, timeNow.length - 1) + " giờ trước";
    } else if (timeNow.substring(timeNow.length - 1, timeNow.length) == "m") {
      timedata = timeNow.substring(0, timeNow.length - 1) + " phút trước";
    }
    return timedata;
  }

  update(scale1, email1, website1, facebook1, zalo1, description1) async {
    LoadingDialog.showLoadingDialog(context, "Đang tải...");
    var res = await _bloc.updateShop(
        scale1, email1, website1, facebook1, zalo1, description1,
        certificate: certificate);
    LoadingDialog.hideLoadingDialog(context);
    if (res != null) {
      if (res['code'] == 1) {
        showToast("Cập nhật thành công", context, Colors.grey, Icons.check);
      } else {
        showToast("Lỗi dữ liệu", context, Colors.grey, Icons.error_outline);
      }
    } else {
      showToast("Lỗi kết nối", context, Colors.grey, Icons.error_outline);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Hồ sơ doanh nghiệp"),
      ),
      body: FutureBuilder(
        future: _bloc.getShop(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var shop = snapshot.data["data"];
            var time = setTime(shop['created_time']);
            List abc = [];
            email.text = shop['email'];
            website.text = shop['website'];
            facebook.text = shop['facebook'];
            zalo.text = shop['zalo'];
            description.text = shop['description'];
            snapshot.data['scales'].forEach((k, v) {
              if (shop['scale'].toString() == v.toString()) {
                scale.text = v;
              }
            });
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  shop['status'] == 1
                      ? Center()
                      : Text(
                          'Gian hàng quý khách đăng chờ được duyệt.',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                  shop['status'] == 1
                      ? Center()
                      : Text(
                          "Vui lòng đợi tối đa là 24h.",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 4,
                        child: Text(
                          "Thời gian hoạt động",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Row(
                          children: [
                            Text(
                              time.toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Sản phẩm",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data['total_products'] != null
                                    ? snapshot.data['total_products'].toString()
                                    : 0,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductsManager()));
                                },
                                child: Text(
                                  "Xem tất cả",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Color(0xffdbbf6d),
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Đánh giá",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                shop['rate'] != null
                                    ? shop['rate'].toString()
                                    : "Không có",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Quy mô doanh nghiệp",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  scale.text != ""
                                      ? scale.text
                                      : shop["scale"] != null && quymo != null
                                          ? quymo
                                          : "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    showMsgDialog(
                                        context, "Quy mô doanh nghiệp", abc);
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Loại doanh nghiệp",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Text(
                            shop["type"] != null ? shop["type"] : "",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 8,
                                child: Text(
                                  email.text != ""
                                      ? email.text
                                      : shop['email'] != null
                                          ? shop['email']
                                          : "",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    showMsgDialogEdt(context, email, "Email");
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Điện thoại",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 8,
                                child: Text(
                                  shop['phone'] != null ? shop['phone'] : "",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Website",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 8,
                                child: Text(
                                  website.text != ""
                                      ? website.text
                                      : shop['website'] != null
                                          ? shop['website']
                                          : "",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    showMsgDialogEdt(
                                        context, website, "Website");
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Facebook",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 8,
                                child: Text(
                                  facebook.text != ""
                                      ? facebook.text
                                      : shop['facebook'] != null
                                          ? shop['facebook']
                                          : "",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    showMsgDialogEdt(
                                        context, facebook, "Facebook");
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Zalo",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 8,
                                child: Text(
                                  zalo.text != ""
                                      ? zalo.text
                                      : shop['zalo'] != null
                                          ? shop['zalo']
                                          : "",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    showMsgDialogEdt(context, zalo, "Zalo");
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Mô tả thêm",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 8,
                                child: Text(
                                  description.text != ""
                                      ? description.text
                                      : shop['description'] != null
                                          ? shop['description']
                                          : "",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    showMsgDialogEdt(
                                        context, description, "Mô tả thêm");
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  showMsgDialogEdt(
      BuildContext context, TextEditingController sc, String title) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              content: TextField(
                decoration: InputDecoration(
                  hintText: title,
                ),
                controller: sc,
                style: TextStyle(fontSize: 14),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Lưu'),
                  onPressed: () {
                    //scale,email,website,facebook,zalo,description,
                    if (title == "Email") {
                      update(null, email.text, null, null, null, null);
                    } else if (title == "Website") {
                      update(null, null, website.text, null, null, null);
                    } else if (title == "Facebook") {
                      update(null, null, null, facebook.text, null, null);
                    } else if (title == "Zalo") {
                      update(null, null, null, null, zalo.text, null);
                    } else if (title == "Mô tả thêm") {
                      update(null, null, null, null, null, description.text);
                    }
                    Navigator.of(context).pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                ),
              ],
            ));
  }

  showMsgDialog(BuildContext context, String title, List list) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              content: DropdownButtonFormField(
                value: scale.text,
                style: TextStyle(color: Config.green),
                decoration: InputDecoration(
                  errorText: null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Config.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Config.green, width: 3),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Config.green)),
                ),
                hint: Text(
                  "--Chọn loại doanh nghiêp--",
                  style: TextStyle(color: Config.green),
                ),
                onChanged: (value) {
                  scale.text = value.toString();
                },
                items: list
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Lưu'),
                  onPressed: () {
                    update(scale.text, null, null, null, null, null);
                    Navigator.of(context).pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                ),
              ],
            ));
  }
}
