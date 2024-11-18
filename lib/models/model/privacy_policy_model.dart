class PrivacyPolicyModel {
  int? id;
  String? title;
  String? slug;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;

  PrivacyPolicyModel(
      {this.id,
        this.title,
        this.slug,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
