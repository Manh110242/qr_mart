import 'package:flutter/material.dart';
List tinh = new List();
List id_tinh = new List();
List huyen = new List();
List id_huyen = new List();
List xa = new List();
List id_xa = new List();
List<DropdownMenuItem<String>> gettinhDropDownMenuItems() {
  List<DropdownMenuItem<String>> items = new List();
  for (String de in tinh) {
    items.add(drop(de));
  }
  return items;
}
List<DropdownMenuItem<String>> gethuyenDropDownMenuItems() {
  List<DropdownMenuItem<String>> items = new List();
  for (String de in huyen) {
    items.add(drop(de));
  }
  return items;
}
List<DropdownMenuItem<String>> getxaDropDownMenuItems() {
  List<DropdownMenuItem<String>> items = new List();
  for (String de in xa) {
    items.add(drop(de));
  }
  return items;
}

//=============drop
Widget drop(String d) {
  return new DropdownMenuItem(
      value: d,
      child: Center(
        child:Text(
          d,
          style: TextStyle(fontSize: 9),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ));
}