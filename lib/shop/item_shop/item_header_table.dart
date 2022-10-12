import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemHeaderTable extends StatelessWidget {
  String title;
  double width;
  ItemHeaderTable({this.title,this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1)
      ),
      child: Center(
        child: Text(title, style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15
        ),),
      ),
    );
  }
}
