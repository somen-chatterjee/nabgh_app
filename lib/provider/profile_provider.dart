import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/helper/auth_helperr.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../constatns/app_constants.dart';
import '../constatns/app_key.dart';
import '../enum/app_loading_staus.dart';
import '../models/model/faq_model.dart';
import '../models/model/my_plan_model.dart';
import '../models/model/privacy_policy_model.dart';
import '../models/model/subscription_plan_model.dart';
import '../models/model/term_condition_model.dart';
import '../pages/main_screen/subscription_page/subscription_page.dart';
import '../router.dart';
import '../service/api_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider() {
    loadingStatus = AppLoadingStatus.none;
  }

  AppLoadingStatus loadingStatus = AppLoadingStatus.none;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController passwordConfirmationController =
  TextEditingController();
  PrivacyPolicyModel privacyPolicyModel = PrivacyPolicyModel();
  TermConditionModel termConditionModel = TermConditionModel();
  List<FAQModel> faqList = [];
  List<SubscriptionPlanModel> subscriptionPlanList = [];
  MyPlanModel myPlanModel = MyPlanModel();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController messageController = TextEditingController();


  editProfile(
      {required String name,
      required String email,
      required String? imagePath, required BuildContext context}) async {
    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();
    Map<String, dynamic> map = {
      "email": email,
      "name": name,
    };

    var formData = FormData.fromMap(map);

    if (imagePath != null) {
      formData.files.add(MapEntry(
        "profile",
        await MultipartFile.fromFile(
          imagePath,
          filename: "profile",
        ),
      ));
    }

    String? token = await AuthHelper.getToken();

    ApiResponse response = await ApiService(AppKey.baseUrl)
        .post(endpoint: "edit-profile", body: formData, token: token);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        if (context.mounted) {
          var authProvider = Provider.of<AuthenticateProvider>(
              navigatorKey.currentState!.context,
              listen: false);
          await authProvider.getUser();
          navigatorKey.currentState?.pop();
        }
      }
      AppConstants.getToast(message: response.data["message"] ?? "");
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
  }

  Future changePassword() async {
    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();
    Map<String, dynamic> postBody = {
      "current_password": currentPasswordController.text.trim(),
      "new_password": passwordController.text.trim(),
    };

    String? token = await AuthHelper.getToken();
    ApiResponse response = await ApiService(AppKey.baseUrl)
        .post(endpoint: "change-password", body: postBody, token: token);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        navigatorKey.currentState?.pop();
      }
      AppConstants.getToast(message: response.data["message"] ?? "");
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
  }

  Future getPrivacyPolicy() async {

    String? token = await AuthHelper.getToken();

    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    ApiResponse response = await ApiService(AppKey.baseUrl)
        .get(endpoint: "privacy-policy", token: token);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        // navigatorKey.currentState?.pop();
        // print("response ${response.data['data'].runtimeType}");
        privacyPolicyModel = PrivacyPolicyModel.fromJson(response.data['data']);
      }
      // AppConstants.getToast(message: response.data["message"] ?? "");
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
  }

  Future getTermsConditions() async {

    String? token = await AuthHelper.getToken();

    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    ApiResponse response = await ApiService(AppKey.baseUrl)
        .get(endpoint: "terms-conditions", token: token);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        // navigatorKey.currentState?.pop();
        // print("response ${response.data['data'].runtimeType}");
        termConditionModel = TermConditionModel.fromJson(response.data['data']);
      }
      // AppConstants.getToast(message: response.data["message"] ?? "");
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
  }

  Future getFaq() async {

    String? token = await AuthHelper.getToken();

    faqList.clear();
    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    ApiResponse response = await ApiService(AppKey.baseUrl)
        .get(endpoint: "faq", token: token);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        // navigatorKey.currentState?.pop();

        response.data['data'].map((json) => faqList.add(FAQModel.fromJson(json))).toList();

      }
      // AppConstants.getToast(message: response.data["message"] ?? "");
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
  }

  Future getSubscriptionPlan() async {

    String? token = await AuthHelper.getToken();

    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    ApiResponse response = await ApiService(AppKey.baseUrl)
        .get(endpoint: "subscription_plan", token: token);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        subscriptionPlanList.clear();
        // navigatorKey.currentState?.pop();

        response.data['data'].map((json) => subscriptionPlanList.add(SubscriptionPlanModel.fromJson(json))).toList();

      }
      // AppConstants.getToast(message: response.data["message"] ?? "");
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
  }

  Future<ApiResponse> getMyPlan() async {

    String? token = await AuthHelper.getToken();

    myPlanModel = MyPlanModel();
    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    late ApiResponse response;

    response = await ApiService(AppKey.baseUrl)
        .get(endpoint: "my_plan", token: token);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {
        // navigatorKey.currentState?.pop();

        if(response.data["data"] != null) {
          myPlanModel = MyPlanModel.fromJson(response.data["data"]);
        } else {
          myPlanModel = MyPlanModel();
        }
      } else {
        AppConstants.getToast(message: response.data["message"] ?? "");
      }
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
    return response;
  }

  Future help({required Map<String, dynamic> postBody}) async {

    String? token = await AuthHelper.getToken();

    loadingStatus = AppLoadingStatus.loading;
    notifyListeners();

    ApiResponse response = await ApiService(AppKey.baseUrl)
        .post(endpoint: "help", token: token,body: postBody);
    loadingStatus = response.appLoadingStatus;
    if (loadingStatus == AppLoadingStatus.success) {
      if (response.data["status"].toString() == "200") {

        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
              response.data["message"] ?? "",
            ),
          ),
        );

        // AppConstants.getToast(message: response.data["message"] ?? "");
        nameController.clear();
        emailController.clear();
        messageController.clear();
        // navigatorKey.currentState?.pop();

      }else{
        AppConstants.getToast(message: response.data["message"] ?? "");
      }
    } else {
      AppConstants.getToast(
          message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
    }
    notifyListeners();
  }

  String? validatePassword() {
    if (currentPasswordController.text.trim().isEmpty) {
      return LocalizationManager().translate('currentPasswordEmpty');
    }

    return null;
  }

  String? validateNewPassword() {
    var password = passwordController.text.trim();
    if (password.isEmpty) {
      return LocalizationManager().translate('passwordNewEmpty');
    }
    // Check if the password contains at least 8 character.
    if (password.length < 8) {
      return LocalizationManager().translate('passwordCharLength');
    }
    // Check if the password contains at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return LocalizationManager().translate('passContainUppercase');
    }

    // Check if the password contains at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return LocalizationManager().translate('passContainLowercase');
    }

    // Check if the password contains at least one digit
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return LocalizationManager().translate('passContainDigit');
    }

    // Check if the password contains at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return LocalizationManager().translate('passContainSpecChar');
    }
    return null;
  }

  String? validateConfirmPassword() {
    var password = passwordConfirmationController.text.trim();

    // Check if the password is empty
    if (password.isEmpty) {
      return LocalizationManager().translate('confPasswordEmpty');
    }
    // Check if the password contains at least 8 character.
    if (password.length < 8) {
      return LocalizationManager().translate('passwordCharLength');
    }
    // Check if the password contains at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return LocalizationManager().translate('passContainUppercase');
    }

    // Check if the password contains at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return LocalizationManager().translate('passContainLowercase');
    }

    // Check if the password contains at least one digit
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return LocalizationManager().translate('passContainDigit');
    }

    // Check if the password contains at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return LocalizationManager().translate('passContainSpecChar');
    }

    if (passwordController.text.trim() !=
        passwordConfirmationController.text.trim()) {
      return LocalizationManager().translate('passMustSame');
    }

    return null;
  }


  validateChangePassword() {
    if (currentPasswordController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('currentPasswordEmpty'));
    }
    if (passwordController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('passwordNewEmpty'));
    }
    if (passwordController.text.trim().length < 8) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('passwordCharLength'));
    }
    if (!AuthHelper.isPasswordValid(
            password: passwordController.text.trim())) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('PleaseNewStrongPassword'));
    }
    if (passwordConfirmationController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('confPasswordEmpty'));
    }
    if (passwordController.text.trim() !=
        passwordConfirmationController.text.trim()) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('newAndConfirmSame'));
    }

    changePassword();
  }

  validateHelp(){
    if (nameController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('nameHint'));
    }
    if (emailController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('emailHint'));
    }
    if (!AuthHelper.isEmailValid(email: emailController.text.trim())) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('validEmail'));
    }
    if (messageController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('messageHint'));
    }

    Map<String, dynamic> postBody = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "message": messageController.text.trim(),
    };

    help(postBody: postBody);

  }

  clearModels() {
    privacyPolicyModel = PrivacyPolicyModel();
    termConditionModel = TermConditionModel();
    myPlanModel = MyPlanModel();
    faqList.clear();
    subscriptionPlanList.clear();
    currentPasswordController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    nameController.clear();
    emailController.clear();
    messageController.clear();
  }
}
