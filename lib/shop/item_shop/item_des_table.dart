
import 'package:flutter/material.dart';

class ItemDesTable extends StatelessWidget {
  String des;
  String des1;
  double width;
  ItemDesTable({this.des,this.des1,this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      height: 80,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(des, style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 15
          )),
          Text(des1 != null ? des1: '', style: TextStyle(
              color: Colors.red,
              fontSize: 15
          )),
        ],
      ),
    );
  }
}
