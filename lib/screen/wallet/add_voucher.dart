import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/bloc_home_new.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/wallet/transfer_success.dart';
import 'package:image_picker/image_picker.dart';

class AddVoucher extends StatefulWidget {
  @override
  _AddVoucherState createState() => _AddVoucherState();
}

class _AddVoucherState extends State<AddVoucher> {
  final _vController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  File _file1;
  File _file2;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Config().colorMain,
        title: Text(
          'Nạp Voucher',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: Color(0xff005030)),
        constraints: BoxConstraints(minHeight: 1000),
        child: FutureBuilder(
            future: BlocHomeNew().getBankAdmin(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              return SingleChildScrollView(
                child: transferInfomation(context, snapshot.data),
              );
            }),
      ),
    );
  }

  //Nhập các thông tin chuyển V
  Widget transferInfomation(context, data) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tỷ lệ chuyển đổi',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 15)),
                Text('1V = 1000đ',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16)),
              ],
            ),
          ),
          TextFormField(
            controller: _vController,
            onChanged: (text) {
              setState(() {
                totalPrice = int.parse(text) * 1000;
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Colors.black),
            decoration: new InputDecoration(
              hintText: "Nhập số V cần nạp...",
              hintStyle: TextStyle(color: Colors.black87),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1, color: Colors.red)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.white)),
              errorStyle: TextStyle(color: Colors.orange),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Số V không được bỏ trống';
              }
              return null;
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('Số tiền cần thanh toán: ',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                Text(Config().formatter.format(totalPrice).toString() + 'đ',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              'Thông tin thanh toán',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ngân hàng: ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        data['bank_name'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Divider(
                    color: Colors.black26,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Số tài khoản: ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        data['number'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Divider(
                    color: Colors.black26,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chủ tài khoản: ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        data['user_name'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Divider(
                    color: Colors.black26,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chi nhánh: ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        data['address'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        chooseImage1();
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      ),
                    )),
                Flexible(
                    flex: 8,
                    child: Text(
                      'Ảnh giao dịch chuyển khoản trên mobile banking, nạp tiền tại ngân hàng.(File ảnh .jpg .jpeg .png)',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
          showImage1(),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        chooseImage2();
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      ),
                    )),
                Flexible(
                    flex: 8,
                    child: Text(
                      'Ảnh tin nhắn thông báo chuyển khoản thành công từ ngân hàng.(File ảnh .jpg .jpeg .png)',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
          showImage2(),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      submit();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  submit() async {
    if (null == _file1 || null == _file2) {
      MsgDialog.showMsgDialog(
          context, 'Bạn chưa tải lên hình ảnh xác thực giao dịch', 'Lỗi');
    } else {
      dio.interceptors.add(
        InterceptorsWrapper(onError: (DioError e) {
          print(
              "#################################### error: [${e.response?.statusCode}] >> ${e.response?.data}");
        }),
      );
      try {
        LoadingDialog.showLoadingDialog(context, 'Loadding');
        String fileName1 = _file1.path.split('/').last;
        String fileName2 = _file2.path.split('/').last;
        var token = await Const.web_api.getTokenUser();
        var user_id = await Const.web_api.getUserId();
        Map<String, dynamic> request_body = new Map<String, dynamic>();
        var order = new Map();
        order['payment_method'] = 'CK';
        order['money'] = _vController.text;
        request_body['user_id'] = user_id;
        request_body['Order'] = order;
        request_body['image1'] =
            await MultipartFile.fromFile(_file1.path, filename: fileName1);
        request_body['image2'] =
            await MultipartFile.fromFile(_file2.path, filename: fileName2);

        FormData formData = new FormData.fromMap(request_body);
        print(token);

        var response = await dio.post(
          Const().api_host + "/app/coin/add-voucher",
          data: formData,
          options: Options(
            headers: {'token': token},
          ),
        );
        var res = response.data;
        if (res['code'] == 0) {
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showMsgDialog(context, res['error'], 'Lỗi');
        } else {
          LoadingDialog.hideLoadingDialog(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TransferSuccess('Nạp V thành công')),
              ModalRoute.withName("/"));
        }
      } catch (e) {
        print(e);
      }
    }
  }

  chooseImage1() async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _file1 = File(pickedFile.path);
      ;
    });
  }

  Widget showImage1() {
    if (_file1 != null) {
      return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: 150,
        width: double.infinity,
        child: Image.file(
          _file1,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Text('');
    }
  }

  Widget showImage2() {
    if (_file2 != null) {
      return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: 150,
        width: double.infinity,
        child: Image.file(
          _file2,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Text('');
    }
  }

  chooseImage2() async {
    final picker = ImagePicker();
    PickedFile pickedFile2 = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _file2 = File(pickedFile2.path);
      ;
    });
  }
}
