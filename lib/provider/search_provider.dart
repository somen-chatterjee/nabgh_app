import 'package:flutter/material.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../change_language/language_helper.dart';
import '../constatns/app_constants.dart';
import '../constatns/app_key.dart';
import '../enum/app_loading_staus.dart';
import '../helper/check_network.dart';
import '../helper/sp_helper.dart';
import '../models/model/suggestion_card_model.dart';
import '../models/model/suggestion_category_model.dart';
import '../models/model/suggestion_item_modal.dart';
import '../models/model/suggestion_sub_category_model.dart';
import '../pages/main_screen/search_page/suggestion_pages/business_plan_page.dart';
import '../pages/main_screen/search_page/suggestion_pages/competior_analysis_page.dart';
import '../pages/main_screen/search_page/suggestion_pages/default_suggestion_page.dart';
import '../pages/main_screen/search_page/suggestion_pages/interviewing_page.dart';
import '../pages/main_screen/search_page/suggestion_pages/language_translation_page.dart';
import '../pages/main_screen/search_page/suggestion_pages/meeting_summary.dart';
import '../pages/main_screen/search_page/suggestion_pages/proposals_for_clients.dart';
import '../pages/main_screen/search_page/suggestion_pages/sociial_content_page.dart';
import '../pages/main_screen/search_page/suggestion_pages/write_email_page.dart';
import '../router.dart';
import '../service/api_service.dart';
import '../widget/app_loadig_indicator.dart';

class SearchProvider with ChangeNotifier {
  SearchProvider() {
    loadingStatus == AppLoadingStatus.none;
    notifyListeners();
  }

  bool isFirst = true;

  final RefreshController refreshSearchController =
      RefreshController(initialRefresh: false);

  AppLoadingStatus loadingStatus = AppLoadingStatus.none;
  AppLoadingStatus suggestionLoadingStatus = AppLoadingStatus.none;

  List<SuggestionCategoryModel> suggestionCategoryList = [];
  List<SuggestionSubCategoryModel> suggestionSubCategoryList = [];

  List<SuggestionTagModel> allSuggestionCategoryList = [];

  List<SuggestionCardModel> allSuggestionList = [];

  SuggestionSubCategoryModel _suggestionSubCategoryModel =
      SuggestionSubCategoryModel();

  SuggestionSubCategoryModel get suggestionSubCategoryModel =>
      _suggestionSubCategoryModel;

  Future<ApiResponse> getSuggestionCategory({required BuildContext context, required bool isRefreshed}) async {

    late ApiResponse response;
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);

      suggestionCategoryList.clear();

      // if(isRefreshed){
        allSuggestionCategoryList.clear();
      // }

      loadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      response = await ApiService(AppKey.baseUrl)
          .get(endpoint: "suggestion_category", token: authToken);
      loadingStatus = response.appLoadingStatus;

      if (loadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          response.data['data'].map((json) {
            suggestionCategoryList.add(SuggestionCategoryModel.fromJson(json));

            allSuggestionCategoryList.add(
              SuggestionTagModel(
                title: SuggestionCategoryModel.fromJson(json).title!,
                // categorySuggestionList: SuggestionItem.mostlyUsed,
                categorySuggestionList: [],
              ),
            );
          }).toList();

          if (suggestionCategoryList.isNotEmpty) {
            if (context.mounted) {
              getSuggestion(
                context: context,
                categoryId: suggestionCategoryList[0].id!,
                index: 0,
                initial: true,
                isRefreshed: isRefreshed,
              );
            }
          }

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
    return response;
  }

