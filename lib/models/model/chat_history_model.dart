import '../api_model/chat_history.dart';

class ChatHistoryModel {
  List<ChatHistory>? today;
  List<ChatHistory>? yesterday;
  List<ChatHistory>? l1WeekAgo;
  List<ChatHistory>? l2WeeksAgo;
  List<ChatHistory>? l3WeeksAgo;
  List<ChatHistory>? l1MonthAgo;
  List<ChatHistory>? l1YearAgo;
  List<ChatHistory>? l2YearsAgo;
  List<ChatHistory>? l3YearsAgo;

  ChatHistoryModel({this.today, this.yesterday, this.l1WeekAgo, this.l2WeeksAgo, this.l3WeeksAgo, this.l1MonthAgo, this.l1YearAgo, this.l2YearsAgo, this.l3YearsAgo,});

  List<ChatHistory> getListByKey(String key, ChatHistoryModel qaDateModel) {
    switch (key.toLowerCase()) {
      case 'today':
        return qaDateModel.today!;
      case 'yesterday':
        return qaDateModel.yesterday!;
      case 'last week ago':
        return qaDateModel.l1WeekAgo!;
      case '2 weeks ago':
        return qaDateModel.l2WeeksAgo!;
      case '3 weeks ago':
        return qaDateModel.l3WeeksAgo!;
      case '1 month ago':
        return qaDateModel.l1MonthAgo!;
      case '1 year ago':
        return qaDateModel.l1YearAgo!;
      case '2 years ago':
        return qaDateModel.l2YearsAgo!;
      case '3 years ago':
        return qaDateModel.l3YearsAgo!;
      default:
        return [];
    }
  }

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['Today'] != null) {
      today = <ChatHistory>[];
      json['Today'].forEach((v) {
        today!.add(ChatHistory.fromJson(v));
      });
    }
    if (json['Yesterday'] != null) {
      yesterday = <ChatHistory>[];
      json['Yesterday'].forEach((v) { yesterday!.add(ChatHistory.fromJson(v)); });
    }
    if (json['Last week ago'] != null) {
      l1WeekAgo = <ChatHistory>[];
    json['Last week ago'].forEach((v) { l1WeekAgo!.add(ChatHistory.fromJson(v)); });
    }
    if (json['2 weeks ago'] != null) {
    l2WeeksAgo = <ChatHistory>[];
    json['2 weeks ago'].forEach((v) { l2WeeksAgo!.add(ChatHistory.fromJson(v)); });
    }
    if (json['3 weeks ago'] != null) {
    l3WeeksAgo = <ChatHistory>[];
    json['3 weeks ago'].forEach((v) { l3WeeksAgo!.add(ChatHistory.fromJson(v)); });
    }
    if (json['1 month ago'] != null) {
    l1MonthAgo = <ChatHistory>[];
    json['1 month ago'].forEach((v) { l1MonthAgo!.add(ChatHistory.fromJson(v)); });
    }
    if (json['1 year ago'] != null) {
    l1YearAgo = <ChatHistory>[];
    json['1 year ago'].forEach((v) { l1YearAgo!.add(ChatHistory.fromJson(v)); });
    }
    if (json['2 years ago'] != null) {
    l2YearsAgo = <ChatHistory>[];
    json['2 years ago'].forEach((v) { l2YearsAgo!.add(ChatHistory.fromJson(v)); });
    }
    if (json['3 years ago'] != null) {
    l3YearsAgo = <ChatHistory>[];
    json['3 years ago'].forEach((v) { l3YearsAgo!.add(ChatHistory.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (today != null) {
      data['Today'] = today!.map((v) => v.toJson()).toList();
    }
    if (yesterday != null) {
      data['Yesterday'] = yesterday!.map((v) => v.toJson()).toList();
    }
    if (l1WeekAgo != null) {
      data['Last week ago'] = l1WeekAgo!.map((v) => v.toJson()).toList();
    }
    if (l2WeeksAgo != null) {
      data['2 weeks ago'] = l2WeeksAgo!.map((v) => v.toJson()).toList();
    }
    if (l3WeeksAgo != null) {
      data['3 weeks ago'] = l3WeeksAgo!.map((v) => v.toJson()).toList();
    }
    if (l1MonthAgo != null) {
      data['1 month ago'] = l1MonthAgo!.map((v) => v.toJson()).toList();
    }
    if (l1YearAgo != null) {
      data['1 year ago'] = l1YearAgo!.map((v) => v.toJson()).toList();
    }
    if (l2YearsAgo != null) {
      data['2 years ago'] = l2YearsAgo!.map((v) => v.toJson()).toList();
    }
    if (l3YearsAgo != null) {
      data['3 years ago'] = l3YearsAgo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class ChatData {
//   int? id;
//   String? userId;
//   String? question;
//   String? answer;
//   String? category;
//   String? catId;
//   String? tabId;
//   int? type;
//   String? deviceId;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   int? imgKey;
//
//   ChatData(
//       {this.id,
//         this.userId,
//         this.question,
//         this.answer,
//         this.category,
//         this.catId,
//         this.tabId,
//         this.type,
//         this.deviceId,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.imgKey});
//
//   ChatData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     question = json['question'];
//     answer = json['answer'];
//     category = json['category'];
//     catId = json['cat_id'];
//     tabId = json['tab_id'];
//     type = json['type'];
//     deviceId = json['device_id'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     imgKey = json['img_key'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['question'] = question;
//     data['answer'] = answer;
//     data['category'] = category;
//     data['cat_id'] = catId;
//     data['tab_id'] = tabId;
//     data['type'] = type;
//     data['device_id'] = deviceId;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['img_key'] = imgKey;
//     return data;
//   }
// }
