import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:nabgh_app/models/api_model/chat_history.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../change_language/language_helper.dart';
import '../constatns/app_constants.dart';
import '../constatns/app_key.dart';
import '../enum/app_loading_staus.dart';
import '../helper/check_network.dart';
import '../helper/sp_helper.dart';
import '../models/model/chat_history_model.dart';
import '../service/api_service.dart';
import 'auth_provider.dart';

class ChatHistoryProvider with ChangeNotifier {
  ChatHistoryProvider() {
    loadingStatus = AppLoadingStatus.none;
    clearLoadingStatus = AppLoadingStatus.none;
    notifyListeners();
  }

  bool isFirst = true;

  final RefreshController refreshChatHistoryController =
      RefreshController(initialRefresh: false);

  AppLoadingStatus loadingStatus = AppLoadingStatus.none;
  AppLoadingStatus clearLoadingStatus = AppLoadingStatus.none;

  String? name;
  String? suggestion;

  //this list for chats view list
  List<ChatHistory> chatHistoryList = [];

  //this list for display the question of the latest chats
  // List<ChatHistory> chatHistoryShowList = [];

  ChatHistoryModel chatHistoryShowList = ChatHistoryModel();

  ChatHistory? _chatHistory;

  ChatHistory? get chatHistory => _chatHistory;

  List<String> ids = [];
  bool allSelected = false;

  Future getChatHistory({
    required BuildContext context,
    required int? type,
    required String category,
    required String tabId,
  }) async {
    chatHistoryList.clear();
    // chatHistoryShowList = ChatHistoryModel();
    var pDevice = Provider.of<AuthenticateProvider>(context, listen: false);

    // print("somen ${await pDevice.getDeviceIdentifier()}");

    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      Map<String, dynamic> postBody = {
        "device_id": await pDevice.getDeviceIdentifier(),
        "type": type,
        "category": category,
        'tab_id': tabId,
        'user_id': await SpHelper.loadString(SpKey.mainUserId)
      };

      ApiResponse response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "chat_history", token: authToken, body: postBody);
      // print(AppKey.baseUrl);
      // print(authToken);
      // print(postBody);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          name = response.data["name"];
          suggestion = response.data["suggestion"];

          try {
            dynamic list = response.data["data"];

            if (list is List) {
              chatHistoryList =
                  list.map((e) => ChatHistory.fromJson(e)).toList();
            } else if (list is Map) {
              // set the object to display the chat history
              chatHistoryShowList = ChatHistoryModel.fromJson(list.map(
                (key, value) {
                  // print("object ${key.toString()}");

                  // print("object ${value.isNotEmpty}");
                  if (value.isNotEmpty) {
                    return MapEntry(key.toString(), value);
                  } else {
                    return MapEntry(key.toString(), []);
                  }
                },
              ));
            }
          } catch (e) {
            log("error $e");
          }

