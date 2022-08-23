import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_shopping_app/const/api_const.dart';
import 'package:flutter_shopping_app/model/banner.dart';
import 'package:flutter_shopping_app/model/category.dart';
import 'package:flutter_shopping_app/model/feature_image.dart';
import 'package:flutter_shopping_app/model/product.dart';
import 'package:http/http.dart' as http;


List<MyBanner> parseBanner(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var banners = l.map((model) => MyBanner.fromJson(model)).toList();
  return banners;
}

List<FeatureImg> parseFeatureImage(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var featureImg = l.map((model) => FeatureImg.fromJson(model)).toList();
  return featureImg;
}

List<MyCategory> parseCategory(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var categories = l.map((model) => MyCategory.fromJson(model)).toList();
  return categories;
}

List<Product> parseProduct(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var products = l.map((model) => Product.fromJson(model)).toList();
  return products;
}

Product parseProductDetail(String responseBody){
  var l = json.decode(responseBody) as dynamic;
  var products = Product.fromJson(l);
  return products;
}

Future<List<MyBanner>> fetchBanner() async
{
  final response = await http.get(Uri.parse("$mainUrl$bannerUrl"));
  if(response.statusCode == 200){
    return compute(parseBanner,response.body);
  }
  else if(response.statusCode == 404){
    throw Exception("Bulunamadı");
  }
  else{
    throw Exception("Banner getirilemedi");
  }
}

Future<List<FeatureImg>> fetchFeatureImages() async
{
  final response = await http.get(Uri.parse("$mainUrl$featureUrl"));
  if(response.statusCode == 200){
    return compute(parseFeatureImage,response.body);
  }
  else if(response.statusCode == 404){
    throw Exception("Bulunamadı");
  }
  else{
    throw Exception("FeatureImg getirilemedi");
  }
}

Future<List<MyCategory>> fetchCategories() async
{
  final response = await http.get(Uri.parse("$mainUrl$categoriesUrl"));
  if(response.statusCode == 200){
    return compute(parseCategory,response.body);
  }
  else if(response.statusCode == 404){
    throw Exception("Bulunamadı");
  }
  else{
    throw Exception("Categoriler getirilemedi");
  }
}

Future<List<Product>> fetchProductBySubCategory(id) async
{
  final response = await http.get(Uri.parse("$mainUrl$productUrl/$id"));
  if(response.statusCode == 200){
    return compute(parseProduct,response.body);
  }
  else if(response.statusCode == 404){
    throw Exception("Bulunamadı");
  }
  else{
    throw Exception("Ürünler getirilemedi");
  }
}

Future<Product> fetchProductDetail(id) async
{
  final response = await http.get(Uri.parse("$mainUrl$productDetail/$id"));
  if(response.statusCode == 200){
    return compute(parseProductDetail,response.body);
  }
  else if(response.statusCode == 404){
    throw Exception("Bulunamadı");
  }
  else{
    throw Exception("Ürün Detay getirilemedi");
  }
}

Future<String> findUser(id,token) async
{
  final response = await http.get(Uri.parse("$mainUrl$userPath/$id"),
      headers: {
        "Authorization" : "Bearer $token"
      });
  if(response.statusCode == 200){
    return "User Found";
  }
  else if(response.statusCode == 404){
    return "User Not Found";
  }
  else{
    throw Exception("Kullanıcı getirilemedi");
  }
}

createUserApi(String key, String uid, String name, String phone, String address) async{

  var body = {
    "uid":uid,
    "name":name,
    "phone":phone,
    "address":address
  };

  var res = await http.post(Uri.parse("$mainUrl$userPath"),headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  },
      body: json.encode(body));

  if(res.statusCode == 201) return "Created"; //oluşturuldu
  else if(res.statusCode == 209) return "Conflic"; //çatışma
  else return res;
}
