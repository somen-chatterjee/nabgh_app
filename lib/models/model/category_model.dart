class CategoryModel {
  int? id;
  String? title;
  String? slug;
  String? description;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<GetDiscover>? getDiscover;

  CategoryModel(
      {this.id,
        this.title,
        this.slug,
        this.description,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.getDiscover});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['get_discover'] != null) {
      getDiscover = <GetDiscover>[];
      json['get_discover'].forEach((v) {
        getDiscover!.add(GetDiscover.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (getDiscover != null) {
      data['get_discover'] = getDiscover!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetDiscover {
  int? id;
  String? title;
  String? titleEn;
  String? category;
  String? slug;
  String? description;
  String? descriptionEn;
  String? suggestion;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;

  GetDiscover(
      {this.id,
        this.title,
        this.titleEn,
        this.category,
        this.slug,
        this.description,
        this.descriptionEn,
        this.suggestion,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.categoryName});

  GetDiscover.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    titleEn = json['title_en'];
    category = json['category'];
    slug = json['slug'];
    description = json['description'];
    descriptionEn = json['description_en'];
    suggestion = json['suggestion'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['title_en'] = titleEn;
    data['category'] = category;
    data['slug'] = slug;
    data['description'] = description;
    data['description_en'] = descriptionEn;
    data['suggestion'] = suggestion;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['category_name'] = categoryName;
    return data;
  }
}
