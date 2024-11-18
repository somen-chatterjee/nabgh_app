import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/helper/ad_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/select_model/select_model_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggesstion_search_bar.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:nabgh_app/widget/progress_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../helper/auth_helperr.dart';
import '../../../helper/sp_helper.dart';
import '../../../models/model/suggestion_card_model.dart';
import '../../../models/model/suggestion_category_model.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/search_provider.dart';
import '../../../provider/tutorial_target_provider.dart';
import '../../../widget/user_profile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ChatProvider pChat;

  // AdHelper adHelper = AdHelper();

  @override
  void dispose() {
    // _interstitialAd?.dispose();
    // adHelper.adDispose();
    pChat.clearAttempt();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    var provider = Provider.of<SearchProvider>(context, listen: false);
    pChat = Provider.of<ChatProvider>(context, listen: false);

    var pTutorialTarget =
        Provider.of<TutorialTargetProvider>(context, listen: false);

    if (provider.isFirst) {
      provider.getSuggestionCategory(context: context,isRefreshed: false).then((value) async {
        bool? tutorialShowed = await SpHelper.loadBool(SpKey.tutorialShowed);

        if (value.data["status"].toString() == "200") {
          if(tutorialShowed == null || !tutorialShowed) {
            pTutorialTarget.createTutorial();
            Future.delayed(Duration.zero, () {
              pTutorialTarget.showTutorial(context: context);
            });
          }
        }
      });
      provider.getAllSuggestion(context: context);
      // adHelper.showAd(context: context);
    }

    });
    super.initState();
  }

  int selectedTagIdx = 0;

  buildAppBar() {
    return FutureBuilder(
        future: AuthHelper.isUserExist(),
        builder: (context, snapshot) {
          return Consumer<TutorialTargetProvider>(
            builder: (context,pTutorialTarget,_) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 16, bottom: 8),
                child: Row(
                  children: [
                    IconButton(
                      key: pTutorialTarget.sidebarTab,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: SvgPicture.asset("assets/icon/menu.svg"),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    // show all models
                    // if (snapshot.data != null && snapshot.data != false)
                    //   TextButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const SelectModelPage(),
                    //         ),
                    //       );
                    //     },
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: LocalizationManager().translate('nabigh'),
                    //                 style: const TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 18.0,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text:
                    //                     LocalizationManager().translate('chatGpt'),
                    //                 style: const TextStyle(
                    //                   fontSize: 16.0,
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //         const Icon(
                    //           Icons.arrow_right,
                    //           color: Colors.white70,
                    //           size: 25.0,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    const Spacer(),
                    const UserProfile(),
                  ],
                ),
              );
            }
          );
        });
  }

  String giveName(String? name) {
    if (name != null) {
      return "${LocalizationManager().translate('Hey')} ${name.split(' ')[0]}";
    } else {
      return "";
    }
  }

  buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18)
          .copyWith(top: 32, bottom: 44),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.white54.withOpacity(.2),
            blurRadius: 1,
            offset: const Offset(0.0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  giveName(context
                      .read<AuthenticateProvider>()
                      .userDetail
                      ?.data
                      ?.name),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  LocalizationManager().translate('HowICanHelpYouToday'),
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const Spacer(),
          SvgPicture.asset(
            "assets/icon/brain.svg",
            height: 60,
          )
        ],
      ),
    );
  }

  buildSuggestionCard(
      {required SuggestionCardModel suggestion, required int index}) {
    return InkWell(
      onTap: () {
        suggestion.onTap();
        pChat.userAttempt(context: context);
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: suggestion.color,
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10/MediaQuery.textScaleFactorOf(context),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Container(
                height: 34,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: suggestion.color.withOpacity(.5),
                ),
                child: Image.asset(
                  suggestion.imgSrc!,
                  color: Colors.black.withOpacity(.8),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              suggestion.title,
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15/MediaQuery.textScaleFactorOf(context),
                fontWeight: FontWeight.w600,
              ),
            ),
             const SizedBox(
              height: 5,
            ),
            Text(
              suggestion.subtitle,
              style: TextStyle(
                fontSize: 13/MediaQuery.textScaleFactorOf(context),
                // fontSize: 13,
                color: Colors.black.withOpacity(.7),
              ),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 2/MediaQuery.textScaleFactorOf(context),
            ),

          ],
        ),
      ),
    );
  }

  buildSuggesstion({required List<SuggestionCardModel> suggestionList}) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 22.0, mainAxisSpacing: 22.0),
      itemBuilder: (BuildContext context, int index) {
        return buildSuggestionCard(
            suggestion: suggestionList[index], index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    buildTag(
        {required SuggestionCategoryModel suggestion,
        required List<SuggestionCategoryModel> allSuggestionList,
        required SearchProvider provider}) {
      int currIdx = allSuggestionList.indexOf(suggestion);
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            setState(() {
              selectedTagIdx = currIdx;
              if(provider.allSuggestionCategoryList[currIdx].categorySuggestionList.isEmpty) {
                provider.getSuggestion(
                  context: context,
                  categoryId: suggestion.id!,
                  index: selectedTagIdx,
                  initial: false,
                  isRefreshed: false,
                );
              }
              HapticFeedback.lightImpact();
            });
          },
          child: selectedTagIdx == currIdx
              ? Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: AppConstants.gradient,
                  ),
                  child: Text(
                    suggestion.title!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xff3E3E3E),
                  ),
                  child: Text(
                    suggestion.title!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
        ),
      );
    }

    buildTags() {
      return Consumer2<SearchProvider, TutorialTargetProvider>(
          builder: (context, provider, pTutorialTarget, child) {
        return provider.loadingStatus != AppLoadingStatus.loading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...provider.suggestionCategoryList.map((suggestion) =>
                            buildTag(
                                suggestion: suggestion,
                                allSuggestionList:
                                    provider.suggestionCategoryList,
                                provider: provider,
                            ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    key: pTutorialTarget.tab1,
                    width: double.infinity,
                  ),
                ],
              )
            : const SizedBox();
      });
    }

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Consumer<SearchProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        // ...SuggestionItem.allList.map((suggestion) => ListTile(
                        //       leading: Container(
                        //         height: 40,
                        //         width: 40,
                        //         padding: const EdgeInsets.all(8),
                        //         decoration: BoxDecoration(
                        //             color:
                        //                 getRandomColor(suggestion.subtitle.length),
                        //             borderRadius: const BorderRadius.all(
                        //                 Radius.circular(12))),
                        //         child: suggestion.imgSrc != null
                        //             ? Image.asset(suggestion.imgSrc!,
                        //                 color: Colors.white)
                        //             : const SizedBox(),
                        //       ),
                        //       onTap: () {
                        //         Navigator.of(context).pop();
                        //         suggestion.onTap();
                        //       },
                        //       title: Text(
                        //         suggestion.title,
                        //         style: const TextStyle(color: Colors.white70),
                        //       ),
                        //     ))
                        ...provider.allSuggestionList.map((suggestion) => ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: suggestion.color,
                                  // getRandomColor(suggestion.subtitle.length),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: suggestion.imgSrc != null
                                    ? Image.asset(
                                        suggestion.imgSrc!,
                                        // color: Colors.white,
                                      )
                                    : const SizedBox(),
                              ),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.of(context).pop();
                                suggestion.onTap();
                              },
                              title: Text(
                                suggestion.title,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ))
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          bottomNavigationBar: buildTags(),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildAppBar(),
                Consumer2<SearchProvider, TutorialTargetProvider>(
                  builder: (context, provider, pTutorialTarget, child) {
                    return Expanded(
                      child: provider.loadingStatus != AppLoadingStatus.loading
                          ? SmartRefresher(
                              controller: RefreshController(initialRefresh: false),
                              onRefresh: () {
                                provider.getSuggestionCategory(context: context,isRefreshed: true).then((value) {
                                  try {
                                    if (value.data["status"].toString() ==
                                        "200") {
                                      // adHelper.showAd(context: context);
                                      setState(() {
                                        selectedTagIdx = 0;
                                      });
                                    }
                                  }catch(e){
                                    // track error
                                  }
                                });
                                provider.getAllSuggestion(context: context);
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    buildHeader(),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    SuggestionSearchBar(
                                      coachKey: pTutorialTarget.searchTab,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              LocalizationManager()
                                                  .translate('SuggestionForToday'),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white.withOpacity(.8),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          provider.suggestionLoadingStatus !=
                                                      AppLoadingStatus.loading &&
                                                  provider.allSuggestionCategoryList
                                                      .isNotEmpty
                                              ? buildSuggesstion(
                                                  suggestionList: provider
                                                      .allSuggestionCategoryList[
                                                          selectedTagIdx]
                                                      .categorySuggestionList,
                                                )
                                              : const CircularProgressIndicator(),
                                          // allSuggestion[selectedTagIdx]
                                          //     .categorySuggestionList,
                                          const SizedBox(
                                            height: 28,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const ProgressPage(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Consumer<TutorialTargetProvider>(
            builder: (context,pTutorialTarget,_) {
              return SizedBox(
                key: pTutorialTarget.slideTab,
                width: 0.0,
                height: 90.0,
                // height: double.infinity,
              );
            }
        ),
      ],
    );
  }
}
