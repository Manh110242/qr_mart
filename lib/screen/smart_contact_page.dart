import 'package:flutter/material.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/item_share/pickup_layout.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/provider/available_contacts_provider.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:gcaeco_app/validators/enum.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_unsaved_number.dart';
import 'chat_room.dart';
import 'contacts.dart';

class SmartContactsPage extends StatefulWidget {
  final String currentUserNo;
  final DataModel model;
  final bool biometricEnabled;
  final SharedPreferences prefs;
  final Function onTapCreateGroup;

  const SmartContactsPage({
    Key key,
    @required this.currentUserNo,
    @required this.model,
    @required this.biometricEnabled,
    @required this.prefs,
    @required this.onTapCreateGroup,
  }) : super(key: key);

  @override
  _SmartContactsPageState createState() => _SmartContactsPageState();
}

class _SmartContactsPageState extends State<SmartContactsPage> {
  Map<String, String> contacts;
  Map<String, String> _filtered = new Map<String, String>();

  final TextEditingController _filter = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setInitial(context);
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  setInitial(BuildContext context) {
    _appBarTitle = new Text(
      'Chọn liên hệ',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color:
            DESIGN_TYPE == Themetype.whatsapp ? fiberchatWhite : fiberchatBlack,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _filter.dispose();
  }

  Icon _searchIcon = new Icon(
    Icons.search,
    color: DESIGN_TYPE == Themetype.whatsapp ? fiberchatWhite : fiberchatBlack,
  );
  Widget _appBarTitle = Text('');

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.getNTPWrappedWidget(
        child: ScopedModel<DataModel>(
            model: widget.model,
            child: ScopedModelDescendant<DataModel>(
                builder: (context, child, model) {
                  return Consumer<AvailableContactsProvider>(
                      builder: (context, availableContacts, _child) {
                        // _filtered = availableContacts.filtered;
                        return Scaffold(
                            backgroundColor: Color(0xfff2f2f2),
                            appBar: AppBar(
                              titleSpacing: 5,
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 24,
                                  color: DESIGN_TYPE == Themetype.whatsapp
                                      ? fiberchatWhite
                                      : fiberchatBlack,
                                ),
                              ),
                              backgroundColor: Config().colorMain,
                              centerTitle: false,
                              title: _appBarTitle,
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.add_call,
                                    color: DESIGN_TYPE == Themetype.whatsapp
                                        ? fiberchatWhite
                                        : fiberchatBlack,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        new MaterialPageRoute(builder: (context) {
                                          return AddunsavedNumber(
                                              prefs: widget.prefs,
                                              model: widget.model,
                                              currentUserNo: widget.currentUserNo);
                                        }));
                                  },
                                ),
                                IconButton(
                                  icon: _searchIcon,
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        new MaterialPageRoute(builder: (context) {
                                          return Contacts(
                                            prefs: widget.prefs,
                                            model: widget.model,
                                            currentUserNo: widget.currentUserNo,
                                            biometricEnabled: widget.biometricEnabled,
                                          );
                                        }));
                                  },
                                )
                              ],
                            ),
                            body:
                            //  availableContacts.joinedcontactsInSharePref.length ==
                            //             0 ||
                            availableContacts.searchingcontactsindatabase ==
                                true
                                ? loading()
                                : RefreshIndicator(
                                onRefresh: () {
                                  return availableContacts.fetchContacts(
                                      context,
                                      model,
                                      widget.currentUserNo,
                                      widget.prefs);
                                },
                                child: _filtered.isEmpty
                                    ? ListView(children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                              .size
                                              .height /
                                              2.5),
                                      child: Center(
                                        child: Text(
                                            'No Search result',
                                            textAlign:
                                            TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: fiberchatBlack,
                                            )),
                                      ))
                                ])
                                    : ListView(
                                  padding: EdgeInsets.only(
                                      bottom: 15, top: 0),
                                  physics:
                                  AlwaysScrollableScrollPhysics(),
                                  children: [
                                    ListTile(
                                      tileColor: Colors.white,
                                      leading: CircleAvatar(
                                          backgroundColor:
                                          fiberchatLightGreen,
                                          radius: 22.5,
                                          child: Icon(
                                            Icons.share_rounded,
                                            color: Colors.white,
                                          )),
                                      title: Text(
                                        'Share',
                                      ),
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          horizontal: 22.0,
                                          vertical: 11.0),
                                      onTap: () {
                                        // Fiberchat.invite(context);
                                      },
                                    ),
                                    ListTile(
                                      tileColor: Colors.white,
                                      leading: CircleAvatar(
                                          backgroundColor:
                                          fiberchatLightGreen,
                                          radius: 22.5,
                                          child: Icon(
                                            Icons.group,
                                            color: Colors.white,
                                          )),
                                      title: Text(
                                        'Create group',
                                      ),
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          horizontal: 22.0,
                                          vertical: 11.0),
                                      onTap: () {
                                        widget.onTapCreateGroup();
                                      },
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    availableContacts
                                        .joinedUserPhoneStringAsInServer
                                        .length ==
                                        0
                                        ? SizedBox(
                                      height: 0,
                                    )
                                        : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      padding:
                                      EdgeInsets.all(00),
                                      itemCount: availableContacts
                                          .joinedUserPhoneStringAsInServer
                                          .length,
                                      itemBuilder:
                                          (context, idx) {
                                        JoinedUserModel user =
                                        availableContacts
                                            .joinedUserPhoneStringAsInServer
                                            .elementAt(idx);
                                        String phone =
                                            user.phone;
                                        String name =
                                            user.name ??
                                                user.phone;
                                        return ListTile(
                                          tileColor:
                                          Colors.white,
                                          leading:
                                          FutureBuilder(
                                            future:
                                            availableContacts
                                                .getUserDoc(
                                                phone),
                                            builder: (BuildContext
                                            context,
                                                AsyncSnapshot
                                                snapshot) {
                                              if (snapshot
                                                  .hasData &&
                                                  snapshot.data
                                                      .exists) {
                                                return HelperFunctions.customCircleAvatar(
                                                    url: snapshot
                                                        .data[
                                                    Dbkeys
                                                        .photoUrl],
                                                    radius: 22);
                                              }
                                              return CircleAvatar(
                                                  backgroundColor:
                                                  fiberchatgreen,
                                                  radius: 22.5,
                                                  child: Text(
                                                    HelperFunctions
                                                        .getInitials(
                                                        name),
                                                    style: TextStyle(
                                                        color:
                                                        fiberchatWhite),
                                                  ));
                                            },
                                          ),
                                          title: Text(name,
                                              style: TextStyle(
                                                  color:
                                                  fiberchatBlack)),
                                          subtitle: Text(phone,
                                              style: TextStyle(
                                                  color:
                                                  fiberchatGrey)),
                                          contentPadding:
                                          EdgeInsets
                                              .symmetric(
                                              horizontal:
                                              22.0,
                                              vertical:
                                              0.0),
                                          onTap: () {
                                            hidekeyboard(
                                                context);

                                            Navigator.pushReplacement(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) => ChatRoom(
                                                        prefs: widget
                                                            .prefs,
                                                        model:
                                                        model,
                                                        currentUserNo:
                                                        widget.prefs.getString("phone") ?? "",
                                                        peerNo:
                                                        phone,
                                                        unread:
                                                        0)));
                                          },
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(
                                          18, 24, 18, 18),
                                      child: Text(
                                        'Invite',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight:
                                            FontWeight.w800),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(0),
                                      itemCount: _filtered.length,
                                      itemBuilder: (context, idx) {
                                        MapEntry user = _filtered
                                            .entries
                                            .elementAt(idx);
                                        String phone = user.key;
                                        return availableContacts
                                            .joinedcontactsInSharePref
                                            .indexWhere(
                                                (element) =>
                                            element
                                                .phone ==
                                                phone) >=
                                            0
                                            ? Container(
                                          width: 0,
                                        )
                                            : Stack(
                                          children: [
                                            ListTile(
                                              tileColor:
                                              Colors.white,
                                              leading:
                                              CircleAvatar(
                                                  backgroundColor:
                                                  fiberchatgreen,
                                                  radius:
                                                  22.5,
                                                  child:
                                                  Text(
                                                    HelperFunctions.getInitials(
                                                        user.value),
                                                    style: TextStyle(
                                                        color:
                                                        fiberchatWhite),
                                                  )),
                                              title: Text(
                                                  user.value,
                                                  style: TextStyle(
                                                      color:
                                                      fiberchatBlack)),
                                              subtitle: Text(
                                                  phone,
                                                  style: TextStyle(
                                                      color:
                                                      fiberchatGrey)),
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                  horizontal:
                                                  22.0,
                                                  vertical:
                                                  0.0),
                                              onTap: () {
                                                hidekeyboard(
                                                    context);
                                                // Fiberchat.invite(
                                                //     context);
                                              },
                                            ),
                                            Positioned(
                                              right: 19,
                                              bottom: 19,
                                              child: InkWell(
                                                  onTap: () {
                                                    hidekeyboard(
                                                        context);
                                                    // Fiberchat
                                                    //     .invite(
                                                    //         context);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .person_add_alt,
                                                    color:
                                                    fiberchatgreen,
                                                  )),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                )));
                      });
                })));
  }

  loading() {
    return Stack(children: [
      Container(
        child: Center(
            child:
                // Column(
                //     mainAxisSize: MainAxisSize.min,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [Icon(Icons.search, size: 30)])
                CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(fiberchatBlue),
        )),
      )
    ]);
  }
}
