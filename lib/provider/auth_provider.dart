import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/helper/check_network.dart';
import 'package:nabgh_app/helper/sp_helper.dart';
import 'package:nabgh_app/models/version_model.dart';
import 'package:nabgh_app/pages/auth_page/login_page.dart';
import 'package:nabgh_app/pages/auth_page/reset_password_page.dart';
import 'package:nabgh_app/pages/main_screen/main_screen.dart';
import 'package:nabgh_app/pages/splash_screen/app_update_modal.dart';
import 'package:nabgh_app/pages/splash_screen/feature_showcase_papge.dart';
import 'package:nabgh_app/provider/discover_provider.dart';
import 'package:nabgh_app/provider/search_provider.dart';
import 'package:nabgh_app/router.dart';
import 'package:nabgh_app/service/api_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../change_language/language_helper.dart';
import '../helper/auth_helperr.dart';
import '../models/model/user_detail_model.dart';
import '../pages/auth_page/forgot_pin_page.dart';
import '../pages/auth_page/register_pin_page.dart';
import '../widget/app_loadig_indicator.dart';
import 'chat_history_provider.dart';

class AuthenticateProvider with ChangeNotifier {
  AuthenticateProvider() {
    loadingStatus == AppLoadingStatus.none;
    notifyListeners();
  }

