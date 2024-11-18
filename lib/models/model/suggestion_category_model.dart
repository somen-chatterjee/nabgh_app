class SuggestionCategoryModel {
  int? id;
  String? title;
  String? slug;
  String? suggestion;
  int? status;
  String? createdAt;
  String? updatedAt;

  SuggestionCategoryModel(
      {this.id,
        this.title,
        this.slug,
        this.suggestion,
        this.status,
        this.createdAt,
        this.updatedAt});

  SuggestionCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    suggestion = json['suggestion'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['suggestion'] = suggestion;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
