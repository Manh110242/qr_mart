import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/MarqueeWidget.dart';
import 'package:gcaeco_app/model/groups.dart';
import 'package:gcaeco_app/model/locaiton_manh.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/location_manh/list_loacation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/user.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class ScreenProfile extends StatefulWidget {
  ScreenProfile({this.res});

  var res;

  @override
  _ScreenProfile_State createState() => _ScreenProfile_State();
}

// ignore: camel_case_types
class _ScreenProfile_State extends State<ScreenProfile> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController sexController = new TextEditingController();
  TextEditingController birthController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController pass2Controller = new TextEditingController();
  TextEditingController groupController = new TextEditingController();
  TextEditingController cmt = new TextEditingController();

  Dio dio = new Dio();
  Future<File> file;
  File _file;
  File certificate;
  int _sexChoose;
  bool check = true;
  final dateFormat = new DateFormat('dd-MM-yyyy');
  DateTime birth_param;
  UserBloc bloc;
  var group = new LocationManh();
  User user = new User();
  var data;
  List<LocationManh> listGroups = [];
  List<Groups> lvgroups = [];
  File _image;
  final picker = ImagePicker();
  var pickedFile;
  var sdata;
  String sexcheck;
  String ngay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = UserBloc();
    getDataUser();
    getGroups();
  }

  Future getImage(ImageSource imageSource) async {
    pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  getGroups() async {
    var groupsdata = await bloc.getGroups();
    var groupsUser = await bloc.getGroupUser();
    listGroups = groupsdata;
    lvgroups = groupsUser;
    List<String> dataGroup = new List<String>();
    if (lvgroups != null) {
      if (lvgroups.length > 0) {
        for (var data in lvgroups) {
          String name = data.name;
          dataGroup.add(name);
        }
        const start = "[";
        const end = "]";
        final startIndex = dataGroup.toString().indexOf(start);
        final endIndex =
            dataGroup.toString().indexOf(end, startIndex + start.length);
        sdata =
            dataGroup.toString().substring(startIndex + start.length, endIndex);

        setState(() {
          groupController.text = sdata;
        });
      } else {
        setState(() {
          groupController.text = "";
        });
      }
    } else {
      setState(() {
        groupController.text = "";
      });
    }
  }

  postGroup() async {
    if (group.id != null && _image != null) {
      LoadingDialog.showLoadingDialog(context, "Đang tải...");
      var post = await bloc.postGroup(group.id.toString(), _image);
      LoadingDialog.hideLoadingDialog(context);
      if (post != null) {
        if (post["code"] == 1) {
          MsgDialog.showMsgDialog(
              context, post["message"].toString(), "Thành công");
        } else {
          MsgDialog.showMsgDialog(context, post["error"].toString(), "Lỗi");
        }
      }
    } else if (groupController.text == sdata) {
      MsgDialog.showMsgDialog(
          context,
          'Bạn chưa chọn lĩnh vực công việc của mình.\n Ví dụ: Bạn là học sinh, sinh viên ...',
          "Lỗi");
    } else if (_image == null) {
      MsgDialog.showMsgDialog(context, 'Chưa chọn ảnh thẻ xác thực', "Lỗi");
    }
  }

  getDataUser() async {
    data = await bloc.getUser();
    if (data != null) {
      setState(() {
        user = data;
        if (user.username != "null") {
          nameController.text = user.username;
        } else {
          nameController.text = "";
        }
        if (user.email != "null") {
          emailController.text = user.email;
        } else {
          emailController.text = "";
        }
        if (user.phone != "null") {
          phoneController.text = user.phone;
        } else {
          phoneController.text = "";
        }
        if (user.cmt != "null") {
          cmt.text = user.cmt;
        } else {
          cmt.text = "";
        }
        if (user.sex != "null") {
          if (user.sex == "0") {
            sexController.text = "Nữ";
            sexcheck = "Nữ";
            _sexChoose = 0;
          } else {
            sexController.text = "Nam";
            sexcheck = "Nam";
            _sexChoose = 1;
          }
        } else {
          sexController.text = "";
        }
        if (user.birthday != "null") {
          int time = int.parse(user.birthday) * 1000;
          ngay = DateFormat('dd-MM-yyyy')
              .format(DateTime.fromMillisecondsSinceEpoch(time));
          birthController.text = ngay;
        } else {
          birthController.text = "";
        }
        if (user.addressItem != null) {
          addressController.text = user.addressItem.address +
              ", " +
              user.addressItem.ward_name +
              ", " +
              user.addressItem.district_name +
              ", " +
              user.addressItem.province_name;
        } else {
          addressController.text = "";
        }
      });
    }
  }

  postDataUser(BuildContext context) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String sex;
    var post;
    if (sexController.text == "Nữ") {
      setState(() {
        sex = "0";
        _sexChoose = 0;
      });
    } else if (sexController.text == "Nam") {
      setState(() {
        sex = "1";
        _sexChoose = 1;
      });
    }
    LoadingDialog.showLoadingDialog(context, "Đang tải...");

    var updatedata = await bloc.update(
      nameController.text,
      sex,
      birthController.text,
      emailController.text,
      phoneController.text,
      _file,
      pass2Controller.text,
      cmt.text, certificate
    );
    LoadingDialog.hideLoadingDialog(context);
    if (updatedata != null) {
      if (updatedata["code"] == 1) {
        if (post == null) {
          prefs.setString('username', updatedata['data']['username'].toString());
          prefs.setString('avatar_path', updatedata['data']['avatar_path'].toString());
          prefs.setString('avatar_name', updatedata['data']['avatar_name'].toString());
          MsgDialog.showMsgDialog(context,"Lưu thông tin thành công", "Thành công",onPressed: (){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                      page: 4,
                      prefs: prefs,
                    )),
                ModalRoute.withName("/"));
          });
        } else {
          if (post['code'] == 0) {
            MsgDialog.showMsgDialog(
                context, "Bạn chưa chọn ảnh xác thực", "Lỗi");
          } else {
            MsgDialog.showMsgDialog(
                context, "Lưu thông tin thành công", "Thành công");
          }
        }
      } else {
        if (updatedata['error'] == null || updatedata['error'] == "") {
          if (updatedata["data"]['phone'] != null) {
            MsgDialog.showMsgDialog(
                context, updatedata["data"]['phone'][0].toString(), "Lỗi");
          } else if (updatedata["data"]['birthday'] != null) {
            MsgDialog.showMsgDialog(
                context, updatedata["data"]['birthday'][0].toString(), "Lỗi");
          } else if (updatedata["data"]['email'] != null) {
            MsgDialog.showMsgDialog(
                context, updatedata["data"]['email'][0].toString(), "Lỗi");
          }else if (updatedata["data"]['cmt'] != null) {
            MsgDialog.showMsgDialog(
                context, updatedata["data"]['cmt'][0].toString(), "Lỗi");
          }
        } else {
          MsgDialog.showMsgDialog(
              context, updatedata["error"].toString(), "Lỗi");
        }
      }
    } else {
      MsgDialog.showMsgDialog(context, "Lỗi kết nối", "Lỗi");
    }
  }

  getSex() {
    if (_sexChoose == 1) {
      sexController.text = "Nam";
    } else if (_sexChoose == 0) {
      sexController.text = "Nữ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Sửa hồ sơ"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 40,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if ((nameController.text != user.username &&
                              nameController.text != "") ||
                          (emailController.text != user.email &&
                              emailController.text != "") ||
                          (phoneController.text != user.phone &&
                              phoneController.text != "") ||
                          (cmt.text != user.cmt &&
                              cmt.text != "") ||
                          (sexController.text != sexcheck &&
                              sexController.text != "") ||
                          (birthController.text != ngay &&
                              birthController.text != "") ||
                          _file != null ||  certificate != null) {
                        postDataUser(context);
                      } else if (_image != null ||
                          (groupController.text != sdata &&
                              groupController.text != "")) {
                        postGroup();
                      } else {
                        MsgDialog.showMsgDialog(context,
                            "Bạn chưa cập nhật thông tin gì hết", "Lỗi");
                      }
                    },
                    child: Icon(Icons.check)),
              ),
            ),
          ),
        ],
      ),
      body: (data != null)
          ? SingleChildScrollView(
              child: Container(
                color: Colors.grey.shade300,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          file = ImagePicker.pickImage(source: ImageSource.gallery);
                        });
                      },
                      child: showAvt(),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "Tên",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 9,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              nameController.text,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: () {
                                                  showMsgDialogEdt(context,
                                                      nameController, 'Tên');
                                                },
                                                child: Icon(Icons.edit)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 8, right: 8),
                              child: Divider(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "Email",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 7,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              emailController.text,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {
                                                showMsgDialogPass2(
                                                    context,
                                                    pass2Controller,
                                                    "Mật khẩu cấp 2",
                                                    emailController,
                                                    "Email");
                                              },
                                              child: Icon(Icons.edit)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Điện thoại",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 7,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0),
                                          child: Text(
                                            phoneController.text,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {
                                                showMsgDialogPass2(
                                                    context,
                                                    pass2Controller,
                                                    "Mật khẩu cấp 2",
                                                    phoneController,
                                                    "Số điện thoại");
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
                                top: 8, bottom: 8, left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "CMT/CCCD",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 7,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0),
                                          child: Text(
                                            cmt.text,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {
                                                showMsgDialogEdt(context,
                                                    cmt, 'CMT/CCCD');
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
                                top: 8, bottom: 8, left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Giới tính",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(sexController.text),
                                    ),
                                    Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () {
                                              return showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      context) {
                                                    return AlertDialog(
                                                      title: Center(
                                                        child: Text(
                                                          'Giới tính',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent),
                                                        ),
                                                      ),
                                                      content:
                                                          StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                          return Container(
                                                            height: 120,
                                                            child: Column(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          const Text('Nam'),
                                                                      leading:
                                                                          Radio(
                                                                        value:
                                                                            1,
                                                                        groupValue:
                                                                            _sexChoose,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(() {
                                                                            _sexChoose = value;
                                                                            getSex();
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          const Text('Nữ'),
                                                                      leading:
                                                                          Radio(
                                                                        value:
                                                                            0,
                                                                        groupValue:
                                                                            _sexChoose,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(() {
                                                                            _sexChoose = value;
                                                                            getSex();
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          child:
                                                              Text('Lưu'),
                                                          onPressed: () {
                                                            setState(() {});
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    MsgDialog);
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child:
                                                              Text('Đóng'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    MsgDialog);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Icon(Icons.edit)))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Ngày sinh",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(birthController.text),
                                    ),
                                    Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100),
                                              ).then((value) {
                                                setState(() {
                                                  if (value != null) {
                                                    birth_param = value;
                                                    birthController.text =
                                                        dateFormat
                                                            .format(value)
                                                            .toString();
                                                  }
                                                });
                                              });
                                            },
                                            child: Icon(Icons.edit)))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Địa chỉ",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0),
                                          child: MarqueeWidget(
                                            direction: Axis.horizontal,
                                            animationDuration:
                                                Duration(seconds: 6),
                                            child: Text(
                                              addressController.text,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Material(
                                      //     color: Colors.transparent,
                                      //     child: InkWell(
                                      //         onTap: () {
                                      //          MsgDialog.showMsgDialogEdt(context, addressController, 'Địa chỉ');
                                      //         },
                                      //         child: Icon(Icons.edit)))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Bạn là",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0),
                                          child: MarqueeWidget(
                                            direction: Axis.horizontal,
                                            animationDuration:
                                                Duration(seconds: 6),
                                            child: Text(
                                              groupController.text,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () async {
                                                var result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ListLocation(
                                                                      title:
                                                                          "Công việc",
                                                                      idQuan:
                                                                          '',
                                                                      idTinh:
                                                                          '',
                                                                      index:
                                                                          "1",
                                                                    )));
                                                if (result != null) {
                                                  await bloc
                                                      .setDefault(result);
                                                  group = result;
                                                  setState(() {
                                                    groupController.text =
                                                        group.name;
                                                  });
                                                }
                                              },
                                              child: Icon(Icons.edit))),
                                      // Material(
                                      //     color: Colors.transparent,
                                      //     child: InkWell(
                                      //         onTap: () async{
                                      //           file = ImagePicker.pickImage(source: ImageSource.gallery);
                                      //         },
                                      //         child: Icon(Icons.camera_alt_outlined))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 7,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Chọn ảnh thẻ xác thực",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () async {
                                            getImage(ImageSource.gallery);
                                          },
                                          child: Icon(
                                              Icons.camera_alt_outlined))),
                                ),
                              ],
                            ),
                          ),
                          _image != null
                              ? Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8, right: 8),
                            child: Divider(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  showDialogInfo(context, String label, TextEditingController controller,
      TextInputType textInputType) {
    return AwesomeDialog(
      dismissOnTouchOutside: true,
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: textInputType,
              controller: controller,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      btnOkOnPress: () {},
    )..show();
  }

  Widget showAvt() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          _file = snapshot.data;
          return avatarSuccess(_file);
        } else if (null != snapshot.error) {
          return Text('Upload images not working');
        } else {
          return avatarDefault();
        }
      },
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
                    setState(() {});
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

  showMsgDialogPass2(
    BuildContext context,
    TextEditingController sc,
    String title,
    TextEditingController edt,
    String edttitle,
  ) {
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
                  child: Text('Tiếp theo'),
                  onPressed: () {
                    if (sc.text != "") {
                      Navigator.of(context).pop(MsgDialog);
                      showMsgDialogEdt(context, edt, edttitle);
                    }
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

  Widget avatarDefault() {
    if (user.avatar_path == "null" || user.avatar_path == null) {
      return Container(
        height: 200,
        width: double.infinity,
        child: Image.asset(
          'assets/images/defaultImageProfile.png',
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        height: 200,
        width: double.infinity,
        child: Image.network(
          Const().image_host + user.avatar_path + user.avatar_name,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget avatarSuccess(File fl) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Image.file(
        fl,
        fit: BoxFit.cover,
      ),
    );
  }
}