  UserDetailModel? userDetail;
  AppLoadingStatus loadingStatus = AppLoadingStatus.none;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<String?> getDeviceIdentifier() async {
    String? deviceIdentifier;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor!;
    }
    // print("deviceIdentifier $deviceIdentifier"); //0EE4D13B-F145-4825-8887-F9B1C1B44BB9 // TP1A.220905.001
    return deviceIdentifier;
  }

  Future<int> getAppVersion() async {
    String? appVersion;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    log("somen ${version.runtimeType}");

    if (Platform.isAndroid) {
      appVersion = version.replaceAll('.', '');
    } else if (Platform.isIOS) {
      appVersion = version.replaceAll('.', '');
    }
    // print("deviceIdentifier $deviceIdentifier"); //0EE4D13B-F145-4825-8887-F9B1C1B44BB9 // TP1A.220905.001
    return int.parse(appVersion!);
  }

  goToNextPage({required BuildContext buildContext}) async {

    await Future.delayed(const Duration(seconds: 3));
    bool userExist = await AuthHelper.isUserExist();
    if (userExist) {
      Navigator.of(buildContext)
          .pushReplacementNamed(MainScreen.routeName, arguments: 1);
    } else {
      Navigator.of(buildContext)
          .pushReplacement(MaterialPageRoute(builder: (builder) {
        return const FeatureShowCasePage();
      }));
    }

  }

  Future<ApiResponse> getVersion({required BuildContext buildContext}) async {
    late ApiResponse response;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version.replaceAll('.', '');

    if (await CheckInternet().checkConnectivity()) {
      // String? authToken = await SpHelper.loadString(SpKey.authToken);
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();
      response = await ApiService(AppKey.baseUrl)
          .get(endpoint: "version");
      loadingStatus = response.appLoadingStatus;

      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {

          var versionModel = VersionModel.fromJson(response.data);

          if(versionModel.data != null) {
            if (Platform.isAndroid) {
              var androidVersion = versionModel.data!.androidVersion!.replaceAll('.', '');
              // print("somen ${version}");
              // print("somen ${androidVersion}");
              if (int.parse(androidVersion) > int.parse(version)) {
                showDialog<void>(
                  context: buildContext,
                  barrierDismissible: false,
                  builder: (BuildContext _) => const AppUpdateModal(),
                );
              } else {
                goToNextPage(buildContext: buildContext);
              }
            } else {
              var iosVersion = versionModel.data!.iosVersion!.replaceAll('.', '');
              // print("somen ${version}");
              // print("somen ${iosVersion}");
              if (int.parse(iosVersion) > int.parse(version)) {
                showDialog<void>(
                  context: buildContext,
                  barrierDismissible: false,
                  builder: (BuildContext _) => const AppUpdateModal(),
                );
              } else {
                goToNextPage(buildContext: buildContext);
              }
            }
          }
        }
      } else {
        if (response.data["status"].toString() == "401") {
          await SpHelper.clearStorage();
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            LoginPage.routeName,
                (route) => false,
          );
          AppConstants.getToast(
              message: LocalizationManager().translate('sessionExpired'));
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }

    return response;
  }

  void rateUs({required BuildContext buildContext}) async {
    if (Platform.isAndroid) {
      try {
        await launchUrl(Uri.parse(AppKey.androidAppUrl), mode: LaunchMode.externalApplication);
      } catch (e) {
        AppConstants.getToast(
            message:
            LocalizationManager().translate('openPlayStore'));
      }
    } else {
      try {
        await launchUrl(Uri.parse(AppKey.iosAppUrl), mode: LaunchMode.externalApplication);
      } catch (e) {
        AppConstants.getToast(
            message:
            LocalizationManager().translate('openAppStore'));
      }

    }
  }


  Future login(
      {required BuildContext context,
      required bool social,
      required Map<String, dynamic> map}) async {
    if (await CheckInternet().checkConnectivity()) {
      // print("deviceIdentifier ${await getDeviceIdentifier()}");
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();
      var fcmToken = await SpHelper.loadString(SpKey.FCMtoken);
      Map<String, dynamic> postBody = {
        "email": emailController.text,
        "password": passwordController.text,

        /// todo: replace with fcm id
        "device_token": fcmToken ?? "",
        "device_id": await getDeviceIdentifier(),
      };

      ApiResponse response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "login", body: social ? map : postBody);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {


          await SpHelper.saveString(
              SpKey.authToken, response.data["data"]["token"]);

          await SpHelper.saveString(
              SpKey.mainUserId, response.data["user"]['id'].toString());

          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            MainScreen.routeName,
            (route) => false,
            arguments: 1,
          );


          clearController();
          if (context.mounted) {
            var p = Provider.of<ChatHistoryProvider>(context, listen: false);
            p.isFirst = true;
          }
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
      }
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }

    notifyListeners();
  }

  Future signUp(
      {required BuildContext context,
      required bool social,
      required Map<String, dynamic> map}) async {
    if (await CheckInternet().checkConnectivity()) {
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();
      var fcmToken = await SpHelper.loadString(SpKey.FCMtoken);
      Map<String, dynamic> postBody = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),

        /// todo: replace with fcm id
        "device_token": fcmToken ?? "",
        "device_id": await getDeviceIdentifier(),
      };

      // print("somen $social");
      // print("somen $map");

      ApiResponse response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "register", body: social ? map : postBody);
      loadingStatus = response.appLoadingStatus;
      print("ApiResponse $response");
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          // await SpHelper.saveString(
          //     SpKey.authToken, response.data["data"]["token"]);
          // navigatorKey.currentState?.pushNamedAndRemoveUntil(
          //     MainScreen.routeName, (route) => false,
          //     arguments: 1);
          // clearController();
          navigatorKey.currentState?.pushNamed(
            RegisterPinInputPage.routeName,
          );

          if (context.mounted) {
            var p = Provider.of<ChatHistoryProvider>(context, listen: false);
            p.isFirst = true;
          }
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
  }

  Future<ApiResponse> verifyEmailOtp(
      {required BuildContext context, required String otp}) async {
    late ApiResponse response;

    if (await CheckInternet().checkConnectivity()) {
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();
      Map<String, dynamic> postBody = {
        "email": emailController.text,
        "otp": otp,
      };
      response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "reg-match-otp", body: postBody);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          // await SpHelper.saveString(
          //     SpKey.userId, response.data["user"]["id"].toString());
          // navigatorKey.currentState
          //     ?.pushReplacementNamed(PasswordResetPage.routeName);

          await SpHelper.saveString(
              SpKey.authToken, response.data["data"]["token"]);

          await SpHelper.saveString(
              SpKey.mainUserId, response.data["user"]['id'].toString());

          navigatorKey.currentState?.pushNamedAndRemoveUntil(
              MainScreen.routeName, (route) => false,
              arguments: 1);
          clearController();
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  Future forgotPassword(
      {required BuildContext context, required bool navigate}) async {
    if (await CheckInternet().checkConnectivity()) {
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();
      Map<String, dynamic> postBody = {
        "email": emailController.text.trim(),
      };

      ApiResponse response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "forgot-password", body: postBody);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          if (navigate) {
            navigatorKey.currentState?.pushNamed(ForgotPinInputPage.routeName);
          }
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
  }

  Future<ApiResponse> verifyOtp(
      {required BuildContext context, required String otp}) async {
    late ApiResponse response;

    if (await CheckInternet().checkConnectivity()) {
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();
      Map<String, dynamic> postBody = {
        "email": emailController.text,
        "otp": otp,
      };
      response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "match-otp", body: postBody);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          await SpHelper.saveString(
              SpKey.userId, response.data["user"]["id"].toString());
          navigatorKey.currentState
              ?.pushReplacementNamed(PasswordResetPage.routeName);
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
    return response;
  }

  Future resetPassword({required BuildContext context}) async {
    if (await CheckInternet().checkConnectivity()) {
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      String? userId = await SpHelper.loadString(SpKey.userId);
      if (userId == null) {
        AppConstants.getToast(
            message: LocalizationManager().translate('SomethingWentWrong'));
        loadingStatus = AppLoadingStatus.none;
        notifyListeners();
        return;
      }
      Map<String, dynamic> postBody = {
        "user_id": int.parse(userId),
        "password": passwordController.text,
        "confirm_password": confirmPasswordController.text
      };
      ApiResponse response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "reset-password", body: postBody);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            LoginPage.routeName,
            (route) => false,
          );
          clearController();
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
  }

  Future getUser() async {
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);
      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();
      log("authToken $authToken");
      if (authToken == null) {
        loadingStatus = AppLoadingStatus.success;
        userDetail = null;
        notifyListeners();
        return;
      }
      ApiResponse response = await ApiService(AppKey.baseUrl)
          .get(endpoint: "user-profile", token: authToken);
      loadingStatus = response.appLoadingStatus;

      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          userDetail = UserDetailModel.fromJson(response.data);
          if (userDetail != null && userDetail!.data != null) {
            await SpHelper.saveString(
                SpKey.userModel, userDetail!.data!.model.toString());
          }
        }
      } else {
        if (response.data["status"].toString() == "401") {
          await SpHelper.clearStorage();
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            LoginPage.routeName,
            (route) => false,
          );
          AppConstants.getToast(
              message: LocalizationManager().translate('sessionExpired'));
        }
      }
      notifyListeners();
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
  }

  Future logOut({required BuildContext context}) async {
    if (await CheckInternet().checkConnectivity()) {
      if (context.mounted) {
        showDialog(
            context: context, builder: (builder) => AppLoadingIndicator());
      }
      String? token = await SpHelper.loadString(SpKey.authToken);
      if (token == null) {
        AppConstants.getToast(
            message: LocalizationManager().translate('SomethingWentWrong'));
        navigatorKey.currentState!.pop();
        return;
      }
      ApiResponse response = await ApiService(AppKey.baseUrl)
          .get(endpoint: "logout", token: token);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          if (context.mounted) {
            var pChatHistory =
                Provider.of<ChatHistoryProvider>(context, listen: false);
            var pDiscover =
                Provider.of<DiscoverProvider>(context, listen: false);
            var pSearch = Provider.of<SearchProvider>(context, listen: false);
            pChatHistory.isFirst = true;
            pDiscover.isFirst = true;
            pSearch.isFirst = true;
          }

          await SpHelper.clearStorage();
          await SpHelper.saveBool(SpKey.tutorialShowed, true);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
              (route) => false);
          // navigatorKey.currentState!.pushNamedAndRemoveUntil(
          //   LoginPage.routeName,
          //   (route) => false,
          // );
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
        navigatorKey.currentState!.pop();
      }
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
  }

  Future deleteAccount({required BuildContext context}) async {
    if (await CheckInternet().checkConnectivity()) {
      if (context.mounted) {
        showDialog(
            context: context, builder: (builder) => AppLoadingIndicator());
      }
      String? token = await SpHelper.loadString(SpKey.authToken);
      // print("tokken $token");
      if (token == null) {
        AppConstants.getToast(
            message: LocalizationManager().translate('SomethingWentWrong'));
        navigatorKey.currentState!.pop();
        return;
      }
      ApiResponse response = await ApiService(AppKey.baseUrl)
          .get(endpoint: "delete-account", token: token);
      loadingStatus = response.appLoadingStatus;
      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          if (context.mounted) {
            var pChatHistory =
                Provider.of<ChatHistoryProvider>(context, listen: false);
            var pDiscover =
                Provider.of<DiscoverProvider>(context, listen: false);
            var pSearch = Provider.of<SearchProvider>(context, listen: false);
            pChatHistory.isFirst = true;
            pDiscover.isFirst = true;
            pSearch.isFirst = true;
          }

          await SpHelper.clearStorage();
          await SpHelper.saveBool(SpKey.tutorialShowed, true);

          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            LoginPage.routeName,
            (route) => false,
          );
        } else {
          navigatorKey.currentState!.pop();
        }
        AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ??
                LocalizationManager().translate('SomethingWentWrong'));
        navigatorKey.currentState!.pop();
      }
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('checkInternet'));
    }
  }

  void clearController() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  String? validateEmail() {
    if (emailController.text.trim().isEmpty) {
      return LocalizationManager().translate('emailEmpty');
    }

    if (!AuthHelper.isEmailValid(email: emailController.text.trim())) {
      return LocalizationManager().translate('validEmail');
    }

    return null;
  }

  String? validatePassword() {
    if (passwordController.text.trim().isEmpty) {
      return LocalizationManager().translate('passwordEmpty');
    }

    return null;
  }

  // validateLogin(BuildContext context) {
  //   if (emailController.text.trim().isEmpty) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('emailEmpty'));
  //   }
  //
  //   if (!AuthHelper.isEmailValid(email: emailController.text.trim())) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('validEmail'));
  //   }
  //   if (passwordController.text.trim().isEmpty) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('passwordEmpty'));
  //   }
  //
  //   login(context: context,social: false, map: {});
  // }

  String? validateName() {
    if (nameController.text.trim().isEmpty) {
      return LocalizationManager().translate('EnterName');
    }

    return null;
  }

  String? validateNewPassword() {
    var password = passwordController.text.trim();

    // Check if the password is empty
    if (password.isEmpty) {
      return LocalizationManager().translate('passwordEmpty');
    }

    //password should be "Example@123"
    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password) ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return LocalizationManager().translate('passwordCondition');
    }

    // // Check if the password contains at least 8 character.
    // if (password.length < 8) {
    //   return LocalizationManager().translate('passwordCharLength');
    // }
    // // Check if the password contains at least one uppercase letter
    // if (!RegExp(r'[A-Z]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainUppercase');
    // }
    //
    // // Check if the password contains at least one lowercase letter
    // if (!RegExp(r'[a-z]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainLowercase');
    // }
    //
    // // Check if the password contains at least one digit
    // if (!RegExp(r'[0-9]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainDigit');
    // }
    //
    // // Check if the password contains at least one special character
    // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainSpecChar');
    // }

    return null;
  }

  String? validateConfirmPassword() {
    var password = confirmPasswordController.text.trim();

    // Check if the password is empty
    if (password.isEmpty) {
      return LocalizationManager().translate('confPasswordEmpty');
    }
    // // Check if the password contains at least 8 character.
    // if (password.length < 8) {
    //   return LocalizationManager().translate('passwordCharLength');
    // }
    // // Check if the password contains at least one uppercase letter
    // if (!RegExp(r'[A-Z]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainUppercase');
    // }
    //
    // // Check if the password contains at least one lowercase letter
    // if (!RegExp(r'[a-z]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainLowercase');
    // }
    //
    // // Check if the password contains at least one digit
    // if (!RegExp(r'[0-9]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainDigit');
    // }
    //
    // // Check if the password contains at least one special character
    // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    //   return LocalizationManager().translate('passContainSpecChar');
    // }

    //password should be "Example@123"
    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password) ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return LocalizationManager().translate('passwordCondition');
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      return LocalizationManager().translate('passMustSame');
    }

    return null;
  }

  // validateSignUp(BuildContext context) {
  //   if (nameController.text.trim().isEmpty) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('EnterName'));
  //   }
  //   if (emailController.text.trim().isEmpty) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('emailEmpty'));
  //   }
  //   if (!AuthHelper.isEmailValid(email: emailController.text.trim())) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('validEmail'));
  //   }
  //   if (passwordController.text.trim().isEmpty) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('passwordEmpty'));
  //   }
  //   if (passwordController.text.trim().length < 8) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('passwordCharLength'));
  //   }
  //   if (!AuthHelper.isPasswordValid(password: passwordController.text.trim())) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('enterStrongPassword'));
  //   }
  //   if (confirmPasswordController.text.trim().isEmpty) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('confPasswordEmpty'));
  //   }
  //   if (passwordController.text.trim() !=
  //       confirmPasswordController.text.trim()) {
  //     return AppConstants.getToast(
  //         message: LocalizationManager().translate('PasswordMustBeSame'));
  //   }
  //
  //   signUp(context: context,social: false, map: {});
  // }

  validateForgotEmail(BuildContext context) {
    if (emailController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('emailEmpty'));
    }
    if (!AuthHelper.isEmailValid(email: emailController.text.trim())) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('validEmail'));
    }

    forgotPassword(context: context, navigate: true);
  }

  validateResetPassword(BuildContext context) {
    if (passwordController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('passwordNewEmpty'));
    }
    if (passwordController.text.trim().length < 8) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('passwordCharLength'));
    }
    if (!AuthHelper.isPasswordValid(password: passwordController.text.trim())) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('enterStrongPassword'));
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('confPasswordEmpty'));
    }
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      return AppConstants.getToast(
          message: LocalizationManager().translate('PasswordMustBeSame'));
    }

    resetPassword(context: context);
  }
}


class AppUpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String newVersion;
  final String updateDescription;
  final Function onLaterPressed;
  final Function onUpdatePressed;

  const AppUpdateDialog({super.key,
    required this.currentVersion,
    required this.newVersion,
    required this.updateDescription,
    required this.onLaterPressed,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Version Available'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Current Version: $currentVersion'),
          SizedBox(height: 8),
          Text('New Version: $newVersion'),
          SizedBox(height: 8),
          Text(updateDescription),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: onLaterPressed as void Function()?,
          child: Text('Later'),
        ),
        ElevatedButton(
          onPressed: onUpdatePressed as void Function()?,
          child: Text('Update Now'),
        ),
      ],
    );
  }
}
