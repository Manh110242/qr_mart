import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/coupon.dart';
import 'package:gcaeco_app/model/media/imageItem.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/model/products_dom_hang.dart';
import 'package:gcaeco_app/model/shop.dart';
import 'package:gcaeco_app/model/shop.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_home_new.dart';

class ShopBloc {
  final _ProductListFetcher = BehaviorSubject<dynamic>();

  Stream<dynamic> get allProducts => _ProductListFetcher.stream;
  List<ProductItem> products = new List<ProductItem>();

  StreamController Shop1 = StreamController<dynamic>();

  Stream<dynamic> get allPrdShop => Shop1.stream;
  List prd = [];

  StreamController orderShop = StreamController<dynamic>();

  Stream<dynamic> get orderPrdShop => orderShop.stream;
  List orderprd = [];

  StreamController couponShop = StreamController<dynamic>();

  Stream<dynamic> get couponsShop => couponShop.stream;
  List coupons = [];

  StreamController address = StreamController<dynamic>();

  Stream<dynamic> get addressShop => address.stream;
  List addressS = [];

  StreamController affiliate = StreamController<dynamic>();
  Stream<dynamic> get affiliateShop => affiliate.stream;
  List aaffiliateS = [];

  StreamController searchshop = StreamController<dynamic>();
  Stream<dynamic> get searchshopStream => searchshop.stream;
  List searchshops = [];

