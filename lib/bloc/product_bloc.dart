import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/model/media/imageItem.dart';
import 'package:gcaeco_app/model/products/CategoryItem.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/model/products/searchtItem.dart';
import 'package:gcaeco_app/model/rate_model.dart';
import 'package:gcaeco_app/model/shop.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc_home_new.dart';

class ProductBloc {

  final _ProductListFetcher = BehaviorSubject<dynamic>();
  Stream<dynamic> get allProducts => _ProductListFetcher.stream;
  List<ProductItem> products = new List<ProductItem>();

  StreamController<dynamic> rate = StreamController<dynamic>();
  Stream<dynamic> get rating => rate.stream;

  getProduct(keyword, page, s) async {
    if(s){
      products= [];
    }
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['keyword'] = keyword;
    request_body['limit'] = 12;
    request_body['page'] = page;
    var response = await Const.web_api
        .postAsync("/app/product/get-products", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for(var item in response['data']){
          var productItem = new ProductItem(
            id: item['id'].toString(),
            name: item['name'].toString(),
            avatar_path: item['avatar_path'].toString(),
            avatar_name: item['avatar_name'].toString(),
            price: item['price'],
            price_market: item['price_market'],
            fee_ship: item['fee_ship'].toString(),
            rate_count: item['rate_count'].toString(),
            rate: item['rate'] == null ? 0 : double.parse(item['rate']),
            in_wish: item['in_wish'],
          );
          products.add(productItem);
        }
      }
    }
    _ProductListFetcher.sink.add(products);
    return products;
  }

  getProductHot() async {
    List<ProductItem> products = new List<ProductItem>();
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['ishot'] = 1;
    request_body['limit'] = 15;
    request_body['user_id'] = user_id;
    var response = await Const.web_api
        .postAsync("/app/product/get-products", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          var productItem = new ProductItem(
            id: item['id'].toString(),
            name: item['name'].toString(),
            avatar_path: item['avatar_path'].toString(),
            avatar_name: item['avatar_name'].toString(),
            price: item['price'],
            price_market: item['price_market'],
            fee_ship: item['fee_ship'].toString(),
            rate_count: item['rate_count'].toString(),
            rate: item['rate'] == null ? 0 : double.parse(item['rate']),
            in_wish: item['in_wish'],
            vip_active: item['vip_active'] != null
                ? item['vip_active'].toString()
                : "",
            logo_vip: BlocHomeNew.getImageVip(item['vip'].toString()) ,
          );
          products.add(productItem);
        }
      }
    }
    return products;
  }
  getProductByListCategoryHome() async {
    List<CategoryItem> categories = new List<CategoryItem>();
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['limit'] = 6;
    request_body['user_id'] = user_id;
    var response = await Const.web_api.postAsync(
        "/app/home/get-productcat-showhome2product", token, request_body);


    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          List<ProductItem> products = new List<ProductItem>();
          if (item['products'].length > 0) {
            for (var prd in item['products']) {
              var productItem = new ProductItem(
                id: prd['id'].toString(),
                name: prd['name'].toString(),
                avatar_path: prd['avatar_path'].toString(),
                avatar_name: prd['avatar_name'].toString(),
                price: prd['price'],
                price_market: prd['price_market'],
                fee_ship: prd['fee_ship'].toString(),
                rate_count: prd['rate_count'].toString(),
                in_wish: prd['in_wish'],
                rate: prd['rate'] == null ? 0 : double.parse(prd['rate']),
                vip_active: prd['vip_active'] != null
                    ? prd['vip_active'].toString()
                    : "",
                logo_vip: BlocHomeNew.getImageVip(prd['vip'].toString()) ,
              );
              products.add(productItem);
            }
            var catItem = new CategoryItem(
              id: item['id'],
              name: item['name'],
              status: item['status'],
              icon_path: item['icon_path'],
              icon_name: item['icon_name'],
              avatar_path: item['avatar_path'],
              avatar_name: item['avatar_name'],
              bgr_path: item['bgr_path'],
              bgr_name: item['bgr_name'],
              products: products,
            );
            categories.add(catItem);
          }
        }
      }
    }
    return categories;
  }
  getSearchtHot() async {
    List<SearchItem> products = new List<SearchItem>();
    var token = await Const.web_api.getToken();
    Map<String, int> request_body = new Map<String, int>();
    request_body['limit'] = 15;
    var response = await Const.web_api
        .postAsync("/app/home/get-key-search-product", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          var productItem = new SearchItem(
            id: item['id'].toString(),
            keyword: item['keyword'].toString(),
            avatar_path: item['avatar_path'].toString(),
            avatar_name: item['avatar_name'].toString(),
            click: item['click'].toString(),
            totalitem: item['totalitem'].toString(),
          );
          products.add(productItem);
        }
      }
    }
    return products;
  }
  getProductDetail(String product_id) async {
    var res = new Map();
    var product = new ProductItem();
    final List<String> imgList = [];
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['product_id'] = product_id;
    var response = await Const.web_api.postAsync(
        "/app/product/data-page-detail-product", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        product = new ProductItem(
          id: response['data']['id'].toString(),
          name: response['data']['name'].toString(),
          avatar_path: response['data']['avatar_path'].toString(),
          avatar_name: response['data']['avatar_name'].toString(),
          price: response['data']['price'],
          price_market: response['data']['price_market'],
          fee_ship: response['data']['fee_ship'].toString(),
          rate_count: response['data']['rate_count'].toString(),
          shop_id: response['data']['shop_id'].toString(),
          rate: response['data']['rate'] == null ? 0 : response['data']['rate'].toDouble(),
        );
        res['product'] = product;

        if(response['data']['images'] != null){
          for(var img in response['data']['images']){
            imgList.add(Const().image_host+img['path']+img['name']);
          }
        }
        res['images'] = imgList;
      }
    }
    return res;
  }
  totalCart() async{
    int count = 0;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String cart = prefs.getString('cart');
    if(cart != null) {
      final List<CartItem> decodedData = CartItem.decode(cart);
      count = decodedData.length;
    }
    return count;
  }
  getWishlist(Map request_body) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    request_body['user_id'] = user_id;
    var response = await Const.web_api
        .postAsync("/app/user/get-product-wish", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for(var item in response['data']){
          var productItem = new ProductItem(
            id: item['id'].toString(),
            name: item['name'].toString(),
            avatar_path: item['avatar_path'].toString(),
            avatar_name: item['avatar_name'].toString(),
            price: item['price'],
            price_market: item['price_market'],
            fee_ship: item['fee_ship'].toString(),
            rate_count: item['rate_count'].toString(),
            rate: item['rate'] == null ? 0 : double.parse(item['rate']),
            in_wish: item['in_wish'],
            vip_active: item['vip_active'] != null
                ? item['vip_active'].toString()
                : "",
            logo_vip: BlocHomeNew.getImageVip(item['vip'].toString()) ,
          );
          products.add(productItem);
        }
      }
    }
    _ProductListFetcher.sink.add(products);
  }

  getRate(String product_id) async {
    var token = await Const.web_api.getToken();
    List<RateModel> listRate = [];
    Map<String, String> req_body  = Map();
    req_body["product_id"] = product_id;
    var res = await Const.web_api.postAsync("/app/product/data-page-detail-product", token, req_body);

    if(res!=null){
      if(res['data']!=null){
        var shop = new Shop(
          id: res['data']['id'].toString(),
          name: res['data']['name'].toString(),
          rate: res['data']['rate'].toString(),
          rate_count: res['data']['rate_count'].toString(),
        );
        res['shop'] = shop;
        for(var ratings in res['data']['ratings']){
          var rate = new RateModel(
              id: ratings['id'].toString(),
              name: ratings['name'].toString(),
              user_id: ratings['user_id'].toString(),
              email: ratings['email'].toString(),
              rating: ratings['rating'].toString(),
              content: ratings['content'].toString(),
              object_id: ratings['object_id'].toString(),
              username: ratings['username'].toString(),
              avatar_name: ratings['avatar_name'].toString(),
              avatar_path: ratings['avatar_path'].toString(),
              images: ratings['images'],
          );
          listRate.add(rate);
        }
        res["ratings"] = listRate;
      }
    }
    rate.sink.add(res);
    return res;
  }
  postComment({
    String object_id,
    int type,
    String content,
    double rating,
    List listImage,
  }) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    Map<String, dynamic> req = new Map();
    Dio dio = new Dio();
    req['user_id'] = user_id;
    req['object_id'] =object_id;
    req['type'] =type;
    req['rating'] = rating.round();
    req['content'] = content;
    if (listImage != null && listImage.length > 0 ) {
      List<MultipartFile> images = [];
      MultipartFile img;
      for(var image in listImage){
        img = await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last);
        images.add(img);
      }
      req["images[]"] = images;
    }

    FormData formData = new FormData.fromMap(req);
    var res = await dio
        .post(Const().api_host + "/v1/rating/create",
        data: formData,
        options: Options(
          headers: {"token": token},
        ))
        .catchError((err) {
      return null;
    });
    return res.data;
  }

  @override
  dispose() {
    _ProductListFetcher.close();
    rate.close();
  }
}