          //if category is empty then update the below list
          if (category.isEmpty) {
            // chatHistoryShowList =
            //     list.map((e) => ChatHistory.fromJson(e)).toList();
          }
          ids.clear();
          isFirst = false;
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(message: LocalizationManager().translate('checkInternet'));
    }
  }

  void onHistorySelect({
    required int mainIndex,
    required int chatIndex,
  }) {

    // need to select the chat history and use the tab id for delete operation

    // var history = chatHistoryShowList.today![0];

    var key = chatHistoryShowList.toJson().keys.toList()[mainIndex];

    // print("object $key");

    ChatHistory? history = chatHistoryShowList.getListByKey(key, chatHistoryShowList)[chatIndex];

    /*if (mainIndex == 0) {
      history = chatHistoryShowList.today![chatIndex];
    } else if (mainIndex == 1) {
      history = chatHistoryShowList.yesterday![chatIndex];
    } else if (mainIndex == 2) {
      history = chatHistoryShowList.l1WeekAgo![chatIndex];
    } else if (mainIndex == 3) {
      history = chatHistoryShowList.l2WeeksAgo![chatIndex];
    } else if (mainIndex == 4) {
      history = chatHistoryShowList.l3WeeksAgo![chatIndex];
    } else if (mainIndex == 5) {
      history = chatHistoryShowList.l1MonthAgo![chatIndex];
    } else if (mainIndex == 6) {
      history = chatHistoryShowList.l1YearAgo![chatIndex];
    } else if (mainIndex == 7) {
      history = chatHistoryShowList.l2YearsAgo![chatIndex];
    } else if (mainIndex == 8) {
      history = chatHistoryShowList.l3YearsAgo![chatIndex];
    }*/

    // ChatHistory chatDataList = ChatHistory.fromJson(chatHistoryShowList.toJson().values.toList()[mainIndex][chatIndex]);

    // if (history != null) {
      history.isSelected = !history.isSelected;
      // history.isSelected = !history.isSelected;

      // print("history ${history.isSelected}");

      if (history.isSelected) {
        ids.add(history.tabId!);
        // print("Somen $ids");
      } else {
        ids.remove(history.tabId);
        // print("Somen $ids");
      }
    // }

    if (ids.isNotEmpty) {
      isFirst = true;
    } else {
      isFirst = false;
    }

    notifyListeners();
  }

  bool _isSelectAll = false;

  bool get isSelectAll => _isSelectAll;


  void selectAllChats() {
    chatHistoryShowList.toJson().map((key, value) {

      List<ChatHistory>? list = chatHistoryShowList.getListByKey(key, chatHistoryShowList);

      int? mainIdx = chatHistoryShowList.toJson().keys.toList().indexOf(key);

      if (list.isNotEmpty) {
        list.map((e) {
          var chatIndex = list.indexOf(e);
          if (!list[chatIndex].isSelected) {
            if (!list[chatIndex].isSelected) {
              onHistorySelect(mainIndex: mainIdx, chatIndex: chatIndex);
            } else {
              onHistorySelect(mainIndex: mainIdx, chatIndex: chatIndex);
            }
          }
        }).toList();
      }
      notifyListeners();
      return MapEntry(key, value);
    });

    // chatHistoryShowList.map((e) {
    //   int currIdx = chatHistoryShowList.indexOf(e);
    //
    //   print(
    //       "chatHistoryShowList[currIdx].isSelected ${chatHistoryShowList[currIdx].isSelected}");
    //
    //   if (!chatHistoryShowList[currIdx].isSelected) {
    //     if (!chatHistoryShowList[currIdx].isSelected) {
    //       onHistorySelect(id: currIdx);
    //     } else {
    //       onHistorySelect(id: currIdx);
    //     }
    //   }
    //   notifyListeners();
    // }).toList();
    // _isSelectAll = true;

  }

  void deSelectAll() {
    chatHistoryShowList.toJson().map((key, value) {

      List<ChatHistory>? list = chatHistoryShowList.getListByKey(key, chatHistoryShowList);

      int? mainIdx = chatHistoryShowList.toJson().keys.toList().indexOf(key);

      if (list.isNotEmpty) {
        list.map((e) {
          var chatIndex = list.indexOf(e);
              onHistorySelect(mainIndex: mainIdx, chatIndex: chatIndex);
        }).toList();
      }
      notifyListeners();
      return MapEntry(key, value);
    });
    _isSelectAll = false;
    // notifyListeners();
  }

  //clear chat
  Future<ApiResponse> onDeleteHistory(
      {required BuildContext context, required int? type}) async {
    var pDevice = Provider.of<AuthenticateProvider>(context, listen: false);

    Map<String, dynamic> postBody = {
      "device_id": await pDevice.getDeviceIdentifier(),
      "id": ids.join(',')
    };

    // print("postBody $postBody");
    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      clearLoadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "clear_chat", token: authToken, body: postBody);
      clearLoadingStatus = response.appLoadingStatus;
      if (clearLoadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          AppConstants.getToast(message: response.data["message"].toString());
          if (context.mounted) {
            ids.clear();
            getChatHistory(
                context: context, type: type, category: "", tabId: '');
          }
        } else {
          AppConstants.getToast(message: response.data["message"].toString());
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  // void onDeleteHistory() {
  //   chatHistoryShowList.removeWhere((element) => element.isSelected);
  //   notifyListeners();
  // }

  clearIds() {
    ids.clear();
  }

  clearChatHistory() {
    chatHistoryList.clear();
    name = null;
    suggestion = null;
  }
}
