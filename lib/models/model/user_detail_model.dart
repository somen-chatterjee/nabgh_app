class UserDetailModel {
  String? message;
  int? status;
  Data? data;

  UserDetailModel({this.message, this.status, this.data});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? profile;
  String? model;
  String? deviceToken;
  String? socialId;
  int? status;
  int? showFile;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.name,
        this.email,
        this.profile,
        this.model,
        this.deviceToken,
        this.status,
        this.showFile,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profile = json['profile'];
    model = json['model'];
    deviceToken = json['device_token'];
    socialId = json['social_id'];
    status = json['status'];
    showFile = json['show_file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profile'] = profile;
    data['model'] = model;
    data['device_token'] = deviceToken;
    data['social_id'] = socialId;
    data['status'] = status;
    data['show_file'] = showFile;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
