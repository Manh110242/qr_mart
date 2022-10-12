class ModelCategoryNew {
  String id;
  String name;
  String alias;
  String parent;
  String level;
  String track;
  String createdAt;
  String updatedAt;
  String metaKeywords;
  String metaDescription;
  String metaTitle;
  String status;
  String description;
  String viewLayout;
  String avatarPath;
  String avatarName;
  String showInHome;
  String order;
  String showHomeRight;
  String icon;
  String link;
  bool active;
  dynamic children;

  ModelCategoryNew(
      {this.id,
      this.name,
      this.alias,
      this.parent,
      this.level,
      this.track,
      this.createdAt,
      this.updatedAt,
      this.metaKeywords,
      this.metaDescription,
      this.metaTitle,
      this.status,
      this.description,
      this.viewLayout,
      this.avatarPath,
      this.avatarName,
      this.showInHome,
      this.order,
      this.showHomeRight,
      this.icon,
      this.link,
      this.active,
      this.children});

  ModelCategoryNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    parent = json['parent'];
    level = json['level'];
    track = json['track'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    metaKeywords = json['meta_keywords'];
    metaDescription = json['meta_description'];
    metaTitle = json['meta_title'];
    status = json['status'];
    description = json['description'];
    viewLayout = json['view_layout'];
    avatarPath = json['avatar_path'];
    avatarName = json['avatar_name'];
    showInHome = json['show_in_home'];
    order = json['order'];
    showHomeRight = json['show_home_right'];
    icon = json['icon'];
    link = json['link'];
    active = json['active'];
    children = json['children'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['alias'] = this.alias;
    data['parent'] = this.parent;
    data['level'] = this.level;
    data['track'] = this.track;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['meta_keywords'] = this.metaKeywords;
    data['meta_description'] = this.metaDescription;
    data['meta_title'] = this.metaTitle;
    data['status'] = this.status;
    data['description'] = this.description;
    data['view_layout'] = this.viewLayout;
    data['avatar_path'] = this.avatarPath;
    data['avatar_name'] = this.avatarName;
    data['show_in_home'] = this.showInHome;
    data['order'] = this.order;
    data['show_home_right'] = this.showHomeRight;
    data['icon'] = this.icon;
    data['link'] = this.link;
    data['active'] = this.active;
    data['children'] = this.children;
    return data;
  }
}
