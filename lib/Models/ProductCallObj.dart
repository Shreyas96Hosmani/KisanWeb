class ProductCallObj {
  int id;
  int userId;
  String titleEnglish;
  String titleMarathi;
  String titleHindi;
  String descEnglish;
  String descMarathi;
  String descHindi;
  var price;
  String organisationName;
  String mediaType;
  String mediaUrl;
  String bigthumbUrl;
  String smallthumbUrl;

  ProductCallObj(
      {this.id,
        this.userId,
        this.titleEnglish,
        this.titleMarathi,
        this.titleHindi,
        this.descEnglish,
        this.descMarathi,
        this.descHindi,
        this.price,
        this.organisationName,
        this.mediaType,
        this.mediaUrl,
        this.bigthumbUrl,
        this.smallthumbUrl});

  ProductCallObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    titleEnglish = json['title_english'];
    titleMarathi = json['title_marathi'];
    titleHindi = json['title_hindi'];
    descEnglish = json['desc_english'];
    descMarathi = json['desc_marathi'];
    descHindi = json['desc_hindi'];
    price = json['price'];
    organisationName = json['organisation_name'];
    mediaType = json['media_type'];
    mediaUrl = json['media_url'];
    bigthumbUrl = json['bigthumb_url'];
    smallthumbUrl = json['smallthumb_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title_english'] = this.titleEnglish;
    data['title_marathi'] = this.titleMarathi;
    data['title_hindi'] = this.titleHindi;
    data['desc_english'] = this.descEnglish;
    data['desc_marathi'] = this.descMarathi;
    data['desc_hindi'] = this.descHindi;
    data['price'] = this.price;
    data['organisation_name'] = this.organisationName;
    data['media_type'] = this.mediaType;
    data['media_url'] = this.mediaUrl;
    data['bigthumb_url'] = this.bigthumbUrl;
    data['smallthumb_url'] = this.smallthumbUrl;
    return data;
  }
}