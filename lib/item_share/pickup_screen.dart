// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gcaeco_app/configs/db_path.dart';
// import 'package:gcaeco_app/helper/Config.dart';
// import 'package:gcaeco_app/helper/helper_functions.dart';
// import 'package:gcaeco_app/helper/permission.dart';
// import 'package:gcaeco_app/model/call.dart';
// import 'package:gcaeco_app/model/call_method.dart';
// import 'package:gcaeco_app/model/video_call.dart';
// import 'package:gcaeco_app/provider/firestore_data_provider_call_history.dart';
// import 'package:gcaeco_app/screen/audio_call.dart';
// import 'package:gcaeco_app/screen/screen_home.dart';
// import 'package:gcaeco_app/validators/app_constants.dart';
// import 'package:gcaeco_app/validators/enum.dart';
// import 'package:provider/provider.dart';
//
// import 'cached_image.dart';
//
// class PickupScreen extends StatelessWidget {
//   final Call call;
//   final String currentuseruid;
//   final CallMethods callMethods = CallMethods();
//
//   PickupScreen({
//     @required this.call,
//     @required this.currentuseruid,
//   });
//
//   ClientRole _role = ClientRole.Broadcaster;
//
//   @override
//   Widget build(BuildContext context) {
//     var w = MediaQuery.of(context).size.width;
//     var h = MediaQuery.of(context).size.height;
//
//     return Consumer<FirestoreDataProviderCALLHISTORY>(
//         builder: (context, firestoreDataProviderCALLHISTORY, _child) => h > w &&
//                 ((h / w) > 1.5)
//             ? Scaffold(
//                 backgroundColor: Config().colorMain,
//                 body: Container(
//                   alignment: Alignment.center,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.only(
//                               top: MediaQuery.of(context).padding.top),
//                           color: Config().colorMain,
//                           height: h / 4,
//                           width: w,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SizedBox(
//                                 height: 7,
//                               ),
//
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     call.isvideocall == true
//                                         ? Icons.videocam
//                                         : Icons.mic_rounded,
//                                     size: 40,
//                                     color: DESIGN_TYPE == Themetype.whatsapp
//                                         ? fiberchatLightGreen
//                                         : Colors.white.withOpacity(0.5),
//                                   ),
//                                   SizedBox(
//                                     width: 7,
//                                   ),
//                                   Text(
//                                     call.isvideocall == true
//                                         ? 'FaceTime'
//                                         : 'Audio',
//                                     style: TextStyle(
//                                         fontSize: 18.0,
//                                         color: DESIGN_TYPE == Themetype.whatsapp
//                                             ? fiberchatLightGreen
//                                             : Colors.white.withOpacity(0.5),
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: h / 9,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(height: 7),
//                                     SizedBox(
//                                       width:
//                                           MediaQuery.of(context).size.width / 1.1,
//                                       child: Text(
//                                         call.callerName,
//                                         maxLines: 1,
//                                         textAlign: TextAlign.center,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: DESIGN_TYPE == Themetype.whatsapp
//                                               ? fiberchatWhite
//                                               : fiberchatWhite,
//                                           fontSize: 27,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 7),
//                                     Text(
//                                       call.callerId,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.normal,
//                                         color: DESIGN_TYPE == Themetype.whatsapp
//                                             ? fiberchatWhite.withOpacity(0.34)
//                                             : fiberchatWhite.withOpacity(0.34),
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // SizedBox(height: h / 25),
//
//                               SizedBox(
//                                 height: 10,
//                               ),
//                             ],
//                           ),
//                         ),
//                         call.callerPic == null || call.callerPic == ''
//                             ? Container(
//                                 height: w + (w / 140),
//                                 width: w,
//                                 color: Colors.white12,
//                                 child: Icon(
//                                   Icons.person,
//                                   size: 140,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Stack(
//                                 children: [
//                                   Container(
//                                       height: w + (w / 140),
//                                       width: w,
//                                       color: Colors.white12,
//                                       child: CachedNetworkImage(
//                                         imageUrl: call.callerPic,
//                                         fit: BoxFit.cover,
//                                         height: w + (w / 140),
//                                         width: w,
//                                         placeholder: (context, url) => Center(
//                                             child: Container(
//                                           height: w + (w / 140),
//                                           width: w,
//                                           color: Colors.white12,
//                                           child: Icon(
//                                             Icons.person,
//                                             size: 140,
//                                             color: fiberchatDeepGreen,
//                                           ),
//                                         )),
//                                         errorWidget: (context, url, error) =>
//                                             Container(
//                                           height: w + (w / 140),
//                                           width: w,
//                                           color: Colors.white12,
//                                           child: Icon(
//                                             Icons.person,
//                                             size: 140,
//                                             color: fiberchatDeepGreen,
//                                           ),
//                                         ),
//                                       )),
//                                   Container(
//                                     height: w + (w / 140),
//                                     width: w,
//                                     color: Colors.black.withOpacity(0.18),
//                                   ),
//                                 ],
//                               ),
//                         Container(
//                           height: h / 6,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               RawMaterialButton(
//                                 onPressed: () async {
//                                   flutterLocalNotificationsPlugin.cancelAll();
//                                   await callMethods.endCall(call: call);
//                                   FirebaseFirestore.instance
//                                       .collection(DbPaths.collectionusers)
//                                       .doc(call.callerId)
//                                       .collection(DbPaths.collectioncallhistory)
//                                       .doc(call.timeepoch.toString())
//                                       .set({
//                                     'STATUS': 'rejected',
//                                     'ENDED': DateTime.now(),
//                                   }, SetOptions(merge: true));
//                                   FirebaseFirestore.instance
//                                       .collection(DbPaths.collectionusers)
//                                       .doc(call.receiverId)
//                                       .collection(DbPaths.collectioncallhistory)
//                                       .doc(call.timeepoch.toString())
//                                       .set({
//                                     'STATUS': 'rejected',
//                                     'ENDED': DateTime.now(),
//                                   }, SetOptions(merge: true));
//                                   //----------
//                                   await FirebaseFirestore.instance
//                                       .collection(DbPaths.collectionusers)
//                                       .doc(call.receiverId)
//                                       .collection('recent')
//                                       .doc('callended')
//                                       .set({
//                                     'id': call.receiverId,
//                                     'ENDED': DateTime.now().millisecondsSinceEpoch
//                                   }, SetOptions(merge: true));
//
//                                   firestoreDataProviderCALLHISTORY.fetchNextData(
//                                       'CALLHISTORY',
//                                       FirebaseFirestore.instance
//                                           .collection(DbPaths.collectionusers)
//                                           .doc(call.receiverId)
//                                           .collection(
//                                               DbPaths.collectioncallhistory)
//                                           .orderBy('TIME', descending: true)
//                                           .limit(14),
//                                       true);
//                                 },
//                                 child: Icon(
//                                   Icons.call_end,
//                                   color: Colors.white,
//                                   size: 35.0,
//                                 ),
//                                 shape: CircleBorder(),
//                                 elevation: 2.0,
//                                 fillColor: Colors.redAccent,
//                                 padding: const EdgeInsets.all(15.0),
//                               ),
//                               SizedBox(width: 45),
//                               RawMaterialButton(
//                                 onPressed: () async {
//                                   flutterLocalNotificationsPlugin.cancelAll();
//                                   await Permissions
//                                           .cameraAndMicrophonePermissionsGranted()
//                                       .then((isgranted) async {
//                                     if (isgranted == true) {
//                                       await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => call
//                                                       .isvideocall ==
//                                                   true
//                                               ? VideoCall(
//                                                   currentuseruid: currentuseruid,
//                                                   call: call,
//                                                   channelName: call.channelId,
//                                                   role: _role,
//                                                 )
//                                               : AudioCall(
//                                                   currentuseruid: currentuseruid,
//                                                   call: call,
//                                                   channelName: call.channelId,
//                                                   role: _role,
//                                                 ),
//                                         ),
//                                       );
//                                     } else {
//                                       HelperFunctions.toast(
//                                           'Permission to access Microphone & camera is required to Start.');
//                                       // Navigator.push(
//                                       //     context,
//                                       //     new MaterialPageRoute(
//                                       //         builder: (context) =>
//                                       //             OpenSettings()));
//                                     }
//                                   }).catchError((onError) {
//                                     HelperFunctions.toast(
//                                         'Permission to access Microphone & camera is required to Start.');
//                                   });
//                                 },
//                                 child: Icon(
//                                   Icons.call,
//                                   color: Colors.white,
//                                   size: 35.0,
//                                 ),
//                                 shape: CircleBorder(),
//                                 elevation: 2.0,
//                                 fillColor: Colors.green[400],
//                                 padding: const EdgeInsets.all(15.0),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ))
//             : Scaffold(
//                 backgroundColor: Config().colorMain,
//                 body: SingleChildScrollView(
//                   child: Container(
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.symmetric(vertical: w > h ? 60 : 100),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         w > h
//                             ? SizedBox(
//                                 height: 0,
//                               )
//                             : Icon(
//                                 call.isvideocall == true
//                                     ? Icons.videocam_outlined
//                                     : Icons.mic,
//                                 size: 80,
//                                 color: DESIGN_TYPE == Themetype.whatsapp
//                                     ? fiberchatWhite.withOpacity(0.3)
//                                     : fiberchatBlack.withOpacity(0.3),
//                               ),
//                         w > h
//                             ? SizedBox(
//                                 height: 0,
//                               )
//                             : SizedBox(
//                                 height: 20,
//                               ),
//                         Text(
//                           call.isvideocall == true
//                               ? 'FaceTime'
//                               : 'Audio',
//                           style: TextStyle(
//                             fontSize: 19,
//                             color: DESIGN_TYPE == Themetype.whatsapp
//                                 ? fiberchatWhite.withOpacity(0.54)
//                                 : fiberchatBlack.withOpacity(0.54),
//                           ),
//                         ),
//                         SizedBox(height: w > h ? 16 : 50),
//                         CachedImage(
//                           call.callerPic,
//                           isRound: true,
//                           height: w > h ? 60 : 110,
//                           width: w > h ? 60 : 110,
//                           radius: w > h ? 70 : 138,
//                         ),
//                         SizedBox(height: 15),
//                         Text(
//                           call.callerName,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: DESIGN_TYPE == Themetype.whatsapp
//                                 ? fiberchatWhite
//                                 : fiberchatBlack,
//                             fontSize: 22,
//                           ),
//                         ),
//                         SizedBox(height: w > h ? 30 : 75),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             RawMaterialButton(
//                               onPressed: () async {
//                                 flutterLocalNotificationsPlugin.cancelAll();
//                                 await callMethods.endCall(call: call);
//                                 FirebaseFirestore.instance
//                                     .collection(DbPaths.collectionusers)
//                                     .doc(call.callerId)
//                                     .collection(DbPaths.collectioncallhistory)
//                                     .doc(call.timeepoch.toString())
//                                     .set({
//                                   'STATUS': 'rejected',
//                                   'ENDED': DateTime.now(),
//                                 }, SetOptions(merge: true));
//                                 FirebaseFirestore.instance
//                                     .collection(DbPaths.collectionusers)
//                                     .doc(call.receiverId)
//                                     .collection(DbPaths.collectioncallhistory)
//                                     .doc(call.timeepoch.toString())
//                                     .set({
//                                   'STATUS': 'rejected',
//                                   'ENDED': DateTime.now(),
//                                 }, SetOptions(merge: true));
//                                 //----------
//                                 await FirebaseFirestore.instance
//                                     .collection(DbPaths.collectionusers)
//                                     .doc(call.receiverId)
//                                     .collection('recent')
//                                     .doc('callended')
//                                     .set({
//                                   'id': call.receiverId,
//                                   'ENDED': DateTime.now().millisecondsSinceEpoch
//                                 }, SetOptions(merge: true));
//
//                                 firestoreDataProviderCALLHISTORY.fetchNextData(
//                                     'CALLHISTORY',
//                                     FirebaseFirestore.instance
//                                         .collection(DbPaths.collectionusers)
//                                         .doc(call.receiverId)
//                                         .collection(
//                                             DbPaths.collectioncallhistory)
//                                         .orderBy('TIME', descending: true)
//                                         .limit(14),
//                                     true);
//                               },
//                               child: Icon(
//                                 Icons.call_end,
//                                 color: Colors.white,
//                                 size: 35.0,
//                               ),
//                               shape: CircleBorder(),
//                               elevation: 2.0,
//                               fillColor: Colors.redAccent,
//                               padding: const EdgeInsets.all(15.0),
//                             ),
//                             SizedBox(width: 45),
//                             RawMaterialButton(
//                               onPressed: () async {
//                                 flutterLocalNotificationsPlugin.cancelAll();
//                                 await Permissions
//                                         .cameraAndMicrophonePermissionsGranted()
//                                     .then((isgranted) async {
//                                   if (isgranted == true) {
//                                     await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => call
//                                                     .isvideocall ==
//                                                 true
//                                             ? VideoCall(
//                                                 currentuseruid: currentuseruid,
//                                                 call: call,
//                                                 channelName: call.channelId,
//                                                 role: _role,
//                                               )
//                                             : AudioCall(
//                                                 currentuseruid: currentuseruid,
//                                                 call: call,
//                                                 channelName: call.channelId,
//                                                 role: _role,
//                                               ),
//                                       ),
//                                     );
//                                   } else {
//                                     HelperFunctions.toast(
//                                         'Permission to access Microphone & camera is required to Start.');
//                                     // Navigator.push(
//                                     //     context,
//                                     //     new MaterialPageRoute(
//                                     //         builder: (context) =>
//                                     //             OpenSettings()));
//                                   }
//                                 }).catchError((onError) {
//                                   HelperFunctions.toast(
//                                       'Permission to access Microphone & camera is required to Start.');
//                                   // Navigator.push(
//                                   //     context,
//                                   //     new MaterialPageRoute(
//                                   //         builder: (context) =>
//                                   //             OpenSettings()));
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.call,
//                                 color: Colors.white,
//                                 size: 35.0,
//                               ),
//                               shape: CircleBorder(),
//                               elevation: 2.0,
//                               fillColor: fiberchatLightGreen,
//                               padding: const EdgeInsets.all(15.0),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ));
//   }
// }
