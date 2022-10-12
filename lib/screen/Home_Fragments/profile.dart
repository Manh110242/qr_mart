import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/main.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_posts.dart';
import 'package:gcaeco_app/screen/Tabs_In_Profile/tab_purchase.dart';
import 'package:gcaeco_app/screen/before_login.dart';
import 'package:gcaeco_app/screen/layouts/products/cart_header.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:gcaeco_app/screen/screen_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen_cart.dart';

class Profile extends StatefulWidget {
  final SharedPreferences prefs;

  Profile({this.prefs});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  ScrollController scrollController = new ScrollController();
  double height = 3 * kToolbarHeight;
  TabController tabController;
  bool lastStatus = true;
  bool isPostTab = true;
  int _selectedIndex = 0;
  int solan = 0;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  void _getActiveTabIndex() {
    _selectedIndex = tabController.index;
    if (_selectedIndex == 1) {
      setState(() {
        isPostTab = true;
      });
    } else {
      setState(() {
        isPostTab = false;
      });
    }
  }

  bool get _isShrink {
    return scrollController.hasClients &&
        scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    prefs.init();
    isPostTab = true;
    tabController = new TabController(length: 2, vsync: this);
    tabController.addListener(_getActiveTabIndex);
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 1) {
      setState(() {
        isPostTab = true;
      });
    } else {
      setState(() {
        isPostTab = false;
      });
    }
    return FutureBuilder<String>(
      future: Const.web_api.checkLogin(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == '1') {
            return body();
          } else {
            return Scaffold(
              appBar: new AppBar(
                backgroundColor: Config().colorMain,
                centerTitle: true,
                title: Text('Thông tin cá nhân'),
              ),
              body: BeforeLogin(
                prefs: widget.prefs,
              ),
            );
          }
        } else {
          return Text('');
        }
      },
    );
  }

  body() {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, MediaQuery.of(context).size.width),
        child: Container(
          height: 100,
          color: Config().colorMain,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1, left: 15),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => ScreenProfile()));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                Const().image_host + prefs.getString("avatar_path") + prefs.getString("avatar_name"),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.white,
                                    child: Center(
                                      child: Icon(
                                        Icons.person_pin,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }

                                  return Container(
                                    height: 50,
                                    width: 50,
                                    padding: EdgeInsets.all(10),
                                    color: Colors.white,
                                    child: Platform.isIOS
                                        ? Center(
                                      child: CupertinoActivityIndicator(),
                                    )
                                        : Center(
                                      child: CircularProgressIndicator(strokeWidth: 2,),
                                    ),
                                  ) ;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            prefs.getString("username"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,

                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Const.web_api.checkLogin().then((value) async {
                            if (value != '1') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login_Screen(prefs: widget.prefs,)));
                            } else {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Cart()));
                            }
                          });
                        },
                        child: Stack(
                          alignment: Alignment(1, -1),
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            CartHeader()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Tab_Purchase(
        prefs: widget.prefs,
      ),
    );
  }
}
