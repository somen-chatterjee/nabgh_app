class MyPlanModel {
  int? id;
  String? userId;
  String? userName;
  String? planId;
  String? paymentMethod;
  String? planName;
  String? amount;
  String? planActiveDate;
  String? planValidity;
  String? planExpiryDate;
  String? trial;
  int? status;
  String? createdAt;
  String? updatedAt;

  MyPlanModel(
      {this.id,
        this.userId,
        this.userName,
        this.planId,
        this.paymentMethod,
        this.planName,
        this.amount,
        this.planActiveDate,
        this.planValidity,
        this.planExpiryDate,
        this.trial,
        this.status,
        this.createdAt,
        this.updatedAt});

  MyPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    planId = json['plan_id'];
    paymentMethod = json['paymentMethod'];
    planName = json['plan_name'];
    amount = json['amount'];
    planActiveDate = json['plan_active_date'];
    planValidity = json['plan_validity'];
    planExpiryDate = json['plan_expiry_date'];
    trial = json['trial'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['plan_id'] = planId;
    data['paymentMethod'] = paymentMethod;
    data['plan_name'] = planName;
    data['amount'] = amount;
    data['plan_active_date'] = planActiveDate;
    data['plan_validity'] = planValidity;
    data['plan_expiry_date'] = planExpiryDate;
    data['trial'] = trial;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
