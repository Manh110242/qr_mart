import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:gcaeco_app/bloc/bloc_home_new.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/Product_API.dart';
import 'package:gcaeco_app/model/categories_and_its_products.dart';
import 'package:gcaeco_app/model/category.dart';
import 'package:gcaeco_app/model/detail_product.dart';
import 'package:gcaeco_app/model/main_banner_in_home.dart';
import 'package:gcaeco_app/model/model_image_product.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/model/search_trend.dart';
import 'package:gcaeco_app/model/shop.dart';
import 'package:gcaeco_app/model/user.dart';
import 'package:http/http.dart' as http;

Map<String, String> headers = {"token": Const().key};
Token tokenCreated;

// ignore: camel_case_types
class Fetch_Data {
  String api;
  var params;

  Fetch_Data(this.api, this.params);

  DateTime now = new DateTime.now();

  Future<Token> getToken() async {
    var param = now.toString();
    var token = sha1.convert(utf8.encode(param + Const().key));
    Map<String, String> headers = {"token": token.toString()};
    var data =
        await http.get(Const().api_host + this.api + "?string=" + param, headers: headers);
    var jsonData = json.decode(data.body);
    tokenCreated = new Token(jsonData["data"]["token"]);
    return tokenCreated;
  }

  Future<List<Category>> getCategories() async {
    var token = await Const.web_api.getToken();
    Map<String, String> headers = {"token": token};
    var data = await http.get(Const().api_host + this.api, headers: headers);
    var jsonData = json.decode(data.body);
    List<Category> categories = [];
    // for (var i in jsonData['data']) {
    //   Category category = new Category(i['name'].toString(), i['id'].toString(),
    //       i['avatar_name'].toString(), i['avatar_path'].toString());
    //   categories.add(category);
    // }
    return categories;
  }

  Future<List<ProductItem>> getProducts(String page, String limit, String isnew,
      String categoryID, String shopId, String ishot) async {
    var token = await Const.web_api.getToken();
    Map<String, String> headers = {"token": token};
    if (isnew == 'null' && shopId == "null" && ishot == "null") {
      this.params = '{' +
          '"limit":' +
          limit +
          ',"page":' +
          page +
          ',"category_id":' +
          categoryID +
          '}';
    } else if (shopId != "null" &&
        isnew == "null" &&
        categoryID == "null" &&
        ishot == "null") {
      this.params = '{' +
          '"shop_id":' +
          shopId +
          ',"limit":' +
          limit +
          ',"page":' +
          page +
          '}';
    } else if (shopId == "null" &&
        isnew == "null" &&
        categoryID == "null" &&
        ishot != "null") {
      this.params = '{' +
          '"ishot":' +
          ishot +
          ',"limit":' +
          limit +
          ',"page":' +
          page +
          '}';
    } else {
      this.params = '{' +
          '"limit":' +
          limit +
          ',"page":' +
          page +
          ',"isnew":' +
          isnew +
          ',"category_id":' +
          categoryID +
          '}';
    }
    var data =
        await http.post(Const().api_host + this.api, headers: headers, body: this.params);
    var jsonData = json.decode(data.body);
    List<ProductItem> products = [];
    for (var i in jsonData['data']) {
      var productItem = new ProductItem(
        id: i['id'].toString(),
        name: i['name'].toString(),
        avatar_path: i['avatar_path'].toString(),
        avatar_name: i['avatar_name'].toString(),
        price: i['price'],
        price_market: i['price_market'],
        fee_ship: i['fee_ship'].toString(),
        rate_count: i['rate_count'].toString(),
        rate: i['rate'] == null ? 0 : double.parse(i['rate']),
        in_wish: i['in_wish'],
        vip_active: i['vip_active'] != null
            ? i['vip_active'].toString()
            : "",
        logo_vip: BlocHomeNew.getImageVip(i['vip'].toString()) ,
      );
      products.add(productItem);
    }

    return products;
  }

  Future<List<Product_Api>> getProductNew() async {
    var token = await Const.web_api.getToken();
    Map<String, int> request_body = new Map<String, int>();
    request_body['isnew'] = 1;
    var response = await Const.web_api
        .postAsync("/app/product/get-products", token, request_body);
    List<Product_Api> products = [];
    for (var i in response['data']) {
      Product_Api newProduct = new Product_Api(
          i['id'].toString(),
          i['avatar_path'].toString(),
          i['avatar_name'].toString(),
          i['name'].toString(),
          i['price'].toString(),
          i['isnew'].toString(),
          i['ishot'].toString(),
          i['created_at'].toString(),
          i['updated_at'].toString(),
          i['rate'].toString(),
          i['unit'].toString());
      products.add(newProduct);
    }

    return products;
  }

  Future<List<CategoryAndItsProducts>> getCategoriesAndItsProducts() async {
    var token = await Const.web_api.getToken();
    Map<String, String> headers = {"token": token};
    var data =
        await http.post(Const().api_host + this.api, headers: headers, body: this.params);
    var jsonData = json.decode(data.body);
    List<CategoryAndItsProducts> categoriesAndItsProductsList = [];
    for (var i in jsonData['data']) {
      CategoryAndItsProducts categoryAndItsProducts =
          new CategoryAndItsProducts();
      categoryAndItsProducts.id = i['id'].toString();
      categoryAndItsProducts.name = i['name'].toString();

      for (var j in i['products']) {
        Product_Api productApi = new Product_Api(
            j['id'].toString(),
            j['avatar_path'].toString(),
            j['avatar_name'].toString(),
            j['name'].toString(),
            j['price'].toString(),
            j['isnew'].toString(),
            j['ishot'].toString(),
            j['created_at'].toString(),
            j['updated_at'].toString(),
            j['rate'].toString(),
            j['unit'].toString());
        categoryAndItsProducts.products.add(productApi);
      }

      categoriesAndItsProductsList.add(categoryAndItsProducts);
    }
    return categoriesAndItsProductsList;
  }

  Future<List<Main_Banner_In_Home>> getBannersInHome() async {
    var token = await Const.web_api.getToken();
    Map<String, String> headers = {"token": token};
    var data =
        await http.post(Const().api_host + this.api, headers: headers, body: this.params);
    var jsonData = json.decode(data.body);
    List<Main_Banner_In_Home> mainBannersInHome = [];
    for (var i in jsonData['data']) {
      Main_Banner_In_Home mainBannerInHome =
          new Main_Banner_In_Home(i['id'].toString(), i['src'].toString());
      mainBannersInHome.add(mainBannerInHome);
    }
    return mainBannersInHome;
  }

  Future<List<Search_Trend>> getSearchTrends() async {
    var token = await Const.web_api.getToken();
    Map<String, String> headers = {"token": token};
    var data =
        await http.post(Const().api_host + this.api, headers: headers, body: this.params);
    var jsonData = json.decode(data.body);
    List<Search_Trend> searchTrends = [];
    for (var i in jsonData['data']) {
      Search_Trend searchTrend = new Search_Trend(i['avatar_path'].toString(),
          i['avatar_name'].toString(), i['keyword'].toString());
      searchTrends.add(searchTrend);
    }
    return searchTrends;
  }

  Future<dynamic> getDetailProduct(String id) async {
    try{
      var res = new Map();
      var token = await Const.web_api.getToken();
      Map<String, String> headers = {"token": token};
      this.params = '{' + '"product_id":' + id + '}';
      var data =
      await http.post(Const().api_host + this.api, headers: headers, body: this.params);
      var jsonData = json.decode(data.body);
      var dP = jsonData['data'];
      var dS = jsonData['data']['shop'];
      String linkVideo = jsonData['data']['videos'].startsWith("https://www.youtube.com/") ?jsonData['data']['videos'] : null;
      List listImage = [];
      res['videos'] = linkVideo;
      Shop shop = new Shop(
        id: dS['id'].toString(),
        name: dS['name'].toString(),
        address: dS['address'].toString(),
        province_name: dS['province_name'].toString(),
        district_name: dS['district_name'].toString(),
        ward_name: dS['ward_name'].toString(),
        avatar_path: dS['avatar_path'].toString(),
        avatar_name: dS['avatar_name'].toString(),
        phone: dS['phone'].toString(),
        email: dS['email'].toString(),
        website: dS['website'].toString(),
        created_time: dS['created_time'].toString(),
        name_contact: dS['name_contact'].toString(),
        rate: dS['rate'].toString(),
        rate_count:dS['rate_count'] == null ? "0" : dS['rate_count'].toString(),
      );
      res['shop'] = shop;
      DetailProduct detailProduct = new DetailProduct(
        dP["id"].toString(),
        dP["name"].toString(),
        dP["category_id"].toString(),
        dP["price"].toString(),
        dP["price_market"].toString(),
        dP["avatar_path"].toString(),
        dP["avatar_name"].toString(),
        dP["short_description"].toString(),
        dP["description"].toString(),
        dP["shop_id"].toString(),
        dP["rate"].toString(),
        dP["flash_sale"].toString(),
        dP["unit"].toString(),
        dP["note_fee_ship"].toString(),
        dP["check_in_cart"].toString(),
        dP["created_at"].toString(),
        dP["status"].toString(),
        shop,
        dP["viewed"].toString(),
        dP["ishot"].toString(),
        dP["affiliate_gt_product"].toString(),
        dP["alias"].toString(),
      );
      res['prd'] = detailProduct;
      for (var item in jsonData['data']['images']) {
        ModleImageProduct image = ModleImageProduct(
          id: item['id'].toString(),
          name: item['name'].toString(),
          path: item['path'].toString(),
          display_name: item['display_name'].toString(),
        );
        listImage.add(image);
      }
      res['images'] = listImage;
      return res;
    }catch(e){
      print(e);
    }
  }

  Future<User> login(String email, String password) async {
    var token = await Const.web_api.getToken();
    Map<String, String> headers = {"token": token};
    this.params =
        '{"LoginForm":{"email":"' + email + '","password":"' + password + '"}}';
    var data =
        await http.post(Const().api_host + this.api, headers: headers, body: this.params);
    var jsonData = json.decode(data.body);
    var userData = jsonData['data'];
    if (jsonData['message'].toString() == "Đăng nhập thành công.") {
      User user = new User(
          id: userData['id'].toString(),
          username: userData['username'].toString(),
          auth_key: userData['auth_key'].toString(),
          password_hash: userData['password_hash'].toString(),
          phone: userData['phone'].toString(),
          email: userData['email'].toString(),
          status: userData['status'].toString(),
          created_at: userData['created_at'].toString(),
          updated_at: userData['updated_at'].toString(),
          address: userData['address'].toString(),
          facebook: userData['facebook'].toString(),
          link_facebook: userData['link_facebook'].toString(),
          is_notification: userData['is_notification'].toString(),
          sex: userData['sex'].toString(),
          birthday: userData['birthday'].toString(),
          avatar_path: userData['avatar_path'].toString(),
          avatar_name: userData['avatar_name'].toString(),
          token_app: userData['token_app'].toString());
      return user;
    }
    return null;
  }
}

class Token {
  final token;

  Token(this.token);
}
