class NotificationsListParser {
  String notification_users_id,
      sent_datetime,
      id,
      type,
      field1,
      field2,
      field5,
      field8,
      field9;

  int created_by_user_id;

  NotificationsListParser(
      {this.notification_users_id,
      this.sent_datetime,
      this.id,
      this.type,
      this.created_by_user_id,
      this.field1,
      this.field2,
      this.field5,
      this.field8,
      this.field9});

  factory NotificationsListParser.fromJson(Map<String, dynamic> json) =>
      NotificationsListParser(
        notification_users_id: json["notification_users_id"],
        sent_datetime: json["sent_datetime"],
        id: json["id"],
        type: json["type"],
        created_by_user_id: json["created_by_user_id"],
        field1: json["field1"],
        field2: json["field2"],
        field5: json["field5"],
        field8: json["field8"],
        field9: json["field9"],
      );
}
