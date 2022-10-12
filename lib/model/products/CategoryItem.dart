import 'package:gcaeco_app/model/products/productItem.dart';

class CategoryItem {
  final int id;
  final String name;
  final int status;
  final String icon_path;
  final String icon_name;
  final String avatar_path;
  final String avatar_name;
  final String bgr_path;
  final String bgr_name;
  List<ProductItem> products;

  CategoryItem({
    this.id,
    this.name,
    this.status,
    this.icon_path,
    this.icon_name,
    this.avatar_path,
    this.avatar_name,
    this.bgr_path,
    this.bgr_name,
    this.products,
  });

}