import 'dart:async';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gcaeco_app/helper/const.dart';

class AddressBloc {
  List<AddressItem> addressList = new List<AddressItem>();

  final _AddressListFetcher = BehaviorSubject<dynamic>();
  Stream<dynamic> get allAddress => _AddressListFetcher.stream;

  StreamController addressDefaultValue = new StreamController<AddressItem>();
  Stream<AddressItem> get addressDefaultStream => addressDefaultValue.stream;

  fetchAddress() async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    bool address = true;

    var response = await Const.web_api
        .postAsync("/app/user/get-address-user", token, request_body);
    if (response['code'] == 0) {
    }else{
      if(response['data'].length == 0){
        addressDefaultValue.sink.add(new AddressItem());
      }else{
        for (var prd in response['data']) {
          var address_item = AddressItem(
            id: prd['id'],
            name_contact: prd['name_contact'],
            phone: prd['phone'],
            email: prd['email'],
            province_name: prd['province_name'],
            district_name: prd['district_name'],
            ward_name: prd['ward_name'],
            address: prd['address'],
            isdefault: prd['isdefault'],
            province_id: prd['province_id'],
            district_id: prd['district_id'],
            ward_id: prd['ward_id'],
          );
          addressList.add(address_item);
          if(prd['isdefault'].toString() == '1'){
            if(address){
              addressDefaultValue.sink.add(address_item);
            }
            address = false;
          }else{
            if(address){
              var address_item = AddressItem(
                id: response['data'][0]['id'],
                name_contact: response['data'][0]['name_contact'],
                phone: response['data'][0]['phone'],
                email: response['data'][0]['email'],
                province_name: response['data'][0]['province_name'],
                district_name: response['data'][0]['district_name'],
                ward_name: response['data'][0]['ward_name'],
                address: response['data'][0]['address'],
                isdefault: response['data'][0]['isdefault'],
                province_id: response['data'][0]['province_id'],
                district_id: response['data'][0]['district_id'],
                ward_id: response['data'][0]['ward_id'],
              );
              addressDefaultValue.sink.add(address_item);
            }
          }
        }
      }
    }
    _AddressListFetcher.sink.add(addressList);
  }

  setDefault(item){
    addressDefaultValue.sink.add(item);
  }


  dispose() {
    addressDefaultValue.close();
    _AddressListFetcher.close();
  }
}
