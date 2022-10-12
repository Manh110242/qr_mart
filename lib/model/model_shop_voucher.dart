/// id : 7776
/// name : "CEN "
/// alias : "cen"
/// type : "1"
/// user_id : 7776
/// address : "32 Đỗ Đức Dục"
/// province_id : "54"
/// province_name : "Trà Vinh"
/// district_id : "606"
/// district_name : "Cầu Ngang"
/// ward_id : "10085"
/// ward_name : "Mỹ Long Bắc"
/// image_path : "/media/images/shop/2019_01_02/"
/// image_name : "df-1546395774.png"
/// avatar_path : "/media/images/shop/2019_01_02/"
/// avatar_name : "df-1546395774.png"
/// phone : "0877564144"
/// hotline : ""
/// email : "vietkk@gmail.com"
/// yahoo : ""
/// skype : ""
/// website : ""
/// vdiarybook : ""
/// facebook : ""
/// instagram : ""
/// pinterest : ""
/// twitter : ""
/// field_business : ""
/// status : 1
/// created_time : 1649407036
/// modified_time : 1652070614
/// site_id : 0
/// allow_number_cat : 3
/// short_description : ""
/// description : ""
/// meta_keywords : ""
/// meta_description : ""
/// meta_title : ""
/// avatar_id : 0
/// time_open : 0
/// time_close : 0
/// day_open : 2
/// day_close : 8
/// type_sell : 1
/// like : 1
/// policy : ""
/// contact : ""
/// latlng : "9.82334,106.5"
/// payment_transfer : null
/// category_track : ""
/// level : ""
/// number_auth : ""
/// date_auth : "10/2/2010"
/// address_auth : "Hà Nội"
/// number_paper_auth : "34474867"
/// name_contact : "Admin"
/// rate : null
/// rate_count : null
/// scale : "Nhỏ"
/// transport : null
/// cmt : "036200002640"
/// lat : "9.82334"
/// lng : "106.5"
/// phone_add : null
/// viewed : 125
/// status_affiliate : 1
/// shop_acount_type : 1
/// account_status : 2
/// affiliate_admin : "2"
/// affiliate_gt_shop : "2"
/// status_affiliate_waitting : 1
/// affiliate_admin_waitting : "2"
/// affiliate_gt_shop_waitting : "2"
/// affiliate_waitting : 0
/// time_limit_type : 1
/// time_limit : 1680943036
/// iframe : null
/// zalo : null
/// status_discount_code : 1
/// affilliate_status_service_waitting : 0
/// affilliate_status_service : 0

class ModelShopVoucher {
  ModelShopVoucher({
      this.id, 
      this.name, 
      this.alias, 
      this.type, 
      this.userId, 
      this.address, 
      this.provinceId, 
      this.provinceName, 
      this.districtId, 
      this.districtName, 
      this.wardId, 
      this.wardName, 
      this.imagePath, 
      this.imageName, 
      this.avatarPath, 
      this.avatarName, 
      this.phone, 
      this.hotline, 
      this.email, 
      this.yahoo, 
      this.skype, 
      this.website, 
      this.vdiarybook, 
      this.facebook, 
      this.instagram, 
      this.pinterest, 
      this.twitter, 
      this.fieldBusiness, 
      this.status, 
      this.createdTime, 
      this.modifiedTime, 
      this.siteId, 
      this.allowNumberCat, 
      this.shortDescription, 
      this.description, 
      this.metaKeywords, 
      this.metaDescription, 
      this.metaTitle, 
      this.avatarId, 
      this.timeOpen, 
      this.timeClose, 
      this.dayOpen, 
      this.dayClose, 
      this.typeSell, 
      this.like, 
      this.policy, 
      this.contact, 
      this.latlng, 
      this.paymentTransfer, 
      this.categoryTrack, 
      this.level, 
      this.numberAuth, 
      this.dateAuth, 
      this.addressAuth, 
      this.numberPaperAuth, 
      this.nameContact, 
      this.rate, 
      this.rateCount, 
      this.scale, 
      this.transport, 
      this.cmt, 
      this.lat, 
      this.lng, 
      this.phoneAdd, 
      this.viewed, 
      this.statusAffiliate, 
      this.shopAcountType, 
      this.accountStatus, 
      this.affiliateAdmin, 
      this.affiliateGtShop, 
      this.statusAffiliateWaitting, 
      this.affiliateAdminWaitting, 
      this.affiliateGtShopWaitting, 
      this.affiliateWaitting, 
      this.timeLimitType, 
      this.timeLimit, 
      this.iframe, 
      this.zalo, 
      this.statusDiscountCode, 
      this.affilliateStatusServiceWaitting, 
      this.affilliateStatusService,});

