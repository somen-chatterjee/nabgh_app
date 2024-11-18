class SubDiscoverModel {
  int? id;
  String? title;
  String? category;
  String? slug;
  String? description;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;

  SubDiscoverModel(
      {this.id,
        this.title,
        this.category,
        this.slug,
        this.description,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.categoryName});

  SubDiscoverModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    slug = json['slug'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category'] = this.category;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    return data;
  }
}
