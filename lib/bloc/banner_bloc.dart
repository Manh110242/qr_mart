import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/media/imageItem.dart';

class BannerBloc {
  getBanner(String group_id,String limit, String category_id) async {
    final List imgBanner = [];
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['group_id'] = group_id;
    request_body['limit'] = limit;
    request_body['category_id'] = category_id;
    var response = await Const.web_api
        .postAsync("/app/home/get-banner", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for(var item in response['data']){
          ImageItem image = ImageItem(
            id: item['id'].toString(),
            name: item['name'].toString(),
            src: item['src'].toString(),
            link: item['link'].toString(),
          );
          imgBanner.add(image);
        }
      }
    }
    return imgBanner;
  }

  getBannerPopup(String group_id,String limit, String category_id) async {
    final List Banners = [];
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    Map<String, dynamic> data = new Map<String, dynamic>();
    request_body['group_id'] = group_id;
    request_body['limit'] = limit;
    request_body['category_id'] = category_id;
    var response = await Const.web_api
        .postAsync("/app/banner/popup-home", token, request_body);
    return response;
  }

  @override
  dispose() {
  }
}
