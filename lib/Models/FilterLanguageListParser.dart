class FilterLanguageListParser {
  int cnt;
  String language;


  FilterLanguageListParser(
      {this.language,
      this.cnt});

  factory FilterLanguageListParser.fromJson(Map<String, dynamic> json) =>
      FilterLanguageListParser(
          language: json["language"],
          cnt: json["cnt"]);
}
