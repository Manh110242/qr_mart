import 'api.dart';

class Const {
  String domain = 'https://qrmart.vn';
  String image_host = 'https://qrmart.vn/static';
  String key = 'key_nanoweb_ocop_2021_real';
  String api_host = 'https://qrmart.vn/api';

  static GetAPI web_api = new GetAPI(Const().api_host, Const().key);


}
