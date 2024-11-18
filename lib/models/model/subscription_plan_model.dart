class SubscriptionPlanModel {
  int? id;
  String? title;
  String? price;
  String? description;
  String? days;
  String? durationType;
  String? productId;
  int? freeDays;
  int? status;
  String? time;
  String? createdAt;
  String? updatedAt;

  SubscriptionPlanModel(
      {this.id,
        this.title,
        this.price,
        this.description,
        this.days,
        this.durationType,
        this.productId,
        this.freeDays,
        this.status,
        this.time,
        this.createdAt,
        this.updatedAt});

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    days = json['days'];
    durationType = json['duration_type'];
    productId = json['product_id'];
    freeDays = json['free_days'];
    status = json['status'];
    time = json['time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['days'] = days;
    data['duration_type'] = durationType;
    data['product_id'] = productId;
    data['free_days'] = freeDays;
    data['status'] = status;
    data['time'] = time;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
