import 'package:kisanweb/Models/CallHistoryUserObj.dart';

class CallHistoryListParser {
  int activity_by_userid, activity_for_userid, activity_for_item_id;

  String id,
      first_name,
      eventcode,
      activity_for_user_type,
      activity_code,
      source,
      field1,
      activity_by_user_type,
      activity_for_item_uuid,
      uid,
      activity_datetime_utc,
      activity_datetime;

  CallHistoryListParser(
      {this.id,
      this.first_name,
      this.eventcode,
      this.activity_by_userid,
      this.activity_for_userid,
      this.activity_for_user_type,
      this.activity_code,
      this.source,
      this.field1,
      this.activity_by_user_type,
      this.activity_for_item_id,
      this.activity_for_item_uuid,
      this.uid,
      this.activity_datetime_utc,
      this.activity_datetime});

  factory CallHistoryListParser.fromJson(Map<String, dynamic> json) =>
      CallHistoryListParser(
          id: json["id"],
          first_name: json["first_name"],
          eventcode: json["eventcode"],
          activity_by_userid: json["activity_by_userid"],
          activity_for_userid: json["activity_for_userid"],
          activity_for_user_type: json["activity_for_user_type"],
          activity_code: json["activity_code"],
          source: json["source"],
          field1: json["field1"],
          activity_by_user_type: json["activity_by_user_type"],
          activity_for_item_id: json["activity_for_item_id"],
          activity_for_item_uuid: json["activity_for_item_uuid"],
          uid: json["uid"],
          activity_datetime_utc: json["activity_datetime_utc"],
          activity_datetime: json["activity_datetime"]);
}
