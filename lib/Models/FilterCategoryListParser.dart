class FilterCategoryListParser {
  int event_count;
  String c_id,
      c_name,
      c_image_url;


  FilterCategoryListParser(
      {this.c_id,
      this.c_name,
      this.c_image_url,
      this.event_count});

  factory FilterCategoryListParser.fromJson(Map<String, dynamic> json) =>
      FilterCategoryListParser(
          c_id: json["c_id"],
          c_name: json["c_name"],
          c_image_url: json["c_image_url"],
          event_count: json["event_count"]);
}
