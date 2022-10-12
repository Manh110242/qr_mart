import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/location_manh/location_manh.dart';

class Location extends StatefulWidget {
  @override
  _Location createState() => _Location();
}

class _Location extends State<Location> {

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
    //call_api_address();
   // var mda = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Địa chỉ"),
      ),
      body: DiaChiScreen(),
    );
  }
}
//FutureBuilder(
//               future: solan == 0 ? call_api_address() : null,
//               builder: (context, snapshot) {
//                 return snapshot.hasData
//                     ? Column(
//                         children: [
//                           ListView.builder(
//                               controller: new ScrollController(),
//                               // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//                               shrinkWrap: true,
//                               itemCount: snapshot.data['data'].length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Card(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Column(
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               EdgeInsets.fromLTRB(0, 7, 0, 7),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 "Họ và tên: ",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14),
//                                               ),
//                                               Container(
//                                                 width: mda / 1.5,
//                                                 child: Text(
//                                                   snapshot.data['data'][index]
//                                                       ['name_contact'],
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   maxLines: 3,
//                                                   style: TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: 14),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         //-----------------
//                                         Padding(
//                                           padding:
//                                               EdgeInsets.fromLTRB(0, 7, 0, 7),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 "Điện thoại:",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14),
//                                               ),
//                                               Container(
//                                                 width: mda / 1.5,
//                                                 child: Text(
//                                                   snapshot.data['data'][index]
//                                                       ['phone'],
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   maxLines: 2,
//                                                   style: TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: 14),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         //---------------------------
//                                         Padding(
//                                           padding:
//                                               EdgeInsets.fromLTRB(0, 7, 0, 7),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 "Quận/huyện: ",
//                                                 style: TextStyle(
//                                                     fontSize: mda / 25),
//                                               ),
//                                               Container(
//                                                 width: mda / 1.5,
//                                                 child: Text(
//                                                   snapshot.data['data'][index]
//                                                           ['ward_name'] +
//                                                       "," +
//                                                       snapshot.data['data']
//                                                               [index]
//                                                           ['district_name'] +
//                                                       "," +
//                                                       snapshot.data['data']
//                                                               [index]
//                                                           ['province_name'] +
//                                                       ".",
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   maxLines: 5,
//                                                   style: TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: 14),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         //--------------
//                                         Padding(
//                                           padding:
//                                               EdgeInsets.fromLTRB(0, 7, 0, 7),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 "Địa chỉ: ",
//                                                 style: TextStyle(
//                                                     fontSize: mda / 25),
//                                               ),
//                                               Container(
//                                                 width: mda / 1.5,
//                                                 child: Text(
//                                                   snapshot.data['data'][index]
//                                                       ['address'],
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   maxLines: 5,
//                                                   style: TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: 14),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         //------------
//                                         Padding(
//                                           padding: snapshot.data['data'][index]
//                                                           ['isdefault']
//                                                       .toString() ==
//                                                   "1"
//                                               ? EdgeInsets.fromLTRB(0, 7, 0, 7)
//                                               : EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 snapshot.data['data'][index]
//                                                                 ['isdefault']
//                                                             .toString() ==
//                                                         "1"
//                                                     ? "[Mặc định]"
//                                                     : "",
//                                                 style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: mda / 25),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             Container(
//                                               margin: EdgeInsets.fromLTRB(
//                                                   0, 0, 10, 0),
//                                               width: mda / 4,
//                                               height: 35,
//                                               color: Config().colorMain,
//                                               child: FlatButton(
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.description,
//                                                       color: Colors.white,
//                                                       size: mda / 25,
//                                                     ),
//                                                     Text(
//                                                       'Cập nhật',
//                                                       style: TextStyle(
//                                                         fontSize: mda / 35,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 //color: Colors.blue,
//                                                 textColor: Colors.white,
//                                                 onPressed: () {},
//                                               ),
//                                             ),
//                                             Container(
//                                               height: 35,
//                                               color: Colors.orangeAccent,
//                                               margin: EdgeInsets.fromLTRB(
//                                                   0, 0, 10, 0),
//                                               width: mda / 5,
//                                               child: FlatButton(
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.cancel,
//                                                       color: Colors.white,
//                                                       size: mda / 25,
//                                                     ),
//                                                     Text(
//                                                       'Xóa ',
//                                                       style: TextStyle(
//                                                           fontSize: mda / 35,
//                                                           color: Colors.white),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 //  color: Colors.red,
//                                                 textColor: Colors.white,
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     solan = 0;
//                                                   });
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }),
//                           Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     new MaterialPageRoute(
//                                         builder: (context) => Add_adress()));
//                               },
//                               child: Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text("Thêm địa chỉ mới"),
//                                       Icon(
//                                         Icons.add,
//                                         color: Colors.black54,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             height: 50,
//                           )
//                         ],
//                       )
//                     : Center(child: CircularProgressIndicator());
//               })