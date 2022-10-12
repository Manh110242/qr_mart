import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  final formatter = new NumberFormat("#,###,###");
  final colorMain = new Color(0xff0e4cbd);
  final formatterDate = DateFormat('dd-MM-yyyy');
  final colortextchitietdonhang =TextStyle(
      fontSize: 15,
      color: Colors.black87
  );
}