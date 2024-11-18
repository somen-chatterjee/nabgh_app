class SuggestionSubCategoryModel {
  int? id;
  String? title;
  String? slug;
  String? description;
  String? image;
  String? backColor;
  int? status;
  String? sendMsg;
  String? createdAt;
  String? updatedAt;

  SuggestionSubCategoryModel(
      {this.id,
        this.title,
        this.slug,
        this.description,
        this.image,
        this.backColor,
        this.status,
        this.sendMsg,
        this.createdAt,
        this.updatedAt});

  SuggestionSubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    image = json['image'];
    backColor = json['back_color'];
    status = json['status'];
    sendMsg = json['send_msg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['image'] = image;
    data['back_color'] = backColor;
    data['status'] = status;
    data['send_msg'] = sendMsg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