  fetchProducts(String page, String shop_id, int limit) async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['shop_id'] = shop_id;
    request_body['limit'] = limit;
    request_body['page'] = page;
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
    _ProductListFetcher.sink.add(products);
  }

  fetchShop(String shop_id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['shop_id'] = shop_id;
    request_body['user_id'] = user_id;
    request_body['_qrimages'] = 1;
    var response = await Const.web_api
        .postAsync("/app/product/data-page-detail-shop", token, request_body);

    return response;
  }

  insertPrd(List file, name, description, price, idavt, category_id) async {
    Dio dio = new Dio();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['is_avatar'] = "$idavt";
    request_body['name'] = "$name";
    request_body['description'] = "$description";
    request_body['price'] = "$price";
    request_body['category_id'] = "$category_id";
    // request_body['Product'] = {
    //   "name": "$name",
    //   "description":"$description",
    //   "price":"$price",
    //   "category_id": "$id"
    // };
    for (var i = 0; i < file.length; i++) {
      request_body["image$i"] = await MultipartFile.fromFile(file[i].path,
          filename: file[i].path.split('/').last);
    }

    FormData formData = new FormData.fromMap(request_body);
    var response = await dio.post(Const().api_host + "/app/mshop/add-product",
        data: formData, options: Options(headers: {'token': token}));
    return response.data;
  }

  updatePrd(
      List file, name, description, price, idavt, category_id, del, id) async {
    Dio dio = new Dio();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['id'] = id;
    request_body['setava'] = "$idavt";
    request_body['delava'] = del;
    request_body['name'] = name;
    request_body['description'] = description;
    request_body['price'] = price;
    request_body['category_id'] = category_id;
    for (var i = 0; i < file.length; i++) {
      request_body["image$i"] = await MultipartFile.fromFile(file[i].path,
          filename: file[i].path.split('/').last);
    }
    FormData formData = new FormData.fromMap(request_body);

    var response = await dio.post(
        Const().api_host + "/app/mshop/update-product",
        data: formData,
        options: Options(headers: {'token': token}));
    return response.data;
  }

  upLoadAvatar(List file, List dels) async {
    Dio dio = new Dio();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['dels'] = dels;
    for (var i = 0; i < file.length; i++) {
      request_body["image$i"] = await MultipartFile.fromFile(file[i].path,
          filename: file[i].path.split('/').last);
    }

    FormData formData = new FormData.fromMap(request_body);
    var response = await dio.post(
        Const().api_host + "/app/mshop/save-images-shop",
        data: formData,
        options: Options(headers: {'token': token}));

    return response.data;
  }

  shopAuth(List file, List dels, cmt, number_auth, number_paper_auth, date_auth,
      address_auth) async {
    Dio dio = new Dio();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    if (dels != null) {
      request_body['dels'] = dels;
    }
    if (cmt != null) {
      request_body['cmt'] = cmt;
    }
    if (number_auth != null) {
      request_body['number_auth'] = number_auth;
    }
    if (number_paper_auth != null) {
      request_body['number_paper_auth'] = number_paper_auth;
    }
    if (date_auth != null) {
      request_body['date_auth'] = date_auth;
    }
    if (address_auth != null) {
      request_body['address_auth'] = address_auth;
    }
    if (file != null) {
      for (var i = 0; i < file.length; i++) {
        request_body["image$i"] = await MultipartFile.fromFile(file[i].path,
            filename: file[i].path.split('/').last);
      }
    }

    FormData formData = new FormData.fromMap(request_body);

    var response = await dio.post(
        Const().api_host + "/app/mshop/update-shop-auth",
        data: formData,
        options: Options(headers: {'token': token}));
    return response.data;
  }

  getPrdShop(int status_quantity, String s, bool isSearch, int page) async {
    if (isSearch) {
      prd = [];
      page = 1;
    }
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['status_quantity'] = status_quantity;
    request_body['s'] = s;
    request_body['page'] = page;
    request_body['limit'] = 12;

    var response = await Const.web_api
        .postAsync("/app/mshop/get-products", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['products']) {
          int price = int.parse(double.parse(
                  item['price'] != null ? item['price'].toString() : "0")
              .round()
              .toString());
          int price_market = int.parse(double.parse(item['price_market'] != null
                  ? item['price_market'].toString()
                  : "0")
              .round()
              .toString());
          var productItem = new ProductItem(
            id: item['id'].toString(),
            name: item['name'].toString(),
            avatar_path: item['avatar_path'].toString(),
            avatar_name: item['avatar_name'].toString(),
            price: price,
            price_market: price_market,
            fee_ship: item['fee_ship'].toString(),
            rate_count: item['rate_count'].toString(),
            rate: item['rate'] == null ? 0 : double.parse(item['rate']),
            in_wish: item['in_wish'] != null ? item['in_wish'] : false,
            des: item['description'].toString(),
            category_id: item['category_id'].toString(),
            check: false,
          );
          prd.add(productItem);
        }
      }
    }
    Shop1.sink.add(prd);
    return prd;
  }

  getImageShop() async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    List imgs = [];
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    var response =
        await Const.web_api.postAsync("/app/mshop/images", token, request_body);


    if (response != null) {
      if (response["code"] == 1) {
        for (var item in response["data"]) {
          var img = ImageItem(
              name: item["name"].toString(),
              id: item["id"].toString(),
              path: item["path"].toString());
          imgs.add(img);
        }
      }
    }

    return imgs;
  }

  getImagePrd(id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    List imgs = [];
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['product_id'] = id;
    var response = await Const.web_api
        .postAsync("/app/mshop/get-product-images", token, request_body);
    if (response != null) {
      if (response["code"] == 1) {
        for (var item in response["data"]) {
          var img = ImageItem(
              name: item["name"].toString(),
              id: item["id"].toString(),
              path: item["path"].toString());
          imgs.add(img);
        }
      }
    }

    return imgs;
  }

  updateShop(
    scale,
    email,
    website,
    facebook,
    zalo,
    description,
  {
    File certificate,
  }
  ) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Dio dio = new Dio();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    if (scale != null) {
      request_body['scale'] = scale;
    }
    if (email != null) {
      request_body['email'] = email;
    }
    if (website != null) {
      request_body['website'] = website;
    }
    if (facebook != null) {
      request_body['facebook'] = facebook;
    }
    if (description != null) {
      request_body['description'] = description;
    }
    if (zalo != null) {
      request_body['zalo'] = zalo;
    }
    if (certificate != null) {
      request_body["certificate"] = await MultipartFile.fromFile(certificate.path,
          filename: certificate.path.split('/').last);
    }

    FormData formData = new FormData.fromMap(request_body);

    var response = await dio.post(Const().api_host + "/app/mshop/update",
        data: formData, options: Options(headers: {'token': token}));
    print(response.data);
    if (response.data != null) {
      return response;
    }
  }

  ordershop(order, page) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['status'] = "$order";
    request_body['limit'] = "10";
    request_body['page'] = "$page";
    var res =
        await Const.web_api.postAsync('/app/mshop/order', token, request_body);
    if (res != null) {
      if (res['code'] == 1) {
        for (var item in res['orders']) {
          List<ProductsDonHang> orderprds = [];
          for (var itemprd in item["products"]) {
            ProductsDonHang productItem = new ProductsDonHang(
              id: itemprd['product_id'].toString(),
              name: itemprd['name'].toString(),
              price: itemprd['price'].toString(),
              quantity: itemprd['quantity'].toString(),
              avatar_path: itemprd['avatar_path'].toString(),
              avatar_name: itemprd['avatar_name'].toString(),
              alias: itemprd['alias'].toString(),
            );
            orderprds.add(productItem);
          }
          OrderItem orderItem = new OrderItem(
            id: int.parse(item['id']),
            key: item['key'].toString(),
            shop_id: item['shop_id'].toString(),
            user_id: item['user_id'].toString(),
            order_total: item['order_total'].toString(),
            s_avatar_path: item['s_avatar_path'].toString(),
            s_avatar_name: item['s_avatar_name'].toString(),
            s_name: 'OR' + item['id'].toString(),
            name: item['name'].toString(),
            email: item['email'].toString(),
            phone: item['phone'].toString(),
            address: item['address'].toString(),
            district_id: item['district_id'].toString(),
            province_id: item['province_id'].toString(),
            status: item['status'].toString(),
            payment_status: item['payment_status'].toString(),
            payment_method: item['payment_method'].toString(),
            order_total_all: item['order_total_all'].toString(),
            unit: item['unit'].toString(),
            per_unit: item['per_unit'].toString(),
            order_label: item['id'].toString(),
            created_at: item['created_at'].toString(),
            products: orderprds,
          );
          orderprd.add(orderItem);
        }
      }
    }
    orderShop.sink.add(orderprd);
    return orderprd;
  }

  coupon(page, limit, s, isSearch, xoa) async {
    if (isSearch) {
      page = 1;
      coupons = [];
    } else if (xoa) {
      page = 1;
      coupons = [];
    }
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['page'] = "$page";
    req['limit'] = "$limit";
    req['s'] = s;
    var res = await Const.web_api.postAsync("/app/mshop/coupon", token, req);


    if (res != null) {
      if (res['code'] == 1) {
        for (var item in res['data']) {
          int time_start = int.parse(item['time_start']) * 1000;
          String start = DateFormat('dd/MM/yyyy HH: mm ', 'en_US')
              .format(DateTime.fromMillisecondsSinceEpoch(time_start));
          int time_end = int.parse(item['time_end']) * 1000;
          String end = DateFormat('dd/MM/yyyy HH: mm ', 'en_US')
              .format(DateTime.fromMillisecondsSinceEpoch(time_end));

          Coupon coupon = new Coupon(
            id: item['id'].toString(),
            shop_id: item['shop_id'].toString(),
            time_start: start,
            time_end: end,
            type_discount: item['type_discount'].toString(),
            value: item['value'].toString(),
            count: item['count'].toString(),
            user_use: item['user_use'].toString(),
            status: item['status'].toString(),
            discount_shop_code_id: item['discount_shop_code_id'].toString(),
            all: item['all'].toString(),
            products: item['products'].toString(),
            order_id: item['order_id'].toString(),
            count_limit: item['count_limit'].toString(),
          );
          coupons.add(coupon);
        }
      }
    }
    couponShop.sink.add(coupons);
    return coupons;
  }

  deleteCoupon(id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['id'] = "$id";
    var res =
        await Const.web_api.postAsync("/app/mshop/delete-coupon", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }

  createCoupon(name, quantity, type_discount, value, count_limit, time_start,
      time_end, all, List add) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['name'] = "$name";
    req['quantity'] = "$quantity";
    req['type_discount'] = "$type_discount";
    req['value'] = "$value";
    req['count_limit'] = "$count_limit";
    req['time_start'] = "$time_start";
    req['time_end'] = "$time_end";
    req['all'] = "$all";
    req['add'] = add;
    var res =
        await Const.web_api.postAsync("/app/mshop/create-coupon", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }

  deletePrd(id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['product_id'] = "$id";
    var res =
        await Const.web_api.postAsync("/app/mshop/delete-product", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }

  getShop() async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    var res = await Const.web_api.postAsync("/app/mshop", token, request_body);
    if(res != null){
     if(res['code'] == 1){
       return true;
     }
    }
    return false;
  }

  getShopAuth() async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    Map<String, dynamic> data = new Map<String, dynamic>();
    List images = [];
    request_body['user_id'] = user_id;
    var res = await Const.web_api
        .postAsync("/app/mshop/shop-auth", token, request_body);
    if (res != null) {
      if (res['code'] == 1) {
        for (var item in res['data']['images']) {
          var img = ImageItem(
              name: item["name"].toString(),
              id: item["id"].toString(),
              path: item["path"].toString());
          images.add(img);
        }
        data['data'] = res['data'];
        data['images'] = images;
        return data;
      }
    }
  }

  getAddress(page) async {
    addressS = [];
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['page'] = page;
    request_body['limit'] = 12;
    var res = await Const.web_api
        .postAsync("/app/mshop/address", token, request_body);
    if (res != null) {
      if (res['code'] == 1) {
        for (var item in res['data']) {
          var value = new AddressItem(
            id: item['id'].toString(),
            name_contact: item['name_contact'].toString(),
            phone: item['phone'].toString(),
            province_id: item['province_id'].toString(),
            district_id: item['district_id'].toString(),
            province_name: item['province_name'].toString(),
            district_name: item['district_name'].toString(),
            ward_name: item['ward_name'].toString(),
            ward_id: item['ward_id'].toString(),
            address: item['address'].toString(),
            isdefault: item['isdefault'].toString(),
          );
          addressS.add(value);
        }
      }
    }
    address.sink.add(addressS);
    return addressS;
  }

  postAddres(address_id,name, phone, tinh, quan, phuong, address, isdefault) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    if(address_id != null){
      request_body['address_id'] = address_id;
    }
    request_body['name_contact'] = name;
    request_body['phone'] = phone;
    request_body['province_id'] = tinh;
    request_body['district_id'] = quan;
    request_body['ward_id'] = phuong;
    request_body['address'] = address;
    request_body['isdefault'] = isdefault;
    // request_body = {
    //   "user_id": 523,
    //   "name_contact": "manh",
    //   "phone": 123123,
    //   "province_id": 59,
    //   "district_id": 662,
    //   "ward_id": 10763,
    //   "address": 12312312,
    //   "isdefault": 0
    // };


    var response = await Const.web_api
        .postAsync("/app/mshop/shop-address", token, request_body);

    if (response != null) {
      if (response["code"] == 1) {
        return true;
      }
    }
    return false;
  }

  deleteAddress(id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['address_id'] = "$id";
    var res = await Const.web_api.postAsync("/app/mshop/delete-address", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }

  DetailAffiliate(url)async{
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    var res = await Const.web_api.postAsync(url, token, req);
    if (res != null) {
      if (res['code'] == 1) {
        affiliate.sink.add(res);
      }
    }
    return res;
  }

  cancelAffiliate() async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    var res = await Const.web_api.postAsync("/app/mshop/cancer-change", token, req);

    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }
  updateAffiliate(status_affiliate_waitting,affiliate_admin_waitting,affiliate_gt_shop_waitting,product_ids ) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['status_affiliate_waitting'] = "$status_affiliate_waitting";
    req['affiliate_admin_waitting'] = "$affiliate_admin_waitting";
    req['affiliate_gt_shop_waitting'] = "$affiliate_gt_shop_waitting";
    req['product_ids'] = product_ids;
    var res = await Const.web_api.postAsync("/app/mshop/update-affiliate", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }
  updatePrdAffiliate(product_id,affiliate_gt_product,affiliate_m_v,affiliate_charity,affiliate_safe,delete) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['product_id'] = "$product_id";
    req['affiliate_gt_product'] = "$affiliate_gt_product";
    req['affiliate_m_v'] = "$affiliate_m_v";
    req['affiliate_charity'] = "$affiliate_charity";
    req['affiliate_safe'] = "$affiliate_safe";
    req['delete'] = "$delete";

    var res = await Const.web_api.postAsync("/app/mshop/update-product-affiliate", token, req);

    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }

  updateAffiliateQR(status,product_ids ) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['status'] = "$status";
    req['product_ids'] = product_ids;
    var res = await Const.web_api.postAsync("/app/mshop/save-service", token, req);

    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }

  updateOrderShop(order_id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['order_id'] = "$order_id";
    var res = await Const.web_api.postAsync("/app/mshop/update-order", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }
  cancelOrderShop(order_id) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map<String, dynamic>();
    req['user_id'] = "$user_id";
    req['order_id'] = "$order_id";
    var res = await Const.web_api.postAsync("/app/mshop/cancer-order", token, req);
    if (res != null) {
      if (res['code'] == 1) {
        return true;
      }
    }
    return false;
  }

  searchShop(key, page,search)async{
    if(search){
      searchshops = [];
    }
    var token = await Const.web_api.getToken();
    Map req = new Map();
    req['keyword'] = key;
    req['limit'] = 12;
    req['page'] = page;

    var res = await Const.web_api.postAsync("/app/product/get-shops", token, req);

    if(res != null){
      if(res['code'] == 1){
        for(var item in res['data']){
          Shop shop = new Shop(
            id: item["id"].toString(),
            name: item["name"].toString(),
            address: item["address"].toString(),
            avatar_name: item["avatar_name"].toString(),
            avatar_path: item["avatar_path"].toString(),
            rate: item["rate"] != null?item["rate"].toString():"0",
            rate_count: item["rate_count"]!= null ? item["rate_count"].toString():"0",
            phoneUser: item["phone"].toString()
          );
          searchshops.add(shop);
        }
      }
    }
    searchshop.sink.add(searchshops);
    return searchshops;
  }
  dispose() {
    _ProductListFetcher.close();
    couponShop.close();
    address.close();
    orderShop.close();
    affiliate.close();
    products = [];
  }
}
