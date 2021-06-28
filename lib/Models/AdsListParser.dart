class AdsListParser {
  String ad_position,
      ad_screen,
      media_type,
      media_url,
      bigthumb_url,
      smallthumb_url,
      link_type,
      link_url,
      link_for,
      pavilion_name_for_category;
  int pavilion_id, linking_id, organisation_id;

  AdsListParser(
      {this.ad_position,
      this.ad_screen,
      this.pavilion_id,
      this.media_type,
      this.media_url,
      this.bigthumb_url,
      this.smallthumb_url,
      this.link_type,
      this.link_url,
      this.link_for,
      this.linking_id,
      this.organisation_id,
      this.pavilion_name_for_category});

  factory AdsListParser.fromJson(Map<String, dynamic> json) => AdsListParser(
      ad_position: json["ad_position"],
      ad_screen: json["ad_screen"],
      pavilion_id: json["pavilion_id"],
      media_type: json["media_type"],
      media_url: json["media_url"],
      bigthumb_url: json["bigthumb_url"],
      smallthumb_url: json["smallthumb_url"],
      link_type: json["link_type"],
      link_url: json["link_url"],
      link_for: json["link_for"],
      linking_id: json["linking_id"],
      organisation_id: json["organisation_id"],
      pavilion_name_for_category: json["pavilion_name_for_category"]);
}
