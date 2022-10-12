import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/toast.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'api.dart';

class General {
  converSale(int price, int price_market) {
    if(price_market != 0 && price_market > price){
      double sale = 1 - (price / price_market);
      return (sale * 100).round();
    }else{
      return 0;
    }
  }

  bool validate(Map request,context) {
    bool check = true;
    for (var key in request.keys) {
      if (request[key] == '') {
        check = false;
        showToast(key, context, Colors.amberAccent, Icons.error_outline);
        break;
      }
    }
    return check;
  }
}
