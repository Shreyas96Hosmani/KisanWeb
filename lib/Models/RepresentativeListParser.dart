class RepresentativeListParser {
  String id,
      mobile,
      email,
      designation,
      languages,
      pavilion_ids,
      image_url,
      first_name,
      last_name,
      status;
  int user_id, for_item_id, organisation_id;

  bool contact_phone, contact_whatsapp, caller_id;

  RepresentativeListParser(
      {this.user_id,
      this.id,
      this.for_item_id,
      this.mobile,
      this.email,
      this.designation,
      this.languages,
      this.contact_phone,
      this.contact_whatsapp,
      this.caller_id,
      this.pavilion_ids,
      this.organisation_id,
      this.image_url,
      this.first_name,
      this.last_name,
      this.status});

  factory RepresentativeListParser.fromJson(Map<String, dynamic> json) =>
      RepresentativeListParser(
          user_id: json["user_id"],
          id: json["id"],
          for_item_id: json["for_item_id"],
          mobile: json["mobile"],
          email: json["email"],
          designation: json["designation"],
          languages: json["languages"],
          contact_phone: json["contact_phone"],
          contact_whatsapp: json["contact_whatsapp"],
          caller_id: json["caller_id"],
          pavilion_ids: json["pavilion_ids"],
          organisation_id: json["organisation_id"],
          image_url: json["image_url"],
          first_name: json["first_name"],
          last_name: json["last_name"],
          status: json["status"]);
}
