import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/locaiton_manh.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc {
  List<LocationManh> addLocationTinh = new List<LocationManh>();
  List<LocationManh> addLocation1 = new List<LocationManh>();
  List<LocationManh> addLocationQuan = new List<LocationManh>();
  List<LocationManh> addLocationPhuong = new List<LocationManh>();

  final _Addlocalist = BehaviorSubject<dynamic>();
  Stream<dynamic> get allLoca => _Addlocalist.stream;

  final _Addlocalist1 = BehaviorSubject<dynamic>();
  Stream<dynamic> get allLoca1 => _Addlocalist1.stream;

  final _AddlocalistQuan = BehaviorSubject<dynamic>();
  Stream<dynamic> get allLocaQuan => _AddlocalistQuan.stream;

  final _AddlocalistPhuong = BehaviorSubject<dynamic>();
  Stream<dynamic> get allLocaPhuong => _AddlocalistPhuong.stream;

  StreamController addTinh = new StreamController<LocationManh>();
  Stream<LocationManh> get addTinhDefaultStream => addTinh.stream;

  StreamController addQuan = new StreamController<LocationManh>();
  Stream<LocationManh> get addQuanDefaultStream => addQuan.stream;

  StreamController addPhuong = new StreamController<LocationManh>();
  Stream<LocationManh> get addPhuongDefaultStream => addPhuong.stream;

  loacationBlocManh() async {
    var token = await Const.web_api.getToken();

    var response = await Const.web_api
        .getAsync("/app/home/get-option-provinces", token);
    if (response['code'] == 1) {
      var loca = response['data'];
      loca.forEach((key, value) {
        var locationTinh = new LocationManh(
          id: key.toString(),
          name: value.toString()
        );
        addLocationTinh.add(locationTinh);
      });

    }
    return addLocationTinh;
  }
  loacationBlocTinh() async {
    var token = await Const.web_api.getToken();
    Map<String , String> map = new Map();
    var response = await Const.web_api
        .getAsync("/app/home/get-option-provinces", token);
    if (response['code'] == 1) {
        response['data'].forEach((k,v){
          var location = new LocationManh(
            id: k.toString(),
            name: v.toString(),
          );
          addLocation1.add(location);
      });
    }
    _Addlocalist1.sink.add(addLocation1);
    return addLocation1;
  }
  locationQuan(String id) async {
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['province_id'] = id;
    var response = await Const.web_api
        .postAsync("/app/home/get-option-districts", token, request_body);
    if (response['code'] == 1) {
        var loca = response['data'];
        loca.forEach((key, value) {
          var locationQuan = new LocationManh(
            id: key.toString(),
            name: value.toString(),
          );
          addLocationQuan.add(locationQuan);
        });
        _AddlocalistQuan.sink.add(addLocationQuan);
    }
    return addLocationQuan;
  }
  locationPhuong(String id) async {
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['district_id'] = id;
    var response = await Const.web_api
        .postAsync("/app/home/get-option-wards", token, request_body);

    if (response['code'] == 1) {
      var loca = response['data'];
      loca.forEach((key, value) {
        var locationPhuong = new LocationManh(
          id: key.toString(),
          name: value.toString(),
        );
        addLocationPhuong.add(locationPhuong);
      });
      _AddlocalistPhuong.sink.add(addLocationPhuong);
    }
    return addLocationPhuong;
  }
  locationPost(String  name, phone, email, province_id,district_id,ward_id,address,isdefault) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['UserAddress'] = {
      "name_contact": "$name",
      "phone": "$phone",
      "email": "$email",
      "province_id": "$province_id",
      "district_id": "$district_id",
      "ward_id": "$ward_id",
      "address": "$address",
      "isdefault": "$isdefault"
    };
    var response = await Const.web_api
        .postAsync("/app/user/add-address-user", token, request_body);
    return response;
  }
  locationUpdate(String id,name, phone, email, province_id,district_id,ward_id,address,isdefault) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['id'] = id;
    request_body['UserAddress'] = {
      "name_contact": "$name",
      "phone": "$phone",
      "email": "$email",
      "province_id": "$province_id",
      "district_id": "$district_id",
      "ward_id": "$ward_id",
      "address": "$address",
      "isdefault": isdefault
    };
    var response = await Const.web_api
        .postAsync("/app/user/update-address-user", token, request_body);

    return response;
  }
  locationDelete(String id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['id'] = id;
    var response = await Const.web_api
        .postAsync("/app/user/del-address-user", token, request_body);
    return response;
  }

  setDefault(item){
    addTinh.sink.add(item);
  }

  setDefaultQuan(item){
    addQuan.sink.add(item);
  }

  setDefaultPhuong(item){
    addPhuong.sink.add(item);
  }
  dispose(){
    _Addlocalist.close();
    _Addlocalist1.close();
    _AddlocalistQuan.close();
    _AddlocalistPhuong.close();
  }
}

