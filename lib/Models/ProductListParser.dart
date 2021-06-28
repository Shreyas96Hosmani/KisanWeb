class ProductListParser {
  int companies, products;

  int id, user_id;
  double price;
  String title_english,
      title_marathi,
      title_hindi,
      desc_english,
      desc_marathi,
      desc_hindi,
      currency,
      organisation_name,
      image_bigthumb_url,
      media_url,
      bigthumb_url,
      smallthumb_url,
      media_type;

  bool featured;

  ProductListParser.forcounts(int companies, int products) {
    this.companies = companies;
    this.products = products;
  }

  ProductListParser({
    this.id,
    this.user_id,
    this.title_english,
    this.title_marathi,
    this.title_hindi,
    this.desc_english,
    this.desc_marathi,
    this.desc_hindi,
    this.price,
    this.currency,
    this.featured,
    this.organisation_name,
    this.image_bigthumb_url,
    this.media_url,
    this.bigthumb_url,
    this.smallthumb_url,
    this.media_type,
  });

  factory ProductListParser.fromJson(Map<String, dynamic> json) =>
      ProductListParser(
          id: json["id"],
          user_id: json["user_id"],
          title_english: json["title_english"],
          title_marathi: json["title_marathi"],
          title_hindi: json["title_hindi"],
          desc_english: json["desc_english"],
          desc_marathi: json["desc_marathi"],
          desc_hindi: json["desc_hindi"],
          price: json["price"],
          currency: json["currency"],
          featured: json["featured"],
          organisation_name: json["organisation_name"],
          image_bigthumb_url: json["image_bigthumb_url"],
          media_url: json["media_url"],
          bigthumb_url: json["bigthumb_url"],
          smallthumb_url: json["smallthumb_url"],
          media_type: json["media_type"]);
}
