import 'dart:async';

import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/model_category_new.dart';
import 'package:gcaeco_app/model/model_news.dart';

class BlocNew {
  StreamController newControler = StreamController();
  Stream get newStream => newControler.stream;

  List<ModelNews> list = [];

  getNew(page, category_id) async {
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = Map();
    req['page'] = page;
    req['limit'] = 20;
    req['category_id'] = category_id;
    var res =
        await Const.web_api.postAsync("/app/news/get-news-event", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        for (var item in res['data']['news']) {
          ModelNews model = ModelNews.fromJson(item);
          list.add(model);
        }
      }
    }
    newControler.sink.add(list);
    return list;
  }

  getCategoryNew() async {
    List<ModelCategoryNew> listCatNew = [];
    var token = await Const.web_api.getToken();
    print(token);
    Map<String, dynamic> req = Map();
    var res = await Const.web_api
        .postAsync("/app/news/get-news-category", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        for (var item in res['data']) {
          ModelCategoryNew model = ModelCategoryNew.fromJson(item);
          listCatNew.add(model);
        }
      }
    }
    return listCatNew;
  }

  dispose() {
    newControler.close();
  }
}
