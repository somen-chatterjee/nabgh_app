class FAQModel {
  int? id;
  String? question;
  String? answer;
  int? status;
  String? createdAt;
  String? updatedAt;

  FAQModel(
      {this.id,
        this.question,
        this.answer,
        this.status,
        this.createdAt,
        this.updatedAt});

  FAQModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
