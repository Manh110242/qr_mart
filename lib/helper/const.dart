import 'api.dart';

class Const {
  // String domain = 'https://app.tiepthiso.org';
  // String image_host = 'https://app.tiepthiso.org/static';
  // String key = 'key_nanoweb_pga_2021_real';
  // String api_host = 'https://app.tiepthiso.org/api';

  String domain = 'https://qrmart.vn';
  String image_host = 'https://qrmart.vn/static';
  String key = 'key_nanoweb_ocop_2021_real';
  String api_host = 'https://qrmart.vn/api';
String domain_2='http://hoidap.nanoweb.vn/api';

  static GetAPI web_api = new GetAPI(Const().api_host, Const().key);


}
