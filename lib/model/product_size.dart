

import 'package:flutter_shopping_app/model/size.dart';

class ProductSizes {
  int sizeId=0;
  int productId=0;
  int number=0;
  MySize? size;

  ProductSizes.empty();

  ProductSizes({
    required this.sizeId,
    required this.productId,
    required this.number,
    required this.size});

  ProductSizes.fromJson(Map<String, dynamic> json) {
    sizeId = json['sizeId'];
    productId = json['productId'];
    number = json['number'];
    size = json['size'] != null ? new MySize.fromJson(json['size']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sizeId'] = this.sizeId;
    data['productId'] = this.productId;
    data['number'] = this.number;
    if (this.size != null) {
      data['size'] = this.size?.toJson();
    }
    return data;
  }
}