import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class AddressItem {
  final String id;
  final String name_contact;
  final String phone;
  final String email;
  final String province_name;
  final String district_name;
  final String ward_name;
  final String address;
  final String isdefault;
  final String province_id;
  final String district_id;
  final String ward_id;
  final String user_gt_app;


  AddressItem({
    this.id,
    this.name_contact,
    this.phone,
    this.email,
    this.province_name,
    this.district_name,
    this.ward_name,
    this.address,
    this.isdefault,
    this.province_id,
    this.district_id,
    this.ward_id,
    this.user_gt_app
  });


  factory AddressItem.fromJson(Map<String, dynamic> jsonData) {
    return AddressItem(
      id: jsonData['id'],
      name_contact: jsonData['name_contact'],
      phone: jsonData['phone'],
      email: jsonData['email'],
      province_name: jsonData['province_name'],
      district_name: jsonData['district_name'],
      ward_name: jsonData['ward_name'],
      address: jsonData['address'],
      isdefault: jsonData['isdefault'],
      province_id: jsonData['province_id'],
      district_id: jsonData['district_id'],
      ward_id: jsonData['ward_id'],
    );
  }
}