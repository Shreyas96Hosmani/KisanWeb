class AdsObject {
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

  AdsObject(
      this.ad_position,
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
      this.pavilion_name_for_category);
}
