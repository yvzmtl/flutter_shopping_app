import 'package:flutter_shopping_app/model/product_size.dart';

class Product {
  int productId = 0;
  String productName="";
  String productShortDescription="";
  String productDescription="";
  double productOldPrice=0;
  double productNewPrice=0;
  bool productIsSale = true;
  String productSaleText="";
  String productSubText="";
  int productOrderNumber=0;
  String productCreateDate="";
  String productCode="";
  int subCategoryId=0;
  List<ProductImages> productImages = List<ProductImages>.empty(growable: true);
  List<ProductSizes> productSizes = List<ProductSizes>.empty(growable: true);

  Product.empty(){}

  Product(
      { required this.productId,
        required this.productName,
        required this.productShortDescription,
        required this.productDescription,
        required this.productOldPrice,
        required this.productNewPrice,
        required this.productIsSale,
        required this.productSaleText,
        required this.productSubText,
        required this.productOrderNumber,
        required this.productCreateDate,
        required this.productCode,
        required this.subCategoryId,
        required this.productImages,}
      );

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] as int;
    productName = json['productName'];
    productShortDescription = json['productShortDescription'];
    productDescription = json['productDescription'];
    productOldPrice = json['productOldPrice'] as double;
    productNewPrice = json['productNewPrice'] as double;
    productIsSale = json['productIsSale'];
    productSaleText = json['productSaleText'];
    productSubText = json['productSubText'];
    productOrderNumber = json['productOrderNumber'] as int;
    productCreateDate = json['productCreateDate'];
    productCode = json['productCode'];
    subCategoryId = json['subCategoryId'] as int;


    if (json['productImages'] != null) {
      productImages = new List<ProductImages>.empty(growable: true);
      json['productImages'].forEach((v) {
        productImages.add(new ProductImages.fromJson(v));
      });
    }

    if (json['productSizes'] != null) {
      productSizes = new List<ProductSizes>.empty(growable: true);
      json['productSizes'].forEach((v) {
        productSizes.add(new ProductSizes.fromJson(v));
      });
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productShortDescription'] = this.productShortDescription;
    data['productDescription'] = this.productDescription;
    data['productOldPrice'] = this.productOldPrice;
    data['productNewPrice'] = this.productNewPrice;
    data['productIsSale'] = this.productIsSale;
    data['productSaleText'] = this.productSaleText;
    data['productSubText'] = this.productSubText;
    data['productOrderNumber'] = this.productOrderNumber;
    data['productCreateDate'] = this.productCreateDate;
    data['productCode'] = this.productCode;
    data['subCategoryId'] = this.subCategoryId;


    if (this.productImages != null) {
      data['productImages'] =
          this.productImages.map((v) => v.toJson()).toList();
    }

    if (this.productSizes != null) {
      data['productSizes'] = this.productSizes.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ProductImages {
  int imgId = 0;
  String imgUrl ="";
  int productId = 1;

  ProductImages({
    required this.imgId,
    required this.imgUrl,
    required this.productId});

  ProductImages.fromJson(Map<String, dynamic> json) {
    imgId = json['imgId'];
    imgUrl = json['imgUrl'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgId'] = this.imgId;
    data['imgUrl'] = this.imgUrl;
    data['productId'] = this.productId;
    return data;
  }
}