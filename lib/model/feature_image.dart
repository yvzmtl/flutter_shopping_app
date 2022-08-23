class FeatureImg {
  int featureImgId=0;
  String featureImgUrl="";
  Null categoryId;

  FeatureImg({
    required this.featureImgId,
    required this.featureImgUrl,
    required this.categoryId});

  FeatureImg.fromJson(Map<String, dynamic> json) {
    featureImgId = json['featureImgId'];
    featureImgUrl = json['featureImgUrl'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featureImgId'] = this.featureImgId;
    data['featureImgUrl'] = this.featureImgUrl;
    data['categoryId'] = this.categoryId;
    return data;
  }
}