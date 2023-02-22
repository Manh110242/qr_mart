import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/shop/item_shop/multi_select.dart';
import 'package:gcaeco_app/shop/item_shop/text_field_2.dart';
import 'package:gcaeco_app/helper/Config.dart';

import '../../main.dart';

class Tab2 extends StatefulWidget {
  @override
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  TextEditingController edit1 = new TextEditingController();
  TextEditingController edit2 = new TextEditingController();
  TextEditingController edit3 = new TextEditingController();
  TextEditingController edit4 = new TextEditingController();
  TextEditingController edit5 = new TextEditingController();
  TextEditingController edit6 = new TextEditingController();
  bool check;
  bool check1 = true;
  bool check2 = true;
  ShopBloc bloc = new ShopBloc();
  int radio;
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
    edit1.dispose();
    edit2.dispose();
    edit3.dispose();
    edit4.dispose();
    edit5.dispose();
    edit6.dispose();
  }

  //snap.data['data']['product_no_affiliate']
  getData(AsyncSnapshot snap) {
    edit5.text = snap.data['data']['affiliate_admin_waitting'];
    edit6.text = snap.data['data']['affiliate_gt_shop_waitting'];
    prds = [];
    snap.data['data']['product_no_service'].forEach((e) {
      prds.add(MultiSelectDialogItem(e['id'], e['name']));
    });
    if (check1) {
      if (snap.data['data']['affilliate_status_service'] == "1") {
        check = true;
      } else {
        check = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc.DetailAffiliate('/app/mshop/service');
    //return Scaffold(body: Center(child: Text("Đang cập nhật"),),);
    return StreamBuilder(
        stream: bloc.affiliateShop,
        builder: (_, AsyncSnapshot<dynamic> snap) {
          if (snap.hasData) {
            getData(snap);
            if (check2) {
              snap.data['data']['products'].forEach((e) {
                if (e['pay_servive'] == 1) {
                  radio = e['id'];
                  product_ids.clear();
                  product_ids['$radio'] = {
                    "id": 1,
                    "affiliate_gt_product": e['affiliate_gt_product'],
                    "affiliate_m_v": e['affiliate_m_v'],
                    "affiliate_charity": e['affiliate_charity'],
                    "affiliate_safe": e['affiliate_safe'],
                  };
                }
              });
            }
            return Scaffold(
              body: snap.data['data']['status_affiliate'] == "1"
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            top(snap),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Sản phẩm áp dụng QR-CODE dịch vụ:",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snap.data['data']['products'].length,
                                itemBuilder: (_, index) {
                                  return buildListQrPrd(
                                      snap.data['data']['products'][index],
                                      context);
                                }),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Text('Bạn chứa tham gia Affiliate'),
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

  Column buildListQrPrd(data, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 8,
                child: Row(
                  children: [
                    Radio(
                        value: data['id'],
                        groupValue: radio,
                        onChanged: (value) {
                          radio = value;
                          check2 = false;
                          product_ids.clear();
                          product_ids['$value'] = {
                            "id": 1,
                            "affiliate_gt_product":
                                data['affiliate_gt_product'],
                            "affiliate_m_v": data['affiliate_m_v'],
                            "affiliate_charity": data['affiliate_charity'],
                            "affiliate_safe": data['affiliate_safe'],
                          };
                          setState(() {});
                        }),
                    Text(
                      data['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                edit1.text = data['affiliate_gt_product'];
                edit2.text = data['affiliate_m_v'];
                edit3.text = data['affiliate_charity'];
                edit4.text = data['affiliate_safe'];
                showMsgDialogEdt(context, data['id']);
              },
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget top(AsyncSnapshot snap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        snap.data['data']['affilliate_status_service'] != "1"
            ? RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "QR CODE dịch vụ chưa kích hoạt!",
                    style: TextStyle(color: Colors.black),
                  ),
                ]),
              )
            : Center(),
        Divider(),
        Container(
          height: 40,
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 6,
                  child: Text(
                    "% thưởng cho $appName PARTNER",
                    style: TextStyle(fontSize: 15),
                  )),
              Text(snap.data['data']['affiliate_admin_waitting'] + "%"),
            ],
          ),
        ),
        Divider(),
        Container(
          height: 40,
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 6,
                  child: Text(
                    "% thưởng cho người giới thiệu DN bạn",
                    style: TextStyle(fontSize: 15),
                  )),
              Text(snap.data['data']['affiliate_gt_shop_waitting'] + "%"),
            ],
          ),
        ),
        CheckboxListTile(
            value: check,
            title: Text("Kích hoạt QR-CODE dịch vụ"),
            contentPadding: EdgeInsets.only(right: 0),
            activeColor: Config().colorMain,
            onChanged: (value) {
              check = value;
              check1 = false;
              setState(() {});
            }),
        snap.data['src'] != null && snap.data['src'] != ""
            ? Container(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 6,
                        child: Text(
                          "Mã QR-CODE dịch vụ",
                          style: TextStyle(fontSize: 15),
                        )),
                    Image.network(snap.data['src']),
                  ],
                ),
              )
            : Center(),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            if (product_ids.isEmpty && check) {
              showToast("Vui lòng chọn sản phẩm", context, Colors.grey,
                  Icons.error_outline);
            } else {
              var res =
                  await bloc.updateAffiliateQR(check ? 1 : 0, product_ids);
              toast(res);
            }
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
                      title: "$appName charity 4.0",
                      showCursor: true,
                      enabled: false,
                      sc: edit3,
                    ),
                    TextField2(
                      title: "Giảm trực tiếp",
                      showCursor: true,
                      sc: edit4,
                      enabled: false,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Lưu'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (product_ids.isEmpty && check) {
                      showToast("Vui lòng chọn sản phẩm", context, Colors.grey,
                          Icons.error_outline);
                    } else {
                      product_ids.clear();
                      product_ids['$product_id'] = {
                        "id": 1,
                        "affiliate_gt_product": edit1.text,
                        "affiliate_m_v": edit2.text,
                        "affiliate_charity": edit3.text,
                        "affiliate_safe": edit4.text,
                      };
                      var res = await bloc.updateAffiliateQR(
                          check ? 1 : 0, product_ids);
                      toast(res);
                    }
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
