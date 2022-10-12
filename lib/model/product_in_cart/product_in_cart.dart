import 'package:flutter/cupertino.dart';

// ignore: camel_case_types
class Products_In_Cart {
  int idP;
  String imageP;
  double priceP;
  String nameP;
  int quantityP;

  Products_In_Cart({
    this.idP,
    this.imageP,
    this.priceP,
    this.nameP,
    this.quantityP,
  });

  Map<String, dynamic> toMap() {
    return {
      'idP': idP,
      'imageP': imageP,
      'nameP': nameP,
      'priceP': priceP,
      'quantityP': quantityP,
    };
  }
}
