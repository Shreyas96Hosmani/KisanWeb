class DetailedProuctParser {
  int id, user_id, product_category_id;

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

  bool featured, liked;

  DetailedProuctParser(
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
    this.liked,
    this.product_category_id,
  );
}
