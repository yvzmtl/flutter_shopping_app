

class MySize {
  int sizeId=0;
  String sizeName="";
  List<Null> productSizes = new List<Null>.empty(growable: true);

  MySize({
    required this.sizeId,
    required this.sizeName,
    required this.productSizes});

  MySize.fromJson(Map<String, dynamic> json) {
    sizeId = json['sizeId'];
    sizeName = json['sizeName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sizeId'] = this.sizeId;
    data['sizeName'] = this.sizeName;

    return data;
  }
}