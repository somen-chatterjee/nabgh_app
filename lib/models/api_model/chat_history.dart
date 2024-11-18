// class ChatHistoryModel {
//   ChatHistoryModel({
//     required this.message,
//     required this.status,
//     required this.data,
//   });
//
//   late final String message;
//   late final int status;
//   late final List<ChatHistory> data;
//
//   ChatHistoryModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     status = json['status'];
//     data = List.from(json['data']).map((e) => ChatHistory.fromJson(e)).toList();
//   }
// }

class ChatHistory {
  ChatHistory({
    required this.id,
    required this.userId,
    required this.question,
    required this.answer,
    required this.category,
    required this.catId,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
     required  this.isSelected,
  });

  late final int id;
  late final String userId;
  late final String question;
  late final String answer;
  late final String? category;
  late final String? catId;
  late final String? tabId;
  late final String? deviceId;
  late final int status;
  late final int type;
  // late final int imgKey;
  late final String createdAt;
  late final String updatedAt;
      bool isSelected = false;

  ChatHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    question = json['question'];
    answer = json['answer'];
    category = json['category'];
    catId = json['cat_id'];
    tabId = json['tab_id'];
    deviceId = json['device_id'];
    status = json['status'];
    type = json['type'];
    // imgKey = json['imgKey'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['question'] = question;
    data['answer'] = answer;
    data['category'] = category;
    data['cat_id'] = catId;
    data['tab_id'] = tabId;
    data['type'] = type;
    data['device_id'] = deviceId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    // data['img_key'] = imgKey;
    return data;
  }
}
