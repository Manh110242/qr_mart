import '../helper/const.dart';

class BlocRemoveUser{
  static delete() async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> req = Map();
    req['user_id'] = user_id;
    var res = await Const.web_api.postAsync("/app/user/block-user", token, req);
    if(res != null){
      if(res['code'] == 1){
        return true;
      }
    }
    return false;
  }
}