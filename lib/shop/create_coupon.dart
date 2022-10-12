import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:intl/intl.dart';

import 'item_shop/custom_drop_buttom.dart';
import 'item_shop/custom_textfield.dart';

class CreateCoupon extends StatefulWidget {
  @override
  _CreateCouponState createState() => _CreateCouponState();
}

class _CreateCouponState extends State<CreateCoupon> {
  TextEditingController name = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  TextEditingController value = new TextEditingController();
  TextEditingController count_limit = new TextEditingController();
  TextEditingController time_start = new TextEditingController();
  TextEditingController time_end = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String type_discount;
  List types = ["Giảm trực tiếp số tiền", "Giảm phần trăm tổng đơn hàng mua"];
  String all;
  List add = ["Tất cả sản phẩm", "Nhóm sản phẩm"];
  List add1 = [];
  List _list = [];
  ShopBloc bloc = new ShopBloc();
  int page = 1;
  bool check = true;
  bool load = false;
  List<bool> _isChecked;
  ScrollController sc = new ScrollController();
  int time1, time2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isChecked = List<bool>.filled(_list.length, false);
    sc.addListener(() async {
      if(sc.position.pixels == sc.position.maxScrollExtent){
         page ++;
        load = true;
        await bloc.getPrdShop(0,"", true, page);
        load = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Thêm mã giảm giá"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  showCursor: true,
                  title: "Tên đợt giảm giá",
                  error: "Tên đợt giảm giá không đươc bỏ trống.",
                  sc: name,
                ),
                CustomTextField(
                  showCursor: true,
                  title: "Số lượng mã tạo",
                  error: "Số lượng mã tạo không đươc bỏ trống.",
                  sc: quantity,
                ),
                CustomDropButtom(
                  title: "Loại giảm giá",
                  hint: "",
                  error: "Bạn chưa loại giảm giá",
                  list: types,
                  value: type_discount,
                  onChanged: (value) {
                    type_discount = value;
                    setState(() {});
                  },
                ),
                CustomTextField(
                  showCursor: true,
                  title: "Giá trị:(đ hoặc % theo loại)",
                  error: "Giá trị:(đ hoặc % theo loại) không được để trống.",
                  sc: value,
                ),
                CustomTextField(
                  showCursor: true,
                  title: "Số lần sử dụng/mã",
                  error: "Số lần sử dụng/mã không đươc bỏ trống",
                  sc: count_limit,
                ),
                CustomTextField(
                  title: "Thời gian bắt đầu",
                  error: "Thời gian bắt đầu không đươc bỏ trống",
                  sc: time_start,
                  readOnly: true,
                  showCursor: false,
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                    ).then((value){
                      String start = DateFormat('dd-MM-yyyy', 'en_US')
                          .format(DateTime.parse(value.toString()));
                      time_start.text = start;
                    });
                  },
                ),
                CustomTextField(
                  title: "Thời gian hết hạn",
                  error: "Thời gian hết hạn không đươc bỏ trống",
                  sc: time_end,
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                    ).then((value){
                      String end = DateFormat('dd-MM-yyyy', 'en_US')
                          .format(DateTime.parse(value.toString()));
                      time_end.text = end;
                    });
                  },
                  showCursor: false,
                  readOnly: true,
                ),
                CustomDropButtom(
                  title: "Áp dụng cho",
                  hint: "",
                  error: "Bạn chưa chọn loại sản phẩm áp dụng mã",
                  list: add,
                  value: all,
                  onChanged: (value) async{
                    setState(() {
                      page = 1;
                      all = value;
                      add1 = [];
                    });
                  },
                ),
                all != null && all == "Nhóm sản phẩm"? FutureBuilder(
                  future:  bloc.getPrdShop(0, '', true, page),
                    builder: (_,snapshot){
                  if(snapshot.hasData){
                    if(all == "Nhóm sản phẩm" && load == false){
                      _list = [];
                    }
                      _list.addAll(snapshot.data);
                    if(_isChecked.length <=0){
                      _isChecked = List<bool>.filled(_list.length, false);
                    }
                    return Container(
                      height: 300,
                      child: ListView.builder(
                        controller: sc,
                          itemCount: _list.length,
                          itemBuilder: (_,index) => index == (_list.length -1) && load == true?Center(child: CircularProgressIndicator(),):Container(child: Row(
                            children: [
                              Checkbox(
                                  value: _isChecked[index],
                                  onChanged: (value){
                                setState(() {
                                  _isChecked[index] = value;
                                  if(value){
                                    add1.add(int.parse(_list[index].id));
                                  }else{
                                    add1.remove(int.parse(_list[index].id));
                                  }
                                });
                              }),
                              Flexible(flex: 8,child: Text(_list[index].name, )),
                            ],
                          ),)),
                    );
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                }) : Center(),
                FlatButton(
                    color: Config().colorMain,
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        var res = await bloc.createCoupon(name.text, quantity.text, type_discount == "Giảm trực tiếp số tiền" ? 1: 2, value.text, count_limit.text, time_start.text, time_end.text, all == "Tất cả sản phẩm"?1:0, add1);
                        if(res){
                          showToast("Tạo mã thành công", context, Colors.grey, Icons.check);
                          Navigator.pop(context,res);
                        }else{
                          showToast("Tạo mã thất bại", context, Colors.grey, Icons.error_outline);
                        }
                      }
                    }, child: Container(width: 100,child: Center(child: Text("Tạo mã", style: TextStyle(color: Colors.white),)))),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
