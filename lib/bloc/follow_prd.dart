import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/screen_login.dart';

class FollowPrd{
  addWishlist(context,product_id) async {
    Const.web_api.checkLogin().then((value)async{
      if(value == ''){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Login_Screen()
        ));
      }else{
        var user_id = await Const.web_api.getUserId();
        var token = await Const.web_api.getTokenUser();
        Map<String, dynamic> request_body = new Map<String, dynamic>();
        request_body['user_id'] = user_id;
        request_body['product_id'] = product_id;
        var response = await Const.web_api
            .postAsync("/app/user/wish-product", token, request_body);
        if(response != null){
          if (response['code'] == 1) {
            showToast(response['message'],
                context, Colors.green, Icons.check_circle);
          }else{
            showToast(response['error'],
                context, Colors.yellow, Icons.error);
          }
        }else{
          showToast("Kết nối server thất bại",
              context, Colors.yellow, Icons.error);
        }
      }
    });
  }
}
