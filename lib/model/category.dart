

class MyCategory {
  int categoryId=0;
  String categoryName="";
  String categoryImg="";
  List<SubCategories> subCategories = new List<SubCategories>.empty(growable: true);

  MyCategory(
      {
        required this.categoryId,
        required this.categoryName,
        required this.categoryImg,
        required this.subCategories});

  MyCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    categoryImg = json['categoryImg'];
    if (json['subCategories'] != null) {
      subCategories = new List<SubCategories>.empty(growable: true);
      json['subCategories'].forEach((v) {
        subCategories.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['categoryImg'] = this.categoryImg;
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int subCategoryId=0;
  String subCategoryName="";
  int categoryId=0;

  SubCategories.empty();

  SubCategories({
    required this.subCategoryId,
    required this.subCategoryName,
    required this.categoryId
  });

  SubCategories.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['subCategoryId'];
    subCategoryName = json['subCategoryName'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subCategoryId'] = this.subCategoryId;
    data['subCategoryName'] = this.subCategoryName;
    data['categoryId'] = this.categoryId;
    return data;
  }
}