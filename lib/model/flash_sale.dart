class ModelFlashSale {
  String id;
  String name;
  String sortdesc;
  String description;
  String status;
  String startdate;
  String enddate;
  String alias;
  String showinhome;
  String meta_title;
  String meta_keywords;
  String meta_description;
  String created_time;
  String image_path;
  String image_name;
  String ishot;
  String category_id;
  String order;
  String time_space;
  List products;

  ModelFlashSale({
    this.id,
    this.description,
    this.name,
    this.category_id,
    this.status,
    this.alias,
    this.created_time,
    this.enddate,
    this.image_name,
    this.image_path,
    this.ishot,
    this.meta_description,
    this.meta_keywords,
    this.meta_title,
    this.order,
    this.showinhome,
    this.sortdesc,
    this.startdate,
    this.time_space,
    this.products,
  });
}