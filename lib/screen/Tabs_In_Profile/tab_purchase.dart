import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_remove_user.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/main.dart';
import 'package:gcaeco_app/screen/Tab_oder/Order_screen.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/introduction.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/my_qrcode.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/wishlist.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/layouts/webview/WebViewContainer.dart';
import 'package:gcaeco_app/screen/location_manh/location_manh.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:gcaeco_app/screen/screen_profile.dart';
import 'package:gcaeco_app/screen/setting_account/Change_pass.dart';
import 'package:gcaeco_app/screen/setting_account/Change_pass2.dart';
import 'package:gcaeco_app/shop/shop_manager.dart';
import 'package:gcaeco_app/shop/shop_sign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Tab_Purchase extends StatefulWidget {
  SharedPreferences prefs;

  Tab_Purchase({this.prefs});

  @override
  _Tab_Purchase_State createState() => _Tab_Purchase_State();
}

class _Tab_Purchase_State extends State<Tab_Purchase> {
  var version;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ShopBloc().getShop(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child:  Column(
                children: [
                  ItemClickProfile(
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Order_Screen(
                                index: 1,
                              )));
                    },
                    title: "????n mua",
                    iconData: Icons.receipt_long,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ItemClickOrder(
                          onTap: (){
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        Order_Screen(
                                          index: 2,
                                        )));
                          },
                          title: "Ch??? l???y h??ng",
                          iconData: Icons.transfer_within_a_station,
                        ),
                        ItemClickOrder(
                          onTap: (){
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        Order_Screen(
                                          index: 3,
                                        )));
                          },
                          title: "??ang giao",
                          iconData: Icons.local_shipping_outlined,
                        ),
                        ItemClickOrder(
                          onTap: (){
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        Order_Screen(
                                          index: 4,
                                        )));
                          },
                          title: "???? giao",
                          iconData: Icons.done_all_outlined,
                        ),
                        ItemClickOrder(
                          onTap: (){
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        Order_Screen(
                                          index: 2,
                                        )));
                          },
                          title: "???? h???y",
                          iconData: Icons.cancel_presentation,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => ScreenProfile()));
                        },
                        title: "Th??ng tin c?? nh??n",
                        iconData: Icons.account_circle_outlined,
                      ),
                      // ItemClickProfile(
                      //   onTap: (){
                      //     Navigator.push(
                      //                   context,
                      //                   new MaterialPageRoute(
                      //                       builder: (context) => LichSuNap()));
                      //   },
                      //   title: "L???ch s??? n???p ??i???n tho???i",
                      //   iconData: Icons.phone_android_sharp,
                      // ),
                      ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiaChiScreen(
                                title: "?????a ch???",
                              ),),);
                        },
                        title: "?????a ch???",
                        iconData: Icons.location_on_outlined,
                      ),
                      ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyQrcode()));
                        },
                        title: "M?? QR c???a t??i",
                        iconData: Icons.qr_code,
                      ),
                      ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Wishlist()));
                        },
                        title: "S???n ph???m y??u th??ch",
                        iconData: Icons.favorite_border,
                      ),
                      ItemClickProfile(
                        onTap: (){
                          launch('${Const().domain}/management/shop-affiliate/index.html');
                        },
                        title: "Qu???n l?? Affiliate",
                        iconData: Icons.folder_open,
                      ),
                      ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Introduction()));
                        },
                        title:  "Gi???i thi???u $appName",
                        iconData: Icons.account_tree,
                      ),
                      ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => change_pass()));
                        },
                        title: "?????i m???t kh???u",
                        iconData: Icons.create_outlined,
                      ),
                      ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Change_pass2()));
                        },
                        title: "?????i m???t kh???u c???p 2",
                        iconData: Icons.colorize,
                      ),
                      snapshot.hasData ? ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      ScreenShopSign(
                                        title:
                                        "Thi???t l???p doanh nghi???p",
                                      )));
                        },
                        title: "Thi???t l???p doanh nghi???p",
                        iconData: Icons.folder_shared_outlined,
                      ) : ItemClickProfile(
                        onTap: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => ShopManager()));
                        },
                        title: "Qu???n l?? doanh nghi???p",
                        iconData: Icons.folder_shared_outlined,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ItemClickProfile(
                        onTap: (){
                          MsgDialog.showMsgDialog(
                            context,
                            "B???n c?? mu???n x??a t??i kho???n n??y kh??ng ?",
                            "Th??ng b??o",
                            isRemove: true,
                            onPressed: () async {
                              Navigator.pop(context);
                              LoadingDialog.showLoadingDialog(
                                  context, "??ang t???i...");
                              var res = await BlocRemoveUser.delete();
                              LoadingDialog.hideLoadingDialog(context);
                              if (res) {
                                await logout();
                              }
                            },
                          );
                        },
                        title: "X??a t??i kho???n",
                        iconData: CupertinoIcons.trash,
                      ),
                      ItemClickProfile(
                        onTap: (){
                          MsgDialog.showMsgDialog(
                            context,
                            "B???n c?? mu???n ????ng xu???t kh??ng ?",
                            "Th??ng b??o",
                            isRemove: true,
                            onPressed: () async {
                              Navigator.pop(context);
                              await logout();
                            },
                          );
                        },
                        title: "????ng xu???t",
                        iconData: Icons.exit_to_app,
                      ),
                    ],
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget ItemClickProfile({
    Function() onTap,
    String title,
    IconData iconData,
    bool isNext = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 0.5
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Config().colorMain,
              size: 25,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            ),
            isNext ? Icon(
              Icons.navigate_next,
              color: Colors.grey,
              size: 25,
            ) : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget ItemClickOrder({
    Function() onTap,
    String title,
    IconData iconData,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            iconData,
            size: 25,
            color: Colors.black54,
          ),
          SizedBox(height: 5,),
          Text(
            title,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
  logout() async {
    prefs.removeString('islogin_v2');
    prefs.removeString('id');
    prefs.removeString('username');
    prefs.removeString('auth_key');
    prefs.removeString('password-hash');
    prefs.removeString('phone');
    prefs.removeString('email');
    prefs.removeString('status');
    prefs.removeString('created_at');
    prefs.removeString('updated_at');
    prefs.removeString('address');
    prefs.removeString('facebook');
    prefs.removeString('link_facebook');
    prefs.removeString('is_notification');
    prefs.removeString('sex');
    prefs.removeString('birthday');
    prefs.removeString('avatar_path');
    prefs.removeString('avatar_name');
    prefs.removeString('tokenA');
    prefs.removeString('token_user');
    prefs.removeBool('isShop');
    prefs.removeBool('name_Shop');

    String phoneFB = widget.prefs.getString(Dbkeys.phone);
    widget.prefs.remove(Dbkeys.phone);

    await FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(phoneFB)
        .update({
      Dbkeys.notificationTokens: [],
    });

    SharedPreferences prefss = await SharedPreferences.getInstance();

    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => Home(
                  page: 2,
                  prefs: prefss,
                )));
  }
}
