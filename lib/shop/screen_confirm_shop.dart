import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/Home_Fragments/home.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:gcaeco_app/shop/transport.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../screen/dialog/msg_dialog.dart';

class ConfirmShop extends StatefulWidget {
  @override
  _ConfirmShopState createState() => _ConfirmShopState();
}

class _ConfirmShopState extends State<ConfirmShop> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController number_auth = TextEditingController();
  TextEditingController number_paper_auth = TextEditingController();
  TextEditingController date_auth = TextEditingController();
  TextEditingController cmt = TextEditingController();
  TextEditingController address_auth = TextEditingController();
  ShopBloc _bloc = new ShopBloc();
  Future<File> file;
  List imgs = [];
  List images = [];
  bool addimg = true;
  bool addimg1 = true;
  List iddel = [];
  update(List file1, List dels1, cmt1, number_auth1, number_paper_auth1,
      date_auth1, address_auth1) async {
    var res = await _bloc.shopAuth(file1, dels1, cmt1, number_auth1,
        number_paper_auth1, date_auth1, address_auth1);
    if (res != null) {
      if (res['code'] == 1) {
        showToast(
            "Lưu thông tin thành công", context, Colors.grey, Icons.check);
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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Xác thực doanh nghiệp"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              var res = await _bloc.shopAuth(
                  imgs,
                  iddel,
                  cmt.text,
                  number_auth.text,
                  number_paper_auth.text,
                  date_auth.text,
                  address_auth.text);
              if (res != null) {
                if (res['code'] == 1) {
                  showToast("Lưu thông tin thành công", context, Colors.grey,
                      Icons.check);
                } else {
                  showToast(
                      "Lỗi dữ liệu", context, Colors.grey, Icons.error_outline);
                }
              } else {
                showToast(
                    "Lỗi kết nối", context, Colors.grey, Icons.error_outline);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _bloc.getShopAuth(),
        builder: (_, sanpshot) {
          if (sanpshot.hasData) {
            cmt.text = sanpshot.data['data']['cmt'];
            number_auth.text = sanpshot.data['data']['number_auth'];
            number_paper_auth.text = sanpshot.data['data']['number_paper_auth'];
            address_auth.text = sanpshot.data['data']['address_auth'];
            date_auth.text = sanpshot.data['data']['date_auth'];
            if (addimg1) {
              images = [];
              images.addAll(sanpshot.data['images']);
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20),
                    child: SizedBox(
                      child: Text(
                        'Đăng ảnh giấy tờ chứng thực',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Config.green,
                            fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          child: Text(
                            "Lưu ý:",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 17),
                          ),
                        ),
                        Flexible(
                          flex: 8,
                          child: Text(
                            "Hãy điền đầy đủ thông tin và chính xác để được hưởng những quyền dành riêng cho loại doanh nghiệp.",
                            style: TextStyle(color: Colors.green, fontSize: 17),
                            textAlign: TextAlign.justify,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //cmt
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 10,
                      right: 10,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Số CMT",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    cmt.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        showMsgDialogEdt(
                                            context, cmt, "Số CMT");
                                      },
                                      child: Icon(Icons.edit)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //ma so thue
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 10,
                      right: 10,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Mã số thuế",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    number_auth.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        showMsgDialogEdt(
                                            context, number_auth, "Mã số thuế");
                                      },
                                      child: Icon(Icons.edit)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //cndkkd
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 10,
                      right: 10,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Số giấy CNĐKKD",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    number_paper_auth.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        showMsgDialogEdt(
                                            context,
                                            number_paper_auth,
                                            "Số giấy CNĐKKD");
                                      },
                                      child: Icon(Icons.edit)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //noi cap
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 10,
                      right: 10,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Nơi Cấp",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    address_auth.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        showMsgDialogEdt(
                                            context, address_auth, "Nơi cấp");
                                      },
                                      child: Icon(Icons.edit)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //ngay cap
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 10,
                      right: 10,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "Ngày cấp",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    date_auth.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100))
                                            .then((value) {
                                          String end =
                                              DateFormat('dd-MM-yyyy', 'en_US')
                                                  .format(DateTime.parse(
                                                      value.toString()));
                                          date_auth.text = end;
                                          update(null, null, null, null, null,
                                              date_auth.text, null);
                                        });
                                      },
                                      child: Icon(Icons.edit)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 10,
                      right: 10,
                    ),
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  //them anh
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Text(
                            "2 mặt CMT hoăc thẻ căn cước, hộ chiếu (bắt buộc), đăng ký kinh doanh, giấy tờ khác (nếu có)",
                            maxLines: 6,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: InkWell(
                            onTap: () {
                              if (imgs.length > 10) {
                                showToastErr("Tối đa 10 ảnh cho 1 shop",
                                    context, Colors.red, Icons.error_outline);
                              } else {
                                addimg = true;
                                file = ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Config().colorMain),
                              child: Center(
                                  child: Text(
                                'Thêm ảnh',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  showAvt(images),
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
                    //List file,List dels, cmt, number_auth, number_paper_auth, date_auth,address_auth
                    if (title == 'Số CMT') {
                      update(null, null, cmt.text, null, null, null, null);
                    } else if (title == 'Mã số thuế') {
                      update(
                          null, null, null, number_auth.text, null, null, null);
                    } else if (title == 'Số giấy CNĐKKD') {
                      update(null, null, null, null, number_paper_auth.text,
                          null, null);
                    } else if (title == 'Nơi cấp') {
                      update(null, null, null, null, null, null,
                          address_auth.text);
                    }
                    Navigator.of(context).pop(MsgDialog);
                  },
                ),
                FlatButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop(MsgDialog);
                  },
                ),
              ],
            ));
  }

  Widget showAvt(List images) {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          if (imgs.length > 0) {
            if (imgs[imgs.length - 1] != snapshot.data && addimg) {
              imgs.add(snapshot.data);
            }
          } else if (addimg) {
            imgs.add(snapshot.data);
          }
          if (images.length > 0 && imgs.length > 0) {
            return avatarSuccess(imgs, images);
          } else if (images.length > 0 && imgs.length == 0) {
            return avatarSuccess(imgs, images);
          } else if (images.length == 0 && imgs.length > 0) {
            return avatarSuccess(imgs, images);
          } else {
            return avatarSuccess(imgs, images);
          }
        } else if (images.length > 0) {
          return avatarSuccess(imgs, images);
        } else {
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1)),
          );
        }
      },
    );
  }

  Widget avatarSuccess(List imgs, List images) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1)),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.8,
        children: List.generate(
            images.length + imgs.length,
            (index) => Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      images.length > 0 && index <= (images.length - 1)
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                        Const().image_host +
                                            images[index].path +
                                            images[index].name,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        showMsgDialog1(
                                            context,
                                            "Bạn có muốn xóa ảnh này không",
                                            index);
                                      },
                                      child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              Colors.black.withOpacity(0.8),
                                          child: Icon(Icons.close,
                                              color: Colors.white)),
                                    ))
                              ],
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.file(
                                        imgs[index - images.length],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        showMsgDialog(
                                            context,
                                            "Bạn có muốn xóa ảnh này không",
                                            index);
                                      },
                                      child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              Colors.black.withOpacity(0.8),
                                          child: Icon(Icons.close,
                                              color: Colors.white)),
                                    ))
                              ],
                            ),
                    ],
                  ),
                )),
      ),
    );
  }

  showMsgDialog(BuildContext context, String title, index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Xóa'),
                  onPressed: () {
                    imgs.removeAt(index);
                    addimg = false;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  showMsgDialog1(BuildContext context, String title, index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Xóa'),
                  onPressed: () {
                    iddel.add(images[index].id);
                    images.removeAt(index);
                    setState(() {
                      addimg1 = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
