class CompanyCallObj {
  String image_bigthumb_url,
      mobile,
      city,
      state,
      country,
      first_name,
      last_name;
  int user_id;

  CompanyCallObj({this.user_id, this.image_bigthumb_url, this.mobile,
      this.city, this.state, this.country, this.first_name, this.last_name});

  factory CompanyCallObj.fromJson(Map<String, dynamic> json) =>
      CompanyCallObj(user_id: json["user_id"],
          image_bigthumb_url: json["image_bigthumb_url"],
          mobile: json["mobile"],
          city: json["city"],
          state: json["state"],
          country: json["country"],
          first_name: json["first_name"],
          last_name: json["last_name"]);
}
