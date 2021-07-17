class NotificationsListParser {
  String notification_users_id,
      sent_datetime,
      id,
      type,
      field1,
      field2,
      field3,
      field4,
      field5,
      field7,
      field8,
      field9,
      action;

  NotificationsListParser(
      {this.notification_users_id,
      this.sent_datetime,
      this.id,
      this.type,
      this.field1,
      this.field2,
      this.field3,
      this.field4,
      this.field5,
      this.field8,
      this.field7,
      this.field9,
      this.action});

  factory NotificationsListParser.fromJson(Map<String, dynamic> json) =>
      NotificationsListParser(
          notification_users_id: json["notification_users_id"],
          sent_datetime: json["sent_datetime"],
          id: json["id"],
          type: json["type"],
          field1: json["field1"],
          field2: json["field2"],
          field3: json["field3"],
          field4: json["field4"],
          field5: json["field5"],
          field7: json["field7"],
          field8: json["field8"],
          field9: json["field9"],
          action: json["action"]);
}
