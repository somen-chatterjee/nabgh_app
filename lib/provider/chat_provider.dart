import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../change_language/language_helper.dart';
import '../constatns/app_constants.dart';
import '../constatns/app_key.dart';
import '../enum/app_loading_staus.dart';
import '../helper/check_network.dart';
import '../helper/sp_helper.dart';
import '../models/model/attempt_model.dart';
import '../models/model/chat_model.dart';
import '../service/api_service.dart';
import 'chat_history_provider.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider() {
    loadingStatus = AppLoadingStatus.none;
    attemptLoadingStatus = AppLoadingStatus.none;
    notifyListeners();
  }

  AppLoadingStatus loadingStatus = AppLoadingStatus.none;
  AppLoadingStatus attemptLoadingStatus = AppLoadingStatus.none;
  AppLoadingStatus adAttemptLoadingStatus = AppLoadingStatus.none;

  String? _chatResponse;

  String? get chatResponse => _chatResponse;

  AttemptModel? _attemptModel = AttemptModel();

  AttemptModel? get attemptModel => _attemptModel;

  // attempt model for add
  AttemptModel? _adAttemptModel = AttemptModel();

  AttemptModel? get adAttemptModel => _adAttemptModel;

  List<String> suggestionList = [];

  Future<ApiResponse> checkUserAttemptForAd(
      {required BuildContext context, int? image}) async {
    var pAuth = Provider.of<AuthenticateProvider>(context, listen: false);

    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      adAttemptLoadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      Map<String, dynamic> postBody = {
        "device_id": await pAuth.getDeviceIdentifier(),
        'image': image,
      };

      response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "user_attempt", token: authToken, body: postBody);
      adAttemptLoadingStatus = response.appLoadingStatus;
      if (adAttemptLoadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          // _chatResponse = response.data['data'].toString();
          _adAttemptModel = AttemptModel.fromJson(response.data['data']);
        } else {
          // AppConstants.getToast(message: response.data["message"].toString());
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  Future<ApiResponse> userAttempt(
      {required BuildContext context, int? image}) async {
    var pAuth = Provider.of<AuthenticateProvider>(context, listen: false);

    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      attemptLoadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      Map<String, dynamic> postBody = {
        "device_id": await pAuth.getDeviceIdentifier(),
        'image': image,
      };

      response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "user_attempt", token: authToken, body: postBody);
      attemptLoadingStatus = response.appLoadingStatus;
      if (attemptLoadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          // _chatResponse = response.data['data'].toString();
          _attemptModel = AttemptModel.fromJson(response.data['data']);
        } else {
          // AppConstants.getToast(message: response.data["message"].toString());
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  Future<ApiResponse> chatGpt({
    required BuildContext context,
    required Map<String, dynamic> postBody,
    required bool isDiscover,
    required CancelToken cancelToken,
  }) async {
    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl).post(
        endpoint: "chat_gpt",
        token: authToken,
        body: postBody,
        cancelToken: cancelToken,
      );
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        try {
          if (response.data["status"].toString() == "200") {
            suggestionList.clear();

            // print("_chatbody $postBody");

            _chatResponse = response.data['data'].toString();
            // log("somen $_chatResponse");

            if (context.mounted) {
              generateSuggestions(
                context: context,
                content: _chatResponse ?? postBody['question'],
              );
            }

            //for suggestion
            /*try {
              dynamic list = response.data["suggestions"];

              if (list is List) {
                // Handle array
                //store the value to the list
                list.map((e) => suggestionList.add(e.toString())).toList();
              } else if (list is Map) {
                // Handle object
                list.forEach((key, value) {
                  //store the value to the list
                  suggestionList.add(value.toString());
                });
              }
            } catch (e) {
              log("error $e");
              suggestionList.clear();
            }*/

            // if(isDiscover){
            _chatList.add(
              UserChatModel(
                isUser: false,
                message: _chatResponse!,
                chatType: ChatType.text,
              ),
            );
            // }
            if (context.mounted) {
              userAttempt(context: context);
              var p = Provider.of<ChatHistoryProvider>(context, listen: false);
              p.isFirst = true;
            }

          } else {
            AppConstants.getToast(message: response.data["message"].toString());
            // if(isDiscover){
            _chatList.add(
              UserChatModel(
                isUser: false,
                message: response.data["message"].toString(),
                chatType: ChatType.text,
              ),
            );
            // }
            if (context.mounted) {
              userAttempt(context: context);
            }
          }
        } catch (e) {
          AppConstants.getToast(
              message: LocalizationManager().translate('SomethingWentWrong'));
          loadingStatus = AppLoadingStatus.error;
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  Future<ApiResponse> discoverChatGpt({
    required BuildContext context,
    required Map<String, dynamic> postBody,
    required bool isDiscover,
    required bool isGlobal,
    required CancelToken cancelToken,
  }) async {
    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl).post(
        endpoint: "discover_chat_gpt",
        token: authToken,
        body: postBody,
        cancelToken: cancelToken,
      );
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        try {
          if (response.data["status"].toString() == "200") {
            suggestionList.clear();

            _chatResponse = response.data['data'].toString();
            String? imgKey = response.data['img_key'].toString();

            if (context.mounted) {
              generateSuggestions(
                context: context,
                content: imgKey == "0" ? _chatResponse! : postBody['question'],
                imageKey: int.parse(imgKey),
              );
            }

            var historyId = response.data['history_id'].toString();

            if (isGlobal && context.mounted) {
              createQuestionTitle(
                context: context,
                question: postBody['question'],
                tabId: postBody['tab_id'],
                historyId: historyId,
              );
            }

            // log("_chatResponse $_chatResponse");

            //for suggestion
            /*
            try {
              dynamic list = response.data["suggestions"];

              if (list is List) {
                // Handle array
                //store the value to the list
                list.map((e) => suggestionList.add(e.toString())).toList();
              } else if (list is Map) {
                // Handle object
                list.forEach((key, value) {
                  //store the value to the list
                  suggestionList.add(value.toString());
                });
              }

              // suggestionList = list;
            } catch (e) {
              log("error $e");
              suggestionList.clear();
            }*/

            if (isDiscover) {
              _chatList.add(
                UserChatModel(
                  isUser: false,
                  message: _chatResponse!,
                  chatType: ChatType.text,
                ),
              );
            }
            if (context.mounted) {
              // userAttempt(context: context);
              var p = Provider.of<ChatHistoryProvider>(context, listen: false);
              p.isFirst = true;
            }
          } else {
            AppConstants.getToast(message: response.data["message"].toString());
            if (isDiscover) {
              _chatList.add(
                UserChatModel(
                  isUser: false,
                  message: response.data["message"].toString(),
                  chatType: ChatType.text,
                ),
              );
            }
            // if (context.mounted) {
            // userAttempt(context: context);
            // }
          }
        } catch (e) {
          AppConstants.getToast(
              message: LocalizationManager().translate('SomethingWentWrong'));
          loadingStatus = AppLoadingStatus.error;
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  AppLoadingStatus suggestionLoadingStatus = AppLoadingStatus.none;

  Future<ApiResponse> generateSuggestions({
    required BuildContext context,
    required String content,
    int? imageKey,
  }) async {
    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      Map<String, dynamic> postBody = {
        'question': content,
        'img_key': imageKey ?? 0
      };

      suggestionLoadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl).post(
        endpoint: "generateSuggestions",
        token: authToken,
        body: postBody,
      );
      suggestionLoadingStatus = response.appLoadingStatus;
      if (suggestionLoadingStatus == AppLoadingStatus.success) {
        try {
          if (response.data["status"].toString() == "200") {
            // suggestionList.clear();

            //for suggestion
            try {
              dynamic list = response.data["data"];

              if (list is List) {
                // Handle array
                //store the value to the list
                list.map((e) => suggestionList.add(e.toString())).toList();
              } else if (list is Map) {
                // Handle object
                list.forEach((key, value) {
                  //store the value to the list
                  suggestionList.add(value.toString());
                });
              }

              // suggestionList = list;
            } catch (e) {
              log("error $e");
              suggestionList.clear();
            }
          } else {
            // AppConstants.getToast(message: response.data["message"].toString());
          }
        } catch (e) {
          // AppConstants.getToast(message: LocalizationManager().translate('SomethingWentWrong'));
          suggestionLoadingStatus = AppLoadingStatus.error;
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  AppLoadingStatus questionTitleLoadingStatus = AppLoadingStatus.none;

  Future<ApiResponse> createQuestionTitle({
    required BuildContext context,
    required String question,
    required String tabId,
    required String historyId,
  }) async {
    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      Map<String, dynamic> postBody = {
        'question': question,
        'tab_id': tabId,
        'history_id': historyId,
      };

      questionTitleLoadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl).post(
        endpoint: "create_question_title",
        token: authToken,
        body: postBody,
      );
      questionTitleLoadingStatus = response.appLoadingStatus;
      if (questionTitleLoadingStatus == AppLoadingStatus.success) {
        try {
          if (response.data["status"].toString() == "200") {
            // AppConstants.getToast(message: response.data["message"].toString());
          } else {
            // AppConstants.getToast(message: response.data["message"].toString());
          }
        } catch (e) {
          AppConstants.getToast(
              message: LocalizationManager().translate('SomethingWentWrong'));
          questionTitleLoadingStatus = AppLoadingStatus.error;
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  final Map<String, dynamic> _map = {
    'question': "",
  };

  Map<String, dynamic> get postBody => _map;

  setKey({required String key, required dynamic value}) {
    _map[key] = value;
  }

  //made a chat list for discover
  final List<UserChatModel> _chatList = [
    // UserChatModel(
    //     isUser: false,
    //     message: LocalizationManager().translate('HowCanIHelpYouToday'),
    //     chatType: ChatType.text,
    // ),
  ];

  List<UserChatModel> get chatList => _chatList;

  //insert new message
  setNewChat(
      {required String message, required bool isUser, bool? isAlreadyChat}) {
    _chatList.add(UserChatModel(
        isUser: isUser,
        message: message,
        chatType: ChatType.text, //now fixed
        isAlreadyChat: isAlreadyChat));
    notifyListeners();
  }

  clearResponse() {
    _chatResponse = null;
  }

  clearAttempt() {
    // _attemptModel = AttemptModel();
  }

  clearMap() {
    _map.clear();
    setKey(key: 'question', value: '');
  }

  clearChat() {
    _chatList.clear();
    suggestionList.clear();
  }

  clearChat1() {
    _chatList.clear();
    suggestionList.clear();
    notifyListeners();
  }
}
