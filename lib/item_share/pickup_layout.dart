// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gcaeco_app/model/call.dart';
// import 'package:gcaeco_app/model/call_method.dart';
// import 'package:gcaeco_app/provider/user_provider.dart';
// import 'package:gcaeco_app/screen/404.dart';
// import 'package:provider/provider.dart';
//
// import 'pickup_screen.dart';
//
// class PickupLayout extends StatelessWidget {
//   final Widget scaffold;
//   final CallMethods callMethods = CallMethods();
//
//   PickupLayout({
//     @required this.scaffold,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final UserProvider userProvider = Provider.of<UserProvider>(context);
//
//     return (userProvider != null && userProvider.getUser != null)
//         ? StreamBuilder<DocumentSnapshot>(
//             stream: callMethods.callStream(phone: userProvider.getUser.phone),
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data.data() != null) {
//                 Call call = Call.fromMap(snapshot.data.data());
//
//                 if (!call.hasDialled) {
//                   return PickupScreen(
//                     call: call,
//                     currentuseruid: userProvider.getUser.phone,
//                   );
//                 }
//               }
//
//               return scaffold;
//             },
//           )
//         : scaffold;
//   }
// }
