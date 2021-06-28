class CompaniesListParser {
  int user_id, products;
  double random;
  String organisation_name, image_bigthumb_url;

  //bool featured;

  CompaniesListParser(
      {this.user_id,
      this.random,
      this.organisation_name,
      this.image_bigthumb_url,
      this.products});

  factory CompaniesListParser.fromJson(Map<String, dynamic> json) =>
      CompaniesListParser(
          user_id: json["user_id"],
          random: json["random"],
          organisation_name: json["organisation_name"],
          image_bigthumb_url: json["image_bigthumb_url"],
          products: json["products"]);
}
