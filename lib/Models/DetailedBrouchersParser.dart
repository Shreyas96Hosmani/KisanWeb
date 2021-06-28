class DetailedBrouchersParser {
  int upload_by_userid, seq_no;

  String id, media_type, media_url, bigthumb_url, smallthumb_url, title;

  bool is_cover;

  DetailedBrouchersParser({
    this.id,
    this.upload_by_userid,
    this.media_type,
    this.media_url,
    this.bigthumb_url,
    this.smallthumb_url,
    this.is_cover,
    this.seq_no,
    this.title,
  });

  factory DetailedBrouchersParser.fromJson(Map<String, dynamic> json) =>
      DetailedBrouchersParser(
          id: json["id"],
          upload_by_userid: json["upload_by_userid"],
          media_type: json["media_type"],
          media_url: json["media_url"],
          bigthumb_url: json["bigthumb_url"],
          smallthumb_url: json["smallthumb_url"],
          is_cover: json["is_cover"],
          seq_no: json["seq_no"],
          title: json['title']);
}
