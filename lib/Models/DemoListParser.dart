class DemoListParser {
  int user_id;
  String title,
      description,
      title_marathi,
      title_hindi,
      desc_marathi,
      desc_hindi,
      organisation_name,
      media_url,
      bigthumb_url,
      smallthumb_url,
      media_type;

  DemoListParser(
      {this.user_id,
      this.title,
      this.description,
      this.title_marathi,
      this.title_hindi,
      this.desc_marathi,
      this.desc_hindi,
      this.organisation_name,
      this.media_url,
      this.bigthumb_url,
      this.smallthumb_url,
      this.media_type});

  factory DemoListParser.fromJson(Map<String, dynamic> json) => DemoListParser(
      user_id: json["user_id"],
      title: json["title"],
      description: json["description"],
      title_marathi: json["title_marathi"],
      title_hindi: json["title_hindi"],
      desc_marathi: json["desc_marathi"],
      desc_hindi: json["desc_hindi"],
      organisation_name: json["organisation_name"],
      media_url: json["media_url"],
      bigthumb_url: json["bigthumb_url"],
      smallthumb_url: json["smallthumb_url"],
      media_type: json["media_type"]);
}
