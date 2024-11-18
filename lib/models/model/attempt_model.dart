class AttemptModel {
  int? attempt;
  int? plan;
  String? model;

  AttemptModel({this.attempt, this.plan});

  AttemptModel.fromJson(Map<String, dynamic> json) {
    attempt = json['attept'];
    plan = json['plan'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attept'] = attempt;
    data['plan'] = plan;
    data['model'] = model;
    return data;
  }
}
