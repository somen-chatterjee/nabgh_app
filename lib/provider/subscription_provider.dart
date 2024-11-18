import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../change_language/language_helper.dart';
import '../constatns/app_constants.dart';
import '../constatns/app_key.dart';
import '../enum/app_loading_staus.dart';
import '../helper/check_network.dart';
import '../helper/sp_helper.dart';
import '../service/api_service.dart';

class SubscriptionProvider with ChangeNotifier {
  SubscriptionProvider() {
    loadingStatus = AppLoadingStatus.none;
    notifyListeners();
  }

  AppLoadingStatus loadingStatus = AppLoadingStatus.none;

  String? _chatResponse;

  String? get chatResponse => _chatResponse;

  Future<ApiResponse> buyPlan(
      {required BuildContext context,
      required Map<String, dynamic> postBody,}) async {
    late ApiResponse response;

    // print("somen $postBody");
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "buy_plan", token: authToken, body: postBody);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {

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

  Future<ApiResponse> cancelPlan(
      {required BuildContext context}) async {
    late ApiResponse response;

    // print("somen $postBody");
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "cancle_plan", token: authToken, body: null,);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          AppConstants.getToast(message: response.data["message"].toString());
          Navigator.pop(context);
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

}
