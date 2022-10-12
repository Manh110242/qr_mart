import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/historys_don_hang.dart';
import 'package:gcaeco_app/model/info_don_hang.dart';

class User {
  AddressItem addressItem;
  String id,
      username,
      // ignore: non_constant_identifier_names
      auth_key,
      // ignore: non_constant_identifier_names
      password_hash,
      password_hash2,
      phone,
      email,
      status,
      // ignore: non_constant_identifier_names
      created_at,
      // ignore: non_constant_identifier_names
      updated_at,
      address,
      facebook,
      // ignore: non_constant_identifier_names
      link_facebook,
      // ignore: non_constant_identifier_names
      is_notification,
      sex,
      birthday,
      // ignore: non_constant_identifier_names
      avatar_path,
      // ignore: non_constant_identifier_names
      avatar_name,
      payment_method,
      user_before,
      user_gt_app,
      cmt,
      // ignore: non_constant_identifier_names
      token_app;
  final InfoDonHang info;

  User({
    this.id,
    this.username,
    this.user_before,
    this.auth_key,
    this.password_hash,
    this.password_hash2,
    this.phone,
    this.email,
    this.user_gt_app,
    this.status,
    this.created_at,
    this.updated_at,
    this.address,
    this.facebook,
    this.link_facebook,
    this.is_notification,
    this.sex,
    this.birthday,
    this.avatar_path,
    this.avatar_name,
    this.payment_method,
    this.token_app,
    this.info,
    this.addressItem,
    this.cmt,
  });
}
