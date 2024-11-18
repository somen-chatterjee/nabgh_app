import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:nabgh_app/provider/search_provider.dart';
import 'package:provider/provider.dart';
import '../../../../constatns/app_constants.dart';
import '../../../../enum/app_loading_staus.dart';
import '../../../../widget/app_small_button.dart';
import '../../chat_page/search_cat_chat_screen.dart';
import '../../login_modal.dart';
import '../../subscription_page/subscription_detail_page.dart';
import '../../subscription_page/subscription_page.dart';
import '../advance_filter_page.dart';

class SuggestionBottomBar extends StatelessWidget {
  final String title;
  final int? interviewPage; // 0 => interviewer,  1 => interviewee

  const SuggestionBottomBar(
      {super.key, required this.title, this.interviewPage});

  bool checkId(int? id, ChatProvider pChat) {
    if (id != null && id == 14) {
      if (pChat.postBody['b_company_name'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterCompanyName',
          ),
        );
        return false;
      } else if (pChat.postBody['b_product'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterProductServiceName',
          ),
        );
        return false;
      } else if (pChat.postBody['b_niche'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterNicheName',
          ),
        );
        return false;
      } else if (pChat.postBody['b_goal'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterGoalName',
          ),
        );
        return false;
      } else {
        return true;
      }
    }
    if (id != null && id == 15) {
      if (pChat.postBody['c_industry'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterIndustry',
          ),
        );
        return false;
      } else if (pChat.postBody['c_competitor'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterCompetitor',
          ),
        );
        return false;
      } else {
        return true;
      }
    }
    //for interviewer
    if (interviewPage != null && interviewPage == 0 && id != null && id == 16) {
      if (pChat.postBody['int_job_title'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterJobTitle',
          ),
        );
        return false;
      } else {
        return true;
      }
    }

    //for interviewee
    if (interviewPage != null && interviewPage == 1 && id != null && id == 16) {
      if (pChat.postBody['int_position'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterPosition',
          ),
        );
        return false;
      } else if (pChat.postBody['int_question_to_ans'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterQuestion',
          ),
        );
        return false;
      } else {
        return true;
      }
    }
    if (id != null && id == 17) {
      if (pChat.postBody['p_potential_client'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterPotentialClient',
          ),
        );
        return false;
      } else if (pChat.postBody['p_plan_point'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterPainPoints',
          ),
        );
        return false;
      } else if (pChat.postBody['p_service'].toString().isEmpty) {
        AppConstants.getToast(
          message: LocalizationManager().translate(
            'enterServices',
          ),
        );
        return false;
      } else {
        return true;
      }
    }
    if (id == null || id == 25) {
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatProvider, AuthenticateProvider, SearchProvider>(
      builder: (context, pChat, authProvider, pSearch, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pChat.attemptModel != null && pChat.attemptModel!.plan == 0)
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text:
                        "${LocalizationManager().translate('youHave')} ${pChat.attemptModel!.attempt} ${LocalizationManager().translate('left')}",
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.white70,
                    ),
                    children: [
                      TextSpan(
                        text: LocalizationManager().translate('moreMessage'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 13.0,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            HapticFeedback.lightImpact();
                            // print(
                            //     "pAuth.userDetail ${authProvider.userDetail}");
                            // if (authProvider.userDetail != null) {
                              Navigator.of(context)
                                  .pushNamed(SubscriptionPage.routeName)
                                  .then((value) {
                                pChat.userAttempt(context: context);
                              });
                            // } else {
                            //   showDialog<void>(
                            //     context: context,
                            //     barrierDismissible: false,
                            //     builder: (BuildContext _) => const LoginModal(),
                            //   );
                            //   // AppConstants.getToast(message: LocalizationManager().translate('loginBuy'));
                            // }
                          },
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ).copyWith(bottom: 12, top: 8),
              height: 70,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (pChat.loadingStatus != AppLoadingStatus.loading) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (builder) {
                          return const AdvanceFilterPage();
                        }));
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white.withOpacity(.1), width: 1),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.grey.shade900,
                      ),
                      child: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: AppSmallButton(
                      title:
                      // pChat.loadingStatus == AppLoadingStatus.loading
                      //     ? const CircularProgressIndicator(
                      //         color: Colors.black,
                      //       )
                      //     :
                      Text(
                              LocalizationManager().translate("Submit"),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        pChat.setKey(key: 'category_id', value: pSearch.suggestionSubCategoryModel.id);
                        pChat.setKey(key: 'send_msg', value: pSearch.suggestionSubCategoryModel.sendMsg);

                        // print("map ${pChat.postBody}");
                        // print("map ${pSearch.suggestionSubCategoryModel.id}");
                        if (checkId(
                            pSearch.suggestionSubCategoryModel.id, pChat)) {
                          if (pChat.postBody['question'].toString().isEmpty) {
                            AppConstants.getToast(
                              message: LocalizationManager().translate(
                                'enterDesiredQuestion',
                              ),
                            );
                          } else {
                            pChat.setKey(
                                key: 'device_id',
                                value:
                                    await authProvider.getDeviceIdentifier());

                            if (context.mounted) {
                              print("pChat.postBody ${pChat.postBody}");

                              Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (builder) {
                                              return SearchCatChatPage(
                                                title: title,
                                                question: pChat.postBody['question']
                                                    .toString(),
                                              );
                                            },
                                          ),
                                        );

                              // to show the chat response in single page.

                              // pChat
                              //     .chatGpt(
                              //   context: context,
                              //   postBody: pChat.postBody,
                              //   isDiscover: false,
                              // )
                              //     .then(
                              //   (value) {
                              //     if (value.data["status"].toString() ==
                              //         "200") {
                              //       Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //           builder: (builder) {
                              //             return ResultPage(
                              //               title: title,
                              //               question: pChat.postBody['question']
                              //                   .toString(),
                              //             );
                              //           },
                              //         ),
                              //       );
                              //     }
                              //   },
                              // );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