  Future getSuggestion({
    required BuildContext context,
    required int categoryId,
    required int index,
    required bool initial,
    required bool isRefreshed
  }) async {
    var pDevice = Provider.of<AuthenticateProvider>(context, listen: false);
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);
      suggestionSubCategoryList.clear();
      suggestionLoadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      Map<String, dynamic> postBody = {
        "category": categoryId,
        "device_id": await pDevice.getDeviceIdentifier(),
      };
      // print("postBody $postBody");
      ApiResponse response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "suggestion", body: postBody, token: authToken);
      suggestionLoadingStatus = response.appLoadingStatus;
      if (suggestionLoadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          // if user refresh the list user need to load all data of categorySuggestionList
          if(isRefreshed) {
            allSuggestionCategoryList
                .elementAt(index)
                .categorySuggestionList
                .clear();
          }

          response.data['data'].map((json) {
            var suggestionSubCategoryModel =
                SuggestionSubCategoryModel.fromJson(json);

            // print("allSuggestionCategoryList ${suggestionSubCategoryModel.id} ${suggestionSubCategoryModel.title}");

            suggestionSubCategoryList.add(suggestionSubCategoryModel);

            allSuggestionCategoryList
                .elementAt(index)
                .categorySuggestionList
                .add(setDynamicTitle(
                  id: suggestionSubCategoryModel.id!,
                  title: suggestionSubCategoryModel.title!,
                  desc: suggestionSubCategoryModel.description!,
                  sendMsg: suggestionSubCategoryModel.sendMsg,
                ));
            // .add(SuggestionCardModel(
            //   onTap: () {},
            //   imgSrc: suggestionSubCategoryModel.image != null ? AppKey.baseUrlImg + suggestionSubCategoryModel.image!: null,
            //   title: suggestionSubCategoryModel.title!,
            //   subtitle: suggestionSubCategoryModel.description!,
            // ));
          }).toList();
        }
        // AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
      }
      notifyListeners();
    } else {
      if (!initial) {
        AppConstants.getToast(message: LocalizationManager().translate('checkInternet'));
      }
    }
  }

  AppLoadingStatus allSuggestionLoadingStatus = AppLoadingStatus.none;

  Future getAllSuggestion({
    required BuildContext context,
  }) async {
    if (await CheckInternet().checkConnectivity()) {
      String? authToken = await SpHelper.loadString(SpKey.authToken);
      allSuggestionLoadingStatus = AppLoadingStatus.loading;
      notifyListeners();

      allSuggestionList.clear();
      ApiResponse response = await ApiService(AppKey.baseUrl)
          .get(endpoint: "all_suggestion", token: authToken);
      allSuggestionLoadingStatus = response.appLoadingStatus;
      if (allSuggestionLoadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          response.data['data'].map((json) {
            // print("object $json");
            var suggestionSubCategoryModel =
                SuggestionSubCategoryModel.fromJson(json);

            // suggestionSubCategoryList.add(suggestionSubCategoryModel);

            // allSuggestionCategoryList
            //     .elementAt(index)
            //     .categorySuggestionList.add(setDynamicTitle(
            //   id: suggestionSubCategoryModel.id!,
            //   title: suggestionSubCategoryModel.title!,
            //   desc: suggestionSubCategoryModel.description!,
            // ));

            allSuggestionList.add(setDynamicTitle(
              id: suggestionSubCategoryModel.id!,
              title: suggestionSubCategoryModel.title!,
              desc: suggestionSubCategoryModel.description!,
              sendMsg: suggestionSubCategoryModel.sendMsg,
            ));
            // .add(SuggestionCardModel(
            //   onTap: () {},
            //   imgSrc: suggestionSubCategoryModel.image != null ? AppKey.baseUrlImg + suggestionSubCategoryModel.image!: null,
            //   title: suggestionSubCategoryModel.title!,
            //   subtitle: suggestionSubCategoryModel.description!,
            // ));
          }).toList();

          isFirst = false;
        }
        // AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
      }
      notifyListeners();
    }
  }

  //set model for the user
  Future setModel({
    required BuildContext context,
    required String model,
  }) async {
    if (await CheckInternet().checkConnectivity()) {
      if(context.mounted) {
        showDialog(
            context: context, builder: (builder) => AppLoadingIndicator());
      }

      String? authToken = await SpHelper.loadString(SpKey.authToken);

      notifyListeners();

      Map<String, dynamic> postBody = {
        "model": model,
      };
      // print("postBody $postBody");
      ApiResponse response = await ApiService(AppKey.baseUrl)
          .post(endpoint: "set_model", body: postBody, token: authToken);
      if (response.appLoadingStatus == AppLoadingStatus.success) {
        if (response.data["status"].toString() == "200") {
          var data = response.data['data'];
          if(data != null){
            await SpHelper.saveString(SpKey.userModel, response.data['data']['model'].toString());
          }
          // print("somen $v");
          navigatorKey.currentState!.pop();
        }
        // AppConstants.getToast(message: response.data["message"] ?? "");
      } else {
        AppConstants.getToast(
            message: response.message ?? LocalizationManager().translate('SomethingWentWrong'));
        navigatorKey.currentState!.pop();
      }
      notifyListeners();
    } else {
      AppConstants.getToast(message: LocalizationManager().translate('checkInternet'));
    }
  }

  final List<Color> _colorList = [
    Colors.indigoAccent.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.red.shade200,
    Colors.indigo.shade200,
    Colors.orange.shade200,
    Colors.teal.shade200,
    Colors.amber.shade200,
    Colors.brown.shade200,
    Colors.cyan.shade200,
    Colors.deepOrange.shade200,
    Colors.deepPurple.shade200,
    Colors.pink.shade200,
    Colors.lightBlue.shade200,
    const Color(0xffffb274),
    // Colors.lime.shade200,
    // Colors.pink.shade200,
    const Color(0xffc485de),
    const Color(0xffC3D9D5),
    // Colors.tealAccent.shade200,
    // Colors.yellowAccent.shade200,
    Colors.lightGreen.shade200, //
    Colors.cyanAccent.shade200,
    Colors.deepOrangeAccent.shade200,
    const Color(0xffDEFA8f),
    Colors.greenAccent.shade200,
    Colors.blue.shade200,
    Colors.lightBlueAccent.shade200,
    Colors.lightGreenAccent.shade200,
    Colors.orangeAccent.shade200,
    // Colors.pinkAccent.shade200,
    Colors.tealAccent.shade200,
    const Color(0xffa9e2ff),
    const Color(0xffF3D1E1),
    const Color(0xffff63cd),
    const Color(0xffadfa12),
    const Color(0xffF0E4C5),
    const Color(0xffffcdad),
    const Color(0xffb398ff),
    const Color(0xffffe3fe),
    const Color(0xffd7b3b3),
    const Color(0xffDEFA8F),
    const Color(0xffA2D9D0),
    const Color(0xffF1D4AF),
    const Color(0xffff67a4),
    const Color(0xffF4E5D4),
    const Color(0xffC8D7F1),
    const Color(0xff3dff43),
    const Color(0xffff9ed7),
    const Color(0xffD0E1F9),
    const Color(0xffDEFA8f),
    const Color(0xffDEFA8f),
    const Color(0xffDEFA8f),
    const Color(0xffDEFA8f),
  ];

  setDynamicTitle(
      {required int id, required String title, required String desc, required String? sendMsg}) {


    // print("somen id $id");
    SuggestionCardModel common = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/meeting_summary.png",
      color: _colorList[id],
    );

    SuggestionCardModel meetingSummary = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          MeetingSummeryPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/meeting_summary.png",
      color: _colorList[id],
    );

    SuggestionCardModel translation = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          LanguageTranslationPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      color: _colorList[id],
      imgSrc: "assets/suggestion/translation.png",
    );

    SuggestionCardModel email = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          WriteEmailPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      color: _colorList[id],
      imgSrc: "assets/suggestion/email.png",
    );

    SuggestionCardModel academicWriting = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/academic_writing.png",
      color: _colorList[id],
    );

    SuggestionCardModel grammar = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/grammar.png",
      color: _colorList[id],
    );

    SuggestionCardModel comedy = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/comedy.png",
      color: _colorList[id],
    );

    SuggestionCardModel lyrics = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/lyrics.png",
      color: _colorList[id],
    );

    SuggestionCardModel storyTelling = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/storytelling.png",
      color: _colorList[id],
    );

    SuggestionCardModel socialContent = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(SocialContentPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/social.png",
      color: _colorList[id],
    );

    SuggestionCardModel poem = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/poem.png",
      color: _colorList[id],
    );

    SuggestionCardModel letter = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/letter.png",
      color: _colorList[id],
    );

    SuggestionCardModel essayAssistance = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/email.png",
      color: _colorList[id],
    );

    SuggestionCardModel complaints = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/complaints.png",
      color: _colorList[id],
    );

    SuggestionCardModel businessPlan = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(BusinessPlanPage.routeName, arguments: title);

        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: title,
      imgSrc: "assets/suggestion/business_plan.png",
      color: _colorList[id],
    );

    SuggestionCardModel competitorAnalysis = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(CompetiorAnalysis.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/pie_chart.png",
      color: _colorList[id],
    );

    SuggestionCardModel interviewing = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(InterviewingPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/interviewing.png",
      color: _colorList[id],
    );

    SuggestionCardModel proposals = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          ProposalForClient.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/proposals_for_clients.png",
      color: _colorList[id],
    );

    /// Language tools

    SuggestionCardModel paraphrasing = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/paraphrasing.png",
      color: _colorList[id],
    );

    SuggestionCardModel summary = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/summary.png",
      color: _colorList[id],
    );

    SuggestionCardModel plagiarismChecker = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/plagiarism_checker.png",
      color: _colorList[id],
    );

    //health

    SuggestionCardModel symptomsChecker = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/symptoms_checker.png",
      color: _colorList[id],
    );

    SuggestionCardModel mentalHealth = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/mental_health.png",
      color: _colorList[id],
    );

    SuggestionCardModel fitness = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/fitness.png",
      color: _colorList[id],
    );

    SuggestionCardModel nutrition = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/ntrition.png",
      color: _colorList[id],
    );

    //education
    SuggestionCardModel mathSolver = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/maths.png",
      color: _colorList[id],
    );

    SuggestionCardModel homeworkHelper = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/maths.png",
      color: _colorList[id],
    );

    SuggestionCardModel history = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/history.png",
      color: _colorList[id],
    );

    SuggestionCardModel science = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/science.png",
      color: _colorList[id],
    );

    SuggestionCardModel islamics = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/islam.png",
      color: _colorList[id],
    );

    ///work list
    SuggestionCardModel cvBuilding = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/resume.png",
      color: _colorList[id],
    );

    SuggestionCardModel jobSearchStratigies = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/job.png",
      color: _colorList[id],
    );

    SuggestionCardModel conflictResolution = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/conflict.png",
      color: _colorList[id],
    );

    SuggestionCardModel management = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/management.png",
      color: _colorList[id],
    );

    ///family
    SuggestionCardModel parentingAdvice = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/parrenting.png",
      color: _colorList[id],
    );

    SuggestionCardModel bedtimeStories = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/storytelling.png",
      color: _colorList[id],
    );

    SuggestionCardModel chefNabigh = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/chef.png",
      color: _colorList[id],
    );

    SuggestionCardModel relationship = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/relationship.png",
      color: _colorList[id],
    );

    SuggestionCardModel familyBudgeting = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/budget.png",
      color: _colorList[id],
    );

    /// other list

    SuggestionCardModel passwordGenerator = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!
            .pushNamed(DefaultSuggestionPage.routeName, arguments: title);

        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/password.png",
      color: _colorList[id],
    );

    SuggestionCardModel dreamInterpreter = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );

        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/dream.png",
      color: _colorList[id],
    );

    SuggestionCardModel talkWithNabigh = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/talk_with_nabigh.png",
      color: _colorList[id],
    );

    SuggestionCardModel policiesProcedures = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/policy_procedure.png",
      color: _colorList[id],
    );

    SuggestionCardModel smartDeviceCare = SuggestionCardModel(
      onTap: () {
        navigatorKey.currentState!.pushNamed(
          DefaultSuggestionPage.routeName,
          arguments: title,
        );
        _suggestionSubCategoryModel.id = id;
        _suggestionSubCategoryModel.sendMsg = sendMsg;
      },
      title: title,
      subtitle: desc,
      imgSrc: "assets/suggestion/smart_device.png",
      color: _colorList[id],
    );

    ///mostly used
    if (id == 1) {
      return meetingSummary;
    }
    if (id == 2) {
      return translation;
    }
    if (id == 3) {
      return email;
    }
    if (id == 4) {
      return academicWriting;
    }
    if (id == 5) {
      return grammar;
    }

    ///Writing
    if (id == 5) {
      return grammar;
    }
    if (id == 6) {
      return comedy;
    }
    if (id == 7) {
      return lyrics;
    }
    if (id == 8) {
      return storyTelling;
    }
    if (id == 9) {
      return socialContent;
    }
    if (id == 10) {
      return poem;
    }
    if (id == 11) {
      return letter;
    }
    if (id == 12) {
      return essayAssistance;
    }
    if (id == 13) {
      return complaints;
    }

    ///Business
    if (id == 14) {
      return businessPlan;
    }
    if (id == 15) {
      return competitorAnalysis;
    }
    if (id == 16) {
      return interviewing;
    }
    if (id == 17) {
      return proposals;
    }

    ///language
    if (id == 18) {
      return paraphrasing;
    }
    if (id == 19) {
      return summary;
    }
    if (id == 20) {
      return plagiarismChecker;
    }

    ///health
    if (id == 21) {
      return symptomsChecker;
    }
    if (id == 22) {
      return mentalHealth;
    }
    if (id == 23) {
      return fitness;
    }
    if (id == 24) {
      return nutrition;
    }

    ///education
    if (id == 25) {
      return mathSolver;
    }
    if (id == 26) {
      return homeworkHelper;
    }
    if (id == 27) {
      return history;
    }
    if (id == 28) {
      return science;
    }
    if (id == 29) {
      return islamics;
    }

    ///work
    if (id == 30) {
      return cvBuilding;
    }
    if (id == 31) {
      return jobSearchStratigies;
    }
    if (id == 32) {
      return conflictResolution;
    }
    if (id == 33) {
      return management;
    }

    ///family
    if (id == 34) {
      return parentingAdvice;
    }
    if (id == 35) {
      return bedtimeStories;
    }
    if (id == 36) {
      return chefNabigh;
    }
    if (id == 37) {
      return relationship;
    }
    if (id == 38) {
      return familyBudgeting;
    }

    /// other list
    if (id == 39) {
      return passwordGenerator;
    }
    if (id == 40) {
      return dreamInterpreter;
    }
    if (id == 41) {
      return talkWithNabigh;
    }
    if (id == 42) {
      return policiesProcedures;
    }
    if (id == 43) {
      return smartDeviceCare;
    }

    return common;
  }

  clearModel() {
    suggestionCategoryList.clear();
  }

  clearSuggestionId() {
    _suggestionSubCategoryModel = SuggestionSubCategoryModel();
  }
}
