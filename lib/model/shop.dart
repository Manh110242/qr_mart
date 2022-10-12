class Shop {
  String id,
      name,
      address,
      // ignore: non_constant_identifier_names
      province_name,
      // ignore: non_constant_identifier_names
      district_name,
      // ignore: non_constant_identifier_names
      ward_name,
      // ignore: non_constant_identifier_names
      avatar_path,
      // ignore: non_constant_identifier_names
      avatar_name,
      phone,
      rate,
      rate_count,
      email,
      // ignore: non_constant_identifier_names
      created_time,
      // ignore: non_constant_identifier_names
      name_contact,
      website,
      phoneUser;

  Shop(
      {this.rate_count,
      this.id,
      this.name,
      this.address,
      this.province_name,
      this.district_name,
      this.ward_name,
      this.avatar_path,
      this.avatar_name,
      this.phone,
      this.email,
      this.website,
      this.created_time,
      this.name_contact,
      this.phoneUser,
      this.rate});
}
