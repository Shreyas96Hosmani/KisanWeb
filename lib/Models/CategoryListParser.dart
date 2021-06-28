class CategoryListParser {
  int id, seq_no;
  String name,
      image_url,
      app_image_url,
      color,
      img_type,
      app_name_english,
      app_name_marathi,
      app_name_hindi;

  bool is_active;

  CategoryListParser(
      {this.id,
      this.name,
      this.image_url,
      this.seq_no,
      this.is_active,
      this.app_image_url,
      this.color,
      this.img_type,
      this.app_name_english,
      this.app_name_marathi,
      this.app_name_hindi});

  factory CategoryListParser.fromJson(Map<String, dynamic> json) =>
      CategoryListParser(
          id: json["id"],
          name: json["name"],
          image_url: json["image_url"],
          seq_no: json["seq_no"],
          is_active: json["is_active"],
          app_image_url: json["app_image_url"],
          color: json["color"],
          img_type: json["img_type"],
          app_name_english: json["app_name_english"],
          app_name_marathi: json["app_name_marathi"],
          app_name_hindi: json["app_name_hindi"]);
}
