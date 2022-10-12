import 'dart:async';
import '../main.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/flash_sale.dart';
import 'package:gcaeco_app/model/locaiton_manh.dart';
import 'package:gcaeco_app/model/products/productItem.dart';

class BlocHomeNew {
  List flashSaleProduct = [];
  StreamController flashSaleController = StreamController();

  Stream get flashStream => flashSaleController.stream;

  static getLogoVip() async {
    var token = await Const.web_api.getToken();
    var response =
        await Const.web_api.getAsync("app/product/get-vip-product", token);
    if (response != null) {
      if (response['logo'] != null) {
        for (var item in response['logo']) {
          LocationManh loca = new LocationManh(
            id: item['id'].toString(),
            name: item['logo'].toString(),
          );
          logoVip.add(loca);
        }
      }
    }
    return logoVip;
  }
  static getImageVip(type) {
    String imageVip = "";
    if (logoVip.isNotEmpty) {
      logoVip.forEach(
            (element) {
          if (element.id == type) {
            imageVip = element.name;
          }
        },
      );
    }
    return imageVip;
  }
  getFlashSale(page) async {
    List products = [];
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['type'] = "type_flash_sale";
    request_body['limit'] = 10;
    request_body['page'] = page;
    var response = await Const.web_api
        .postAsync("/blockcheck/getdata/get-data-home", token, request_body);

    if (response != null) {
      if (response['code'] == 1) {
        if (response['data'] != null && response['data'].length > 0) {
          var promotion = response['data']['promotion'];
          for (var item in response['data']['products']) {
            var productItem = new ProductItem(
              id: item['id'].toString(),
              name: item['name'].toString(),
              avatar_path: item['avatar_path'].toString(),
              avatar_name: item['avatar_name'].toString(),
              price: item['price_promotion_sale'] != null
                  ? int.parse(
                      double.parse(item['price_promotion_sale'].toString())
                          .round()
                          .toString())
                  : 0,
              price_market: item['price'] != null
                  ? int.parse(
                      double.parse(item['price'].toString()).round().toString())
                  : 0,
              fee_ship: item['fee_ship'].toString(),
              rate_count: item['rate_count'].toString(),
              rate: item['rate'] == null ? 0 : double.parse(item['rate']),
              quantity_promotion_sale:
                  item['quantity_promotion_sale'].toString(),
              quantity_selled_promotion_sale:
                  item['quantity_selled_promotion_sale'].toString(),
              vip_active: item['vip_active'] != null
                  ? item['vip_active'].toString()
                  : "",
              logo_vip: BlocHomeNew.getImageVip(item['vip'].toString()) ,
            );
            products.add(productItem);
            flashSaleProduct.add(productItem);
          }
          flashSaleController.sink.add(flashSaleProduct);

          ModelFlashSale flashSale = new ModelFlashSale(
            id: promotion["id"].toString(),
            name: promotion["name"].toString(),
            sortdesc: promotion["sortdesc"].toString(),
            description: promotion["description"].toString(),
            status: promotion["status"].toString(),
            startdate: promotion["startdate"].toString(),
            enddate: promotion["enddate"].toString(),
            alias: promotion["alias"].toString(),
            showinhome: promotion["showinhome"].toString(),
            meta_title: promotion["meta_title"].toString(),
            meta_keywords: promotion["meta_keywords"].toString(),
            meta_description: promotion["meta_description"].toString(),
            created_time: promotion["created_time"].toString(),
            image_path: promotion["image_path"].toString(),
            image_name: promotion["image_name"].toString(),
            ishot: promotion["ishot"].toString(),
            category_id: promotion["category_id"].toString(),
            order: promotion["order"].toString(),
            time_space: promotion["time_space"].toString(),
            products: products,
          );
          return flashSale;
        }
      }
    }
    return null;
  }

  getBankAdmin() async {
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['type'] = "type_bank";
    request_body['limit'] = 10;

    var response = await Const.web_api
        .postAsync("/blockcheck/getdata/get-data-home", token, request_body);

    if (response != null) {
      if (response['data'] != null) {
        for (var item in response['data']['banks']) {
          if (item['isdefault'] == 1) {
            return response['data']['banks'][0];
          }
        }
      }
    }
  }
}
