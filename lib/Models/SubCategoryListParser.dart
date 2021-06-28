class SubCategoryListParser {
  int companies, products;

  int id, master_id, seq_no, pavilion_id;

  String name, image;

  bool is_active;

  SubCategoryListParser(
      {this.id,
      this.master_id,
      this.name,
      this.image,
      this.is_active,
      this.seq_no,
      this.pavilion_id});

  SubCategoryListParser.forcounts(int companies, int products) {
    this.companies = companies;
    this.products = products;
  }

  factory SubCategoryListParser.fromJson(Map<String, dynamic> json) =>
      SubCategoryListParser(
          id: json["id"],
          master_id: json["master_id"],
          name: json["name"],
          image: json["image"],
          is_active: json["is_active"],
          seq_no: json["seq_no"],
          pavilion_id: json["pavilion_id"]);
}
