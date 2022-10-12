import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/wallet/bankAccountItem.dart';
import 'package:gcaeco_app/model/wallet/bankItem.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class BankBloc {
  List<BankItem> bankList = new List<BankItem>();

  final _bankListFetcher = BehaviorSubject<dynamic>();

  Stream<dynamic> get allBank => _bankListFetcher.stream;

  // Lấy danh sách ngân hàng của user
  createBank(userBank) async {
    var map = new Map();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['UserBank'] = userBank;
    var response = await Const.web_api
        .postAsync("/app/user/add-bank", token, request_body);
    map['code'] = 0;
    if (response != null) {
      if (response['code'] == 1) {
        map['code'] = 200;
      } else {
        map['errors'] = response['error'];
      }
    } else {
      map['errors'] = 'Kết nối server thất bại.';
    }
    return map;
  }

  // Lấy danh sách ngân hàng của user
  getListBank(limit, page) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['limit'] = limit;
    request_body['page'] = page;
    var response = await Const.web_api
        .postAsync("/app/user/get-banks", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          var bankItem = new BankItem(
            number: item['number'],
            name: item['name'],
            phone: item['phone'],
            isdefault: item['isdefault'],
            address: item['address'],
            bank_id: item['bank_type'],
            bank_name: item['bank_name'],
          );
          bankList.add(bankItem);
        }
      }
    }
    _bankListFetcher.sink.add(bankList);
  }

  // Lấy danh sách tất cả các ngân hàng trong hệ thống
  getBank() async {
    List<Bank> banks = new List<Bank>();
    var token = await Const.web_api.getToken();
    var response = await Const.web_api.getAsync("/app/home/get-banks", token);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          var bankItem = new Bank(
            id: item['id'],
            name: item['name'],
          );
          banks.add(bankItem);
        }
      }
    }
    return banks;
  }

  @override
  dispose() {
    _bankListFetcher.close();
  }
}
