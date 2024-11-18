class SubChildDiscoverModel {
  int? id;
  String? title;
  String? discoverId;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? discoverName;

  SubChildDiscoverModel(
      {this.id,
        this.title,
        this.discoverId,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.discoverName});

  SubChildDiscoverModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    discoverId = json['discover_id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    discoverName = json['discover_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['discover_id'] = discoverId;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['discover_name'] = discoverName;
    return data;
  }
}
