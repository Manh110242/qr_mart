class ModelSite {
  ModelSite({
      this.id, 
      this.title, 
      this.logo, 
      this.favicon, 
      this.footerLogo, 
      this.avatar, 
      this.email, 
      this.phone, 
      this.hotline, 
      this.address, 
      this.metaKeywords, 
      this.metaDescription, 
      this.createdAt, 
      this.updatedAt, 
      this.goldPrice, 
      this.iframe, 
      this.liveChat, 
      this.company, 
      this.numberAuth, 
      this.emailRif, 
      this.otp, 
      this.copyright, 
      this.questionPrice, 
      this.bankAdmin, 
      this.feePercent, 
      this.feeGiftRegister, 
      this.questionCountFree,});

  ModelSite.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    logo = json['logo'];
    favicon = json['favicon'];
    footerLogo = json['footer_logo'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    hotline = json['hotline'];
    address = json['address'];
    metaKeywords = json['meta_keywords'];
    metaDescription = json['meta_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    goldPrice = json['gold_price'];
    iframe = json['iframe'];
    liveChat = json['live_chat'];
    company = json['company'];
    numberAuth = json['number_auth'];
    emailRif = json['email_rif'];
    otp = json['otp'];
    copyright = json['copyright'];
    questionPrice = json['question_price'];
    bankAdmin = json['bank_admin'];
    feePercent = json['fee_percent'];
    feeGiftRegister = json['fee_gift_register'];
    questionCountFree = json['question_count_free'];
  }
  int id;
  String title;
  String logo;
  String favicon;
  String footerLogo;
  String avatar;
  String email;
  String phone;
  String hotline;
  String address;
  String metaKeywords;
  String metaDescription;
  int  createdAt;
  int  updatedAt;
  dynamic goldPrice;
  String  iframe;
  dynamic liveChat;
  String  company;
  String  numberAuth;
  String  emailRif;
  int  otp;
  String  copyright;
  String  questionPrice;
  String  bankAdmin;
  int  feePercent;
  String  feeGiftRegister;
  int  questionCountFree;



}