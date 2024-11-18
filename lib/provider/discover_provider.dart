import 'package:flutter/cupertino.dart';
import 'package:nabgh_app/models/model/category_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../change_language/language_helper.dart';
import '../constatns/app_constants.dart';
import '../constatns/app_key.dart';
import '../enum/app_loading_staus.dart';
import '../helper/check_network.dart';
import '../helper/sp_helper.dart';
import '../models/model/sub_child_discover_model.dart';
import '../models/model/sub_discover_model.dart';
import '../service/api_service.dart';

class DiscoverProvider with ChangeNotifier{
  DiscoverProvider(){
    loadingStatus == AppLoadingStatus.none;
    notifyListeners();
  }

  bool isFirst = true;

  final RefreshController refreshDiscoverController =
  RefreshController(initialRefresh: false);

  final RefreshController subCatRefreshController =
  RefreshController(initialRefresh: false);

  AppLoadingStatus loadingStatus = AppLoadingStatus.none;

  AppLoadingStatus subLoadingStatus = AppLoadingStatus.none;

  List<CategoryModel> categoryList = [];

  List<SubChildDiscoverModel> subCategoryList = [];
  List<List<SubDiscoverModel>> subCategoryList1 = [];

  Future getCategory() async {

    if (await CheckInternet().checkConnectivity()) {

    String? authToken = await SpHelper.loadString(SpKey.authToken);

    categoryList.clear();
    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    ApiResponse response = await ApiService(AppKey.baseUrl)
        .get(endpoint: "category", token: authToken);
    loadingStatus = response.appLoadingStatus;

    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        response.data['data'].map((json) {
          var categoryModel = CategoryModel.fromJson(json);
          categoryList.add(categoryModel);
        }).toList();

        isFirst = false;
      }
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
    } else {
      AppConstants.getToast(message: LocalizationManager().translate('checkInternet'));
    }
  }

  Future<ApiResponse> getSubChildCategory({required categoryId}) async {
    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
    String? authToken = await SpHelper.loadString(SpKey.authToken);

    subCategoryList.clear();
    subLoadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    Map<String, dynamic> postBody = {
      'sub_discover_id': categoryId
    };

    response = await ApiService(AppKey.baseUrl)
        .post(endpoint: "child_sub_discover", body: postBody, token: authToken);
    subLoadingStatus = response.appLoadingStatus;

    if (subLoadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        response.data['data'].map((json) {
          var subDiscoverModel = SubChildDiscoverModel.fromJson(json);
          subCategoryList.add(subDiscoverModel);
        }).toList();
      }
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
    } else {
      AppConstants.getToast(message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  clearModel() {
    categoryList.clear();
    subCategoryList.clear();
    subCategoryList1.clear();
  }

}