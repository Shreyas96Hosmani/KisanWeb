class EventDetails {
  String type,
      title,
      about,
      about_hindi,
      about_marathi,
      created_date,
      image_path,
      image_path_medium,
      image_path_small,
      webinar_ids,
      pavilion_id,
      media_type,
      media_url,
      start_date,
      end_date,
      share_link,
      event_date_status,
      quiz_form_url,
      survey_form_url,
      poll_form_url;
  int user_id;

  bool is_added_to_calender;

  EventDetails(
      this.user_id,
      this.type,
      this.title,
      this.about,
      this.about_hindi,
      this.about_marathi,
      this.created_date,
      this.image_path,
      this.image_path_medium,
      this.image_path_small,
      this.webinar_ids,
      this.pavilion_id,
      this.media_type,
      this.media_url,
      this.start_date,
      this.end_date,
      this.share_link,
      this.event_date_status,
      this.quiz_form_url,
      this.survey_form_url,
      this.poll_form_url,
      this.is_added_to_calender);
}