  ModelShopVoucher.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    type = json['type'];
    userId = json['user_id'];
    address = json['address'];
    provinceId = json['province_id'];
    provinceName = json['province_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    wardId = json['ward_id'];
    wardName = json['ward_name'];
    imagePath = json['image_path'];
    imageName = json['image_name'];
    avatarPath = json['avatar_path'];
    avatarName = json['avatar_name'];
    phone = json['phone'];
    hotline = json['hotline'];
    email = json['email'];
    yahoo = json['yahoo'];
    skype = json['skype'];
    website = json['website'];
    vdiarybook = json['vdiarybook'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    pinterest = json['pinterest'];
    twitter = json['twitter'];
    fieldBusiness = json['field_business'];
    status = json['status'];
    createdTime = json['created_time'];
    modifiedTime = json['modified_time'];
    siteId = json['site_id'];
    allowNumberCat = json['allow_number_cat'];
    shortDescription = json['short_description'];
    description = json['description'];
    metaKeywords = json['meta_keywords'];
    metaDescription = json['meta_description'];
    metaTitle = json['meta_title'];
    avatarId = json['avatar_id'];
    timeOpen = json['time_open'];
    timeClose = json['time_close'];
    dayOpen = json['day_open'];
    dayClose = json['day_close'];
    typeSell = json['type_sell'];
    like = json['like'];
    policy = json['policy'];
    contact = json['contact'];
    latlng = json['latlng'];
    paymentTransfer = json['payment_transfer'];
    categoryTrack = json['category_track'];
    level = json['level'];
    numberAuth = json['number_auth'];
    dateAuth = json['date_auth'];
    addressAuth = json['address_auth'];
    numberPaperAuth = json['number_paper_auth'];
    nameContact = json['name_contact'];
    rate = json['rate'];
    rateCount = json['rate_count'];
    scale = json['scale'];
    transport = json['transport'];
    cmt = json['cmt'];
    lat = json['lat'];
    lng = json['lng'];
    phoneAdd = json['phone_add'];
    viewed = json['viewed'];
    statusAffiliate = json['status_affiliate'];
    shopAcountType = json['shop_acount_type'];
    accountStatus = json['account_status'];
    affiliateAdmin = json['affiliate_admin'];
    affiliateGtShop = json['affiliate_gt_shop'];
    statusAffiliateWaitting = json['status_affiliate_waitting'];
    affiliateAdminWaitting = json['affiliate_admin_waitting'];
    affiliateGtShopWaitting = json['affiliate_gt_shop_waitting'];
    affiliateWaitting = json['affiliate_waitting'];
    timeLimitType = json['time_limit_type'];
    timeLimit = json['time_limit'];
    iframe = json['iframe'];
    zalo = json['zalo'];
    statusDiscountCode = json['status_discount_code'];
    affilliateStatusServiceWaitting = json['affilliate_status_service_waitting'];
    affilliateStatusService = json['affilliate_status_service'];
  }
  int id;
  String name;
  String alias;
  String type;
  int userId;
  String address;
  String provinceId;
  String provinceName;
  String districtId;
  String districtName;
  String wardId;
  String wardName;
  String imagePath;
  String imageName;
  String avatarPath;
  String avatarName;
  String phone;
  String hotline;
  String email;
  String yahoo;
  String skype;
  String website;
  String vdiarybook;
  String facebook;
  String instagram;
  String pinterest;
  String twitter;
  String fieldBusiness;
  int status;
  int createdTime;
  int modifiedTime;
  int siteId;
  int allowNumberCat;
  String shortDescription;
  String description;
  String metaKeywords;
  String metaDescription;
  String metaTitle;
  int avatarId;
  int timeOpen;
  int timeClose;
  int dayOpen;
  int dayClose;
  int typeSell;
  int like;
  String policy;
  String contact;
  String latlng;
  dynamic paymentTransfer;
  String categoryTrack;
  String level;
  String numberAuth;
  String dateAuth;
  String addressAuth;
  String numberPaperAuth;
  String nameContact;
  dynamic rate;
  dynamic rateCount;
  String scale;
  dynamic transport;
  String cmt;
  String lat;
  String lng;
  dynamic phoneAdd;
  int viewed;
  int statusAffiliate;
  int shopAcountType;
  int accountStatus;
  String affiliateAdmin;
  String affiliateGtShop;
  int statusAffiliateWaitting;
  String affiliateAdminWaitting;
  String affiliateGtShopWaitting;
  int affiliateWaitting;
  int timeLimitType;
  int timeLimit;
  dynamic iframe;
  dynamic zalo;
  int statusDiscountCode;
  int affilliateStatusServiceWaitting;
  int affilliateStatusService;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['alias'] = alias;
    map['type'] = type;
    map['user_id'] = userId;
    map['address'] = address;
    map['province_id'] = provinceId;
    map['province_name'] = provinceName;
    map['district_id'] = districtId;
    map['district_name'] = districtName;
    map['ward_id'] = wardId;
    map['ward_name'] = wardName;
    map['image_path'] = imagePath;
    map['image_name'] = imageName;
    map['avatar_path'] = avatarPath;
    map['avatar_name'] = avatarName;
    map['phone'] = phone;
    map['hotline'] = hotline;
    map['email'] = email;
    map['yahoo'] = yahoo;
    map['skype'] = skype;
    map['website'] = website;
    map['vdiarybook'] = vdiarybook;
    map['facebook'] = facebook;
    map['instagram'] = instagram;
    map['pinterest'] = pinterest;
    map['twitter'] = twitter;
    map['field_business'] = fieldBusiness;
    map['status'] = status;
    map['created_time'] = createdTime;
    map['modified_time'] = modifiedTime;
    map['site_id'] = siteId;
    map['allow_number_cat'] = allowNumberCat;
    map['short_description'] = shortDescription;
    map['description'] = description;
    map['meta_keywords'] = metaKeywords;
    map['meta_description'] = metaDescription;
    map['meta_title'] = metaTitle;
    map['avatar_id'] = avatarId;
    map['time_open'] = timeOpen;
    map['time_close'] = timeClose;
    map['day_open'] = dayOpen;
    map['day_close'] = dayClose;
    map['type_sell'] = typeSell;
    map['like'] = like;
    map['policy'] = policy;
    map['contact'] = contact;
    map['latlng'] = latlng;
    map['payment_transfer'] = paymentTransfer;
    map['category_track'] = categoryTrack;
    map['level'] = level;
    map['number_auth'] = numberAuth;
    map['date_auth'] = dateAuth;
    map['address_auth'] = addressAuth;
    map['number_paper_auth'] = numberPaperAuth;
    map['name_contact'] = nameContact;
    map['rate'] = rate;
    map['rate_count'] = rateCount;
    map['scale'] = scale;
    map['transport'] = transport;
    map['cmt'] = cmt;
    map['lat'] = lat;
    map['lng'] = lng;
    map['phone_add'] = phoneAdd;
    map['viewed'] = viewed;
    map['status_affiliate'] = statusAffiliate;
    map['shop_acount_type'] = shopAcountType;
    map['account_status'] = accountStatus;
    map['affiliate_admin'] = affiliateAdmin;
    map['affiliate_gt_shop'] = affiliateGtShop;
    map['status_affiliate_waitting'] = statusAffiliateWaitting;
    map['affiliate_admin_waitting'] = affiliateAdminWaitting;
    map['affiliate_gt_shop_waitting'] = affiliateGtShopWaitting;
    map['affiliate_waitting'] = affiliateWaitting;
    map['time_limit_type'] = timeLimitType;
    map['time_limit'] = timeLimit;
    map['iframe'] = iframe;
    map['zalo'] = zalo;
    map['status_discount_code'] = statusDiscountCode;
    map['affilliate_status_service_waitting'] = affilliateStatusServiceWaitting;
    map['affilliate_status_service'] = affilliateStatusService;
    return map;
  }

}