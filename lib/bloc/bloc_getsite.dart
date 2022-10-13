import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/main.dart';
import 'package:gcaeco_app/model/media/imageItem.dart';
import 'package:gcaeco_app/model/media/model_site.dart';

class SiteBloc {
 getSite() async {
     ModelSite modelSite=ModelSite();
    var token = await Const.web_api.getToken();
    var response = await Const.web_api
       .getAsync("/app/home/get-siteinfo",token);
    print(response);
    if (response != null) {
      if (response['code'] == 1) {
        modelSite=ModelSite.fromJson(response['data']);
      }
    }
    return modelSite;
  }



  @override
  dispose() {
  }
}
