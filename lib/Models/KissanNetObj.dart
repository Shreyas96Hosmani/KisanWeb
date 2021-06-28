class KissanNetObj {
  String home_tile_url_link,
      video_english,
      video_hindi,
      video_marathi,
      play_event_video;
  int force_update_version_code, paywall, consent_reminder_days;

  bool force_update_needed;

  KissanNetObj(
      this.force_update_needed,
      this.force_update_version_code,
      this.home_tile_url_link,
      this.video_english,
      this.video_hindi,
      this.video_marathi,
      this.play_event_video,
      this.paywall,
      this.consent_reminder_days);
}
