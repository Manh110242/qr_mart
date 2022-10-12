import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/shop/item_shop/multi_select.dart';
import 'package:gcaeco_app/shop/item_shop/text_field_2.dart';
import 'package:gcaeco_app/helper/Config.dart';

class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  TextEditingController edit1 = new TextEditingController();
  TextEditingController edit2 = new TextEditingController();
  TextEditingController edit3 = new TextEditingController();
  TextEditingController edit4 = new TextEditingController();
  TextEditingController edit5 = new TextEditingController();
  TextEditingController edit6 = new TextEditingController();
  bool check;
  bool check1 = true;
  ShopBloc bloc = new ShopBloc();
  List<int> prd_select = [];
  List<MultiSelectDialogItem<int>> prds = [];
  Map product_ids = new Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  toast(res) {
    if (res) {
      setState(() {});
      showToast("Thành công", context, Colors.grey, Icons.check);
    } else {
      showToast("Thất bại", context, Colors.grey, Icons.error_outline);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  //snap.data['data']['product_no_affiliate']
  getData(AsyncSnapshot snap) {
    edit5.text = snap.data['data']['affiliate_admin_waitting'];
    edit6.text = snap.data['data']['affiliate_gt_shop_waitting'];
    prds = [];
    snap.data['data']['product_no_affiliate'].forEach((e) {
      prds.add(MultiSelectDialogItem(e['id'], e['name']));
    });
    if (check1) {
      if (snap.data['data']['status_affiliate_waitting'] == "1") {
        check = true;
      } else {
        check = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc.DetailAffiliate('/app/mshop/affiliate');
    return StreamBuilder(
        stream: bloc.affiliateShop,
        builder: (_, AsyncSnapshot<dynamic> snap) {
          if (snap.hasData) {
            getData(snap);
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      snap.data['data']['status_affiliate'] != "1"
                          ? top(snap)
                          : Center(),
                      header(snap),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Danh sách sản phẩm tham gia affiliale / Affiliate cho tài khoản:",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snap.data['data']['products'].length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        flex: 8,
                                        child: Text(
                                          snap.data['data']['products'][index]
                                              ['name'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () {
                                            edit1.text = snap.data['data']
                                                    ['products'][index]
                                                ['affiliate_gt_product'];
                                            edit2.text = snap.data['data']
                                                    ['products'][index]
                                                ['affiliate_m_v'];
                                            edit3.text = snap.data['data']
                                                    ['products'][index]
                                                ['affiliate_charity'];
                                            edit4.text = snap.data['data']
                                                    ['products'][index]
                                                ['affiliate_safe'];
                                            showMsgDialogEdt(
                                                context,
                                                snap.data['data']['products']
                                                    [index]['id']);
                                          },
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                            onPressed: () async {
                                              showMsgDelete(
                                                  context,
                                                  snap.data['data']['products']
                                                      [index]['id']);
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                                Divider(),
                              ],
                            );
                          }),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Config().colorMain,
                onPressed: () async {
                  final selectedValues = await showDialog<Set<int>>(
                    context: context,
                    builder: (BuildContext context) {
                      return MultiSelectDialog(
                        items: prds,
                        initialSelectedValues: prd_select.toSet(),
                      );
                    },
                  );
                  if (selectedValues != null) {
                    for (var item in selectedValues.toList()) {
                      product_ids['$item'] = {
                        "id": 1,
                        "affiliate_gt_product": 0,
                        "affiliate_m_v": 0,
                        "affiliate_charity": 0,
                        "affiliate_safe": 0,
                      };
                      prds.removeWhere((element) => element.value == item);
                    }
                    setState(() {});
                  }
                },
                child: Icon(Icons.add),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget top(AsyncSnapshot snap) {
    return Column(
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Thông tin affiliate đang chờ duyệt.",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              style: TextStyle(color: Colors.blue),
              text: "Hủy thay đổi",
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  var res = await bloc.cancelAffiliate();
                  toast(res);
                },
            ),
          ]),
        ),
        Divider(),
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tham gia Affiliate"),
              Text(snap.data['data']['status_affiliate_waitting'] == "1"
                  ? "Bật"
                  : "Tắt"),
            ],
          ),
        ),
        Divider(),
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("% thưởng cho OCOP PARTNER"),
              Text(snap.data['data']['affiliate_admin_waitting'] + "%"),
            ],
          ),
        ),
        Divider(),
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("% thưởng cho người giới thiệu DN bạn"),
              Text(snap.data['data']['affiliate_gt_shop_waitting'] + "%"),
            ],
          ),
        ),
      ],
    );
  }

  Widget header(AsyncSnapshot snap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 4, child: Text("Tham gia Affiliate")),
            Flexible(
                flex: 7,
                child: CheckboxListTile(
                    value: check,
                    title: Text(""),
                    contentPadding: EdgeInsets.only(left: 0),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Config().colorMain,
                    onChanged: (value) {
                      check = value;
                      check1 = false;
                      setState(() {});
                    }))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 4,
                child: Text(
                  "% thưởng cho OCOP PARTNER",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
            Flexible(
                flex: 6,
                child: Container(
                  height: 40,
                  child: TextFormField(
                    controller: edit5,
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: Image.asset(
                        "assets/images/percentage-discount.png",
                        color: Config().colorMain,
                      ),
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      errorText: null,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Config().colorMain)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Config().colorMain)),
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 4,
                child: Text(
                  "% thưởng cho người giới thiệu DN bạn",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
            Flexible(
                flex: 6,
                child: Container(
                  height: 40,
                  child: TextFormField(
                    controller: edit6,
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: Image.asset(
                        "assets/images/percentage-discount.png",
                        color: Config().colorMain,
                      ),
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      errorText: null,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Config().colorMain)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Config().colorMain)),
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(flex: 4, child: Container()),
            Flexible(
              flex: 6,
              child: InkWell(
                onTap: () async {
                  var res = await bloc.updateAffiliate(check == true ? 1 : 0,
                      edit5.text, edit6.text, product_ids);
                  toast(res);
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Config().colorMain,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "Cập nhât".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  showMsgDialogEdt(BuildContext context, product_id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  "Cập nhật",
                  style: TextStyle(color: Config().colorMain),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField2(
                      title: "Giới thiệu sản phẩm",
                      showCursor: true,
                      sc: edit1,
                    ),
                    TextField2(
                      title: "Mua bằng V",
                      showCursor: true,
                      sc: edit2,
                    ),
                    TextField2(
                      title: "Ocop charity 4.0",
                      showCursor: true,
                      sc: edit3,
                    ),
                    TextField2(
                      title: "Giảm trực tiếp",
                      showCursor: true,
                      sc: edit4,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Lưu'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    var res = await bloc.updatePrdAffiliate(product_id,
                        edit1.text, edit2.text, edit3.text, edit4.text, 0);
                    toast(res);
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

  showMsgDelete(BuildContext context, product_id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  "Cập nhật",
                  style: TextStyle(color: Config().colorMain),
                ),
              ),
              content: Text("Bạn có muốn xóa sản phẩm này không"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Xóa'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    var res = await bloc.updatePrdAffiliate(product_id,
                        edit1.text, edit2.text, edit3.text, edit4.text, 1);
                    toast(res);
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
