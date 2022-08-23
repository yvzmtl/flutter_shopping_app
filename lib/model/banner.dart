class MyBanner {
  int bannerImgId=0;
  String bannerImgUrl="";
  Null categoryId;
  String bannerText="";

  MyBanner(
      {
        required this.bannerImgId,
        required this.bannerImgUrl,
        required this.categoryId,
        required this.bannerText});

  MyBanner.fromJson(Map<String, dynamic> json) {
    bannerImgId = json['bannerImgId'];
    bannerImgUrl = json['bannerImgUrl'];
    categoryId = json['categoryId'];
    bannerText = json['bannerText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerImgId'] = this.bannerImgId;
    data['bannerImgUrl'] = this.bannerImgUrl;
    data['categoryId'] = this.categoryId;
    data['bannerText'] = this.bannerText;
    return data;
  }
}