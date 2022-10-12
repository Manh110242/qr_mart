import 'package:gcaeco_app/model/cartItem.dart';

class ShopItem {
  final String shop_id;
  final String shop_name;
  final String avatar;
  final List<CartItem> products;

  ShopItem({
    this.shop_id,
    this.shop_name,
    this.avatar,
    this.products,
  });
}