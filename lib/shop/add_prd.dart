import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/category_bloc.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:image_picker/image_picker.dart';

class AddPrd extends StatefulWidget {
  @override
  _AddPrdState createState() => _AddPrdState();
}

class _AddPrdState extends State<AddPrd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  Future<File> file;
  int radio;
  List imgs = [];
  bool addimg = true;
  bool errimage = false;

  ShopBloc bloc = new ShopBloc();
  CategoryBloc categoryBloc = new CategoryBloc();
  var categoryid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
    categoryBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text('Tạo sản phẩm'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      '  Thông tin cơ bản',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // ten san pham
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tên sản phẩm (*)",
                          style: TextStyle(color: Config.green, fontSize: 16),
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
                              borderSide: BorderSide(color: Config.green),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Config.green, width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Config.green)),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tên sản phẩm không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //mo ta
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mô tả chi tiết (*)",
                          style: TextStyle(color: Config.green, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: description,
                          maxLines: 8,
                          autofocus: false,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Config.green),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Config.green, width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Config.green)),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Mô tả sản phẩm không được để trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //danh muc
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Danh mục sản phẩm",
                          style: TextStyle(color: Config.green, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FutureBuilder(
                            future: categoryBloc.getCategoryChildren(0),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var _list = [];
                                snapshot.data.forEach((e) {
                                  _list.add(e.name);
                                });
                                return DropdownButtonFormField(
                                  style: TextStyle(color: Config.green),
                                  decoration: InputDecoration(
                                    errorText: null,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Config.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Config.green, width: 3),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Config.green)),
                                  ),
                                  hint: Text(
                                    "--Chọn danh mục--",
                                    style: TextStyle(color: Config.green),
                                  ),
                                  onChanged: (value) {
                                    snapshot.data.forEach((e) {
                                      if (value == e.name) {
                                        categoryid = e.id;
                                      }
                                    });
                                  },
                                  items: _list
                                      .toSet()
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Danh muc sản phẩm không được để trống';
                                    }
                                    return null;
                                  },
                                );
                              } else {
                                return DropdownButtonFormField(
                                  onChanged: (value) {},
                                  style: TextStyle(color: Config.green),
                                  decoration: InputDecoration(
                                    errorText: null,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Config.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Config.green, width: 3),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Config.green)),
                                  ),
                                  hint: Text(
                                    "--Chọn danh mục--",
                                    style: TextStyle(color: Config.green),
                                  ),
                                  items: [],
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  // Gia san pham
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lưu ý: Giá chỉ áp dụng khi không nhập giá bán buôn và bỏ trống ứng với giá "
                          '"Liên hệ"'
                          ".",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: price,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Config.green),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Config.green, width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Config.green)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //anh
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ảnh",
                          style: TextStyle(color: Config.green, fontSize: 16),
                        ),
                        RichText(
                          textAlign: TextAlign.justify,
                          maxLines: 5,
                          text: TextSpan(
                            text:
                                'Bạn có thể chỉnh sửa ảnh hiển thị trên trang  đẹp hơn',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              TextSpan(
                                text:
                                    " (*) (ảnh từ 500x500 đến 2000x2000 và nhỏ hơn 10MB)",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Colors.white,
                                  height: 100,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            if (imgs.length < 8) {
                                              setState(() {
                                                addimg = true;
                                                file = ImagePicker.pickImage(
                                                    source: ImageSource.camera);
                                              });
                                            } else {
                                              showToast(
                                                  "Tối đa 8 ảnh cho 1 sản phẩm",
                                                  context,
                                                  Colors.grey,
                                                  Icons.error_outline);
                                              setState(() {
                                                errimage = true;
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.white,
                                            child: Text("Máy ảnh"),
                                          ),
                                        ),
                                        Divider(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            if (imgs.length < 8) {
                                              setState(() {
                                                addimg = true;
                                                file = ImagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                              });
                                            } else {
                                              showToast(
                                                  "Tối đa 8 ảnh cho 1 sản phẩm",
                                                  context,
                                                  Colors.grey.shade300,
                                                  Icons.error_outline);
                                              setState(() {
                                                errimage = true;
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.white,
                                            child: Text("Thư viện"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Config().colorMain),
                            child: Center(
                                child: Text(
                              'Thêm ảnh',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showAvt(),
                        errimage
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Tối thiểu phải có 1 ảnh sản phẩm. Tối đa 8 ảnh",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
                                ),
                              )
                            : Center(),
                      ],
                    ),
                  ),
                  // tạo sp
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
                            if (imgs.length > 0) {
                              var res = await bloc.insertPrd(
                                  imgs,
                                  name.text,
                                  description.text,
                                  price.text,
                                  radio,
                                  categoryid);
                              if (res != null) {
                                if (res['code'] == 1) {
                                  Navigator.pop(context, "ok");
                                  showToast("Đã tạo thành công sản phẩm",
                                      context, Colors.greenAccent, Icons.check);
                                  name.text = "";
                                  description.text = "";
                                  price.text = "";
                                  imgs = [];
                                  addimg = false;
                                  errimage = false;
                                  setState(() {});
                                }
                              } else {
                                showToast("Lỗi kết nối", context, Colors.grey,
                                    Icons.error_outline);
                              }
                            } else {
                              showToast("Bạn chưa chọn ảnh cho sản phẩm",
                                  context, Colors.grey, Icons.error_outline);
                              setState(() {
                                errimage = true;
                              });
                            }
                          }
                        },
                        child: Text(
                          'Tạo sản phẩm',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget showAvt() {
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
          return avatarSuccess(imgs);
        } else {
          return Container(
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

  Widget avatarSuccess(List imgs) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1)),
      child: GridView.count(
        crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                    (MediaQuery.of(context).size.width / 170).floor()) >
                0.8
            ? (MediaQuery.of(context).size.width / 170).round()
            : (MediaQuery.of(context).size.width / 170).floor(),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.8,
        children: List.generate(
            imgs.length,
            (index) => Column(children: [
                  SizedBox(
                    height: 12,
                  ),
                  Stack(
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
                              imgs[index],
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
                              showMsgDialog(context,
                                  "Bạn có muốn xóa ảnh này không", index);
                            },
                            child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black.withOpacity(0.8),
                                child: Icon(Icons.close, color: Colors.white)),
                          ))
                    ],
                  ),
                  RadioListTile(
                    value: index,
                    groupValue: radio,
                    onChanged: (value) {
                      radio = value;
                      setState(() {});
                    },
                    title: Text(
                      "Ảnh đại diện",
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ])),
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
                    setState(() {
                      addimg = false;
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
