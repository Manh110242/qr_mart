import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/category_bloc.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/shop/transport.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePrd extends StatefulWidget {
  ProductItem item;

  UpdatePrd({this.item});
  @override
  _UpdatePrdState createState() => _UpdatePrdState();
}

class _UpdatePrdState extends State<UpdatePrd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  Future<File> file;
  int radio;
  List imgs = [];
  List images = [];
  bool addimg1 = true;
  List iddel = [];
  bool addimg = true;
  bool errimage = false;
  String value;

  ShopBloc bloc = new ShopBloc();
  CategoryBloc categoryBloc = new CategoryBloc();
  var categoryid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    name.text = widget.item.name;
    description.text = widget.item.des;
    price.text = widget.item.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text('Cập nhật sản phẩm'),
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
                              return 'Mô tả không được để trống';
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
                                var abc = [];
                                snapshot.data.forEach((e) {
                                  if (widget.item.category_id == "${e.id}") {
                                    value = e.name;
                                    categoryid = e.id;
                                  }
                                  _list.add(e.name);
                                  abc.add(e.id);
                                });
                                return DropdownButtonFormField(
                                  value: value,
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
                        FutureBuilder(
                          future: bloc.getImagePrd(widget.item.id),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              if (addimg1) {
                                images = [];
                                images.addAll(snapshot.data);
                              }
                              return showAvt(images);
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
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
                            if (imgs.length > 0 || images.length > 0) {
                              // List file, name, description,price,idavt,category_id,del, id
                              var res = await bloc.updatePrd(
                                  imgs,
                                  name.text,
                                  description.text,
                                  price.text,
                                  radio,
                                  categoryid,
                                  iddel,
                                  widget.item.id);
                              if (res != null) {
                                if (res['code'] == 1) {
                                  Navigator.pop(context, res);
                                  showToast("Đã cập nhật thành công sản phẩm",
                                      context, Colors.green, Icons.check);
                                  errimage = false;
                                  setState(() {});
                                } else {
                                  showToastErr("Lỗi dữ liệu", context,
                                      Colors.red, Icons.error_outline);
                                }
                              } else {
                                showToast("Lỗi kết nối", context, Colors.grey,
                                    Icons.error_outline);
                              }
                            } else {
                              setState(() {
                                errimage = true;
                              });
                            }
                          }
                        },
                        child: Text(
                          'Cập nhật sản phẩm',
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
        childAspectRatio: .9,
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
                                    )),
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
                                    )),
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
