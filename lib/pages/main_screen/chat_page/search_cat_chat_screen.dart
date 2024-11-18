import 'dart:async';
import 'dart:convert';

// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:nabgh_app/widget/app_back_button.dart';
import 'package:provider/provider.dart';

import '../../../enum/app_loading_staus.dart';
import '../../../helper/ad_helper.dart';
import '../../../helper/auth_helperr.dart';
import '../../../helper/sp_helper.dart';
import '../../../models/model/chat_model.dart';
import '../../../widget/code_display_widget.dart';
import '../../../widget/user_profile.dart';
import '../login_modal.dart';
import '../subscribe_modal.dart';
import '../subscription_page/subscription_detail_page.dart';
import '../subscription_page/subscription_page.dart';

class SearchCatChatPage extends StatefulWidget {
  static const routeName = "chat-page";

  final String title;
  final String question;

  const SearchCatChatPage({
    super.key,
    required this.title,
    required this.question,
  });

  @override
  State<SearchCatChatPage> createState() => _SearchCatChatPageState();
}

class _SearchCatChatPageState extends State<SearchCatChatPage> {
  TextEditingController controller = TextEditingController();

  // late OpenAI? chatGPT;

  late ChatProvider pChat;

  late String uniqueId;

  ValueNotifier<int> numLines = ValueNotifier<int>(1);
  ValueNotifier<String> input = ValueNotifier<String>("");
  ValueNotifier<int> modelIndex = ValueNotifier<int>(0);
  String? userModel;
  final ScrollController _scrollController = ScrollController();

  // AdHelper adHelper = AdHelper();

  late CancelToken _cancelToken;

  late String firstQuestion;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      pChat = Provider.of<ChatProvider>(context, listen: false);

      pChat.clearChat();

      userModel = await SpHelper.loadString(SpKey.userModel);

      _cancelToken = CancelToken();

      if (userModel != null) {
        if (userModel == "1") {
          modelIndex.value = 0;
        } else {
          modelIndex.value = 1;
        }
      }

      pChat.setNewChat(
        message: LocalizationManager().translate('HowCanIHelpYouToday'),
        isUser: false,
      );

      if(mounted) {
        pChat.userAttempt(context: context);
      }

      uniqueId = AppConstants.getUniqueId();

      onMessageSend(message: widget.question);

      firstQuestion = pChat.postBody['question']
          .toString();
      // set new question
      // pChat.setNewChat(message: widget.question, isUser: true);

      //to called search chat api
      // pChat
      //     .chatGpt(
      //   context: context,
      //   postBody: pChat.postBody,
      //   isDiscover: false,
      // );


      // pChat.setKey(key: 'question', value: widget.question);

    });
    super.initState();
  }

  @override
  void dispose() {
    // pChat.clearMap();
    pChat.setKey(key: 'question', value: firstQuestion);
    print("first question $firstQuestion");
    pChat.clearChat();
    pChat.clearAttempt();
    // adHelper.adDispose();
    _cancelToken.cancel();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  onMessageSend({required String message}) async {
    HapticFeedback.lightImpact();
    var pAuth = Provider.of<AuthenticateProvider>(context, listen: false);
    if (message.isNotEmpty) {
      FocusScope.of(context).unfocus();
      pChat.setNewChat(message: message, isUser: true);
      scrollDown();
      pChat.setKey(key: 'question', value: message);
      pChat.setKey(key: 'device_id', value: await pAuth.getDeviceIdentifier());
      pChat.setKey(key: 'model', value: userModel);
      pChat.setKey(key: 'tab_id', value: uniqueId);

      // print("pChat.postBody ${pChat.postBody}");

      //to called search chat api
      if(mounted) {
        pChat
            .chatGpt(
          context: context,
          postBody: pChat.postBody,
          isDiscover: false,
          cancelToken: _cancelToken
        ).then((value) {
          scrollDown();
          try {
            if (value.data["status"].toString() == "200") {
              // adHelper.showAd(context: context);
              pChat.userAttempt(context: context);
            }
          }catch(e){
            //
          }
        });
      }
      controller.clear();
      numLines.value = 1;
      input.value = "";
    } else {
      AppConstants.getToast(
        message: LocalizationManager().translate('enterDesiredQuestion'),
      );
    }
  }

  buildListView (List<String> suggestion) {
    return ListView.builder(
      itemCount: suggestion.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            controller.clear();
            controller.text = suggestion[index];
            // suggestion.text!.replaceAll('\n', ' ');
            input.value = suggestion[index];
            HapticFeedback.lightImpact();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 5,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            // height: 60,
            child: Text(
              suggestion[index],
              // suggestion.text!.replaceAll('\n', ' '),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        );
      },);
  }

  forSuggestion({required List<String> suggestionList}){
    int midIndex = suggestionList.length ~/ 2;

    return Flexible(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: 88.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0,),
                Flexible(child:  buildListView(suggestionList.sublist(midIndex))),
                const SizedBox(height: 10.0,),
                Flexible(child:  buildListView(suggestionList.sublist(0,midIndex))),
                // buildListView(suggestionList.sublist(midIndex)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSearchBar() {
    return Consumer2<ChatProvider, AuthenticateProvider>(
      builder: (context, pChat, pAuth, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //for suggestion
            if (pChat.loadingStatus != AppLoadingStatus.loading &&
                pChat.suggestionList.isNotEmpty)
              forSuggestion(suggestionList: pChat.suggestionList),
              // Container(
              //   padding:
              //   const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              //   // height: 60,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: SizedBox(
              //       width: pChat.suggestionList.length > 5 ? 1800 : 900,
              //       child: Wrap(
              //         spacing: 8.0,
              //         runSpacing: 8.0,
              //         children: [
              //           ...pChat.suggestionList.map((suggestion) {
              //             return InkWell(
              //               onTap: () {
              //                 controller.clear();
              //                 controller.text = suggestion;
              //                 input.value = suggestion;
              //                 HapticFeedback.lightImpact();
              //               },
              //               child: Container(
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 12,
              //                   vertical: 10,
              //                 ),
              //                 margin: const EdgeInsets.symmetric(horizontal: 5),
              //                 decoration: BoxDecoration(
              //                   color: Colors.grey.shade900,
              //                   borderRadius: const BorderRadius.all(
              //                     Radius.circular(10.0),
              //                   ),
              //                 ),
              //                 // height: 60,
              //                 child: Text(
              //                     // RegExp(r'\d+\.\s(.*?)\n').firstMatch(suggestion.text!)!.group(1).toString(),
              //                   suggestion,
              //                   // suggestion.text!.replaceAll('\n', ' '),
              //                   maxLines: 1,
              //                 ),
              //               ),
              //             );
              //           })
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            if (pChat.loadingStatus == AppLoadingStatus.loading)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocalizationManager().translate('aiTyping'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 5.0,),
                    LoadingAnimationWidget.staggeredDotsWave(
                      size: 30.0, color: Colors.grey,
                    ),
                  ],
                ),
              ),
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
                            text:
                            LocalizationManager().translate('moreMessage'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 13.0,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                HapticFeedback.lightImpact();
                                // if (pAuth.userDetail != null) {
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
                                //   // AppConstants.getToast(
                                //   //   message: LocalizationManager()
                                //   //       .translate('loginBuy'),
                                //   // );
                                // }
                              })
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 5.0),
            ValueListenableBuilder(
              valueListenable: numLines,
              builder: (context, value, child) {
                return Container(
                  alignment: Alignment.bottomCenter,
                  // height: numLines.value == 1 ? 65 : 85,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller,
                        onSubmitted: (message) {
                          if (pChat.loadingStatus != AppLoadingStatus.loading) {
                            onMessageSend(message: message);
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 7,
                        readOnly: pChat.loadingStatus == AppLoadingStatus.loading
                            ? true
                            : false,
                        onChanged: (value) {
                          // controller.text = value;
                          input.value = value;
                          // numLines.value = '\n'.allMatches(value).length + 1;
                          // print("numLines ${numLines.value}");
                        },
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: input,
                                builder: (context, value, _) {
                                  if (value.isNotEmpty) {
                                    return IconButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        controller.clear();
                                        input.value = "";
                                      },
                                      icon: const Icon(Icons.cancel_outlined),
                                      color: Colors.cyan,
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  if (pChat.loadingStatus !=
                                      AppLoadingStatus.loading) {
                                    onMessageSend(message: controller.text.trim());
                                  }
                                },
                                icon: SvgPicture.asset(
                                  "assets/icon/send.svg",
                                  height: 20.0,
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 15.0,),
                          hintStyle: const TextStyle(color: Colors.white60),
                          hintText:
                          LocalizationManager().translate('writeAnything'),
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  buildAppBar(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0)
          .copyWith(bottom: 10, top: 4),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            title,
            // LocalizationManager().translate('Codding'),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          const Spacer(),
          const UserProfile(),
        ],
      ),
    );
  }

  buildChatTitle() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xff3B3B3B),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/discover/code.svg"),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationManager().translate('Code'),
                  style: const TextStyle(
                      fontSize: 16, color: AppConstants.secondaryColor),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  LocalizationManager().translate('chatDemoTxt'),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    var langCode = LocalizationManager().locale.languageCode;

    buildBotImageTile({required String source}) {
      return Align(
        alignment: langCode == 'en' ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.only(bottom: 18),
          constraints: BoxConstraints(maxWidth: width * .7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // SvgPicture.asset(
              //   "assets/icon/brain.svg",
              //   height: 25,
              // ),
              // const SizedBox(
              //   width: 12,
              // ),
              Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: langCode == 'en' ? const Radius.circular(18) : const Radius.circular(0.0),
                        topLeft: langCode == 'en' ? const Radius.circular(0.0) : const Radius.circular(18.0),
                        bottomLeft: const Radius.circular(18),
                        bottomRight: const Radius.circular(18),
                      ),
                      border: Border.all(color: const Color(0xff575757))),
                  child: Image.network(
                    source,
                    height: 200.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    buildUserChatTile({required UserChatModel chat}) {
      var langCode = LocalizationManager().locale.languageCode;

      return Container(
        padding: const EdgeInsets.only(bottom: 18),
        width: double.infinity,
        child: Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () {
                controller.text = chat.message;
                input.value = chat.message;
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppConstants.gradient,
                  borderRadius: BorderRadius.only(
                    topLeft: langCode == 'en' ? const Radius.circular(18) : const Radius.circular(0.0),
                    topRight: langCode == 'en' ? const Radius.circular(0.0) : const Radius.circular(18.0),
                    bottomRight: const Radius.circular(18),
                    bottomLeft: const Radius.circular(18),
                  ),
                ),
                // width: width * .7,
                constraints: BoxConstraints(maxWidth: width * .7),
                child: SelectableText(
                  chat.message,
                  style: const TextStyle(color: Colors.black),
                  onSelectionChanged:
                      (textSelection, selectionChangedCause) {
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    switchModel() {
      return FutureBuilder(
        future: AuthHelper.isUserExist(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data != false) {
            return Consumer<ChatProvider>(
              builder: (context, pChat, _) {
                var attemptModel = pChat.attemptModel;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: modelIndex,
                    builder: (context, indexValue, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                modelIndex.value = 0;
                                userModel = "1";
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                decoration: indexValue == 0
                                    ? BoxDecoration(
                                  gradient: AppConstants.gradient,
                                  borderRadius:
                                  BorderRadius.circular(12.0),
                                )
                                    : null,
                                child: Text(
                                  LocalizationManager().translate('gpt3.5'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: indexValue == 0
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                if (attemptModel != null &&
                                    attemptModel.plan == 1) {
                                  modelIndex.value = 1;
                                  userModel = "2";
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext _) =>
                                    const SubscribeModal(),
                                  );
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                decoration: indexValue == 1
                                    ? BoxDecoration(
                                  gradient: AppConstants.gradient,
                                  borderRadius:
                                  BorderRadius.circular(12.0),
                                )
                                    : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocalizationManager().translate('gpt4'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: indexValue == 1
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    if (attemptModel != null &&
                                        attemptModel.plan == 0)
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                    if (attemptModel != null &&
                                        attemptModel.plan == 0)
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          "assets/icon/crown.png",
                                          width: 14.0,
                                          height: 14.0,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: buildSearchBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(widget.title),
            // switchModel(),
            Consumer<ChatProvider>(
              builder: (context, pChat, child) {
                return Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    reverse: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * .06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          // buildChatTitle(),
                          const SizedBox(
                            height: 18,
                          ),
                          ...pChat.chatList.map((chat) {

                            var index = pChat.chatList.indexOf(chat);

                            if (chat.chatType == ChatType.text) {
                              if (chat.isUser) {
                                return buildUserChatTile(chat: chat);
                              } else {
                                if (!chat.message.contains('https://oaidalleapiprodscus')) {
                                  return BotChatTile(chat: chat, index: index);
                                } else {
                                  return buildBotImageTile(
                                      source: chat.message);
                                }
                                // return buildBotChatTile(chat: chat);
                              }
                            }

                            if (chat.chatType == ChatType.code) {
                              return CodeDisplayWidget(code: chat.message);
                            }

                            return Container();
                          }).toList(),
                          const SizedBox(
                            height: 28,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

class BotChatTile extends StatefulWidget {
  final int index;
  final UserChatModel chat;

  const BotChatTile({super.key, required this.chat, required this.index});

  @override
  State<BotChatTile> createState() => _BotChatTileState();
}

class _BotChatTileState extends State<BotChatTile> {
  ValueNotifier<int> index = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    startTyping();
  }

  void startTyping() {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (mounted) {
        // setState(() {
          if (index.value < widget.chat.message.length) {
            index.value++;
            HapticFeedback.lightImpact();
          } else {
            timer.cancel();
            return;
          }
        // });
      }
    });
  }
  String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    var langCode = LocalizationManager().locale.languageCode;

    return Align(
      alignment: langCode == 'en' ? Alignment.topLeft : Alignment.topRight,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.only(bottom: 18),
          // constraints: BoxConstraints(maxWidth: width * .7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SvgPicture.asset(
              //   "assets/icon/brain.svg",
              //   height: 25,
              // ),
              // const SizedBox(
              //   width: 12,
              // ),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 14.0, right: 12.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: langCode == 'en' ? const Radius.circular(18) : const Radius.circular(0.0),
                          topLeft: langCode == 'en' ? const Radius.circular(0.0) : const Radius.circular(18.0),
                          bottomLeft: const Radius.circular(18),
                          bottomRight: const Radius.circular(18),
                        ),
                        border: Border.all(
                          color: const Color(0xff575757),
                        ),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: index,
                        builder: (context,value,_) {
                          String displayText = widget.chat.message.substring(0, index.value);
                          return SelectableText(
                            displayText,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(.8),
                            ),
                            onSelectionChanged:
                                (textSelection, selectionChangedCause) {
                              HapticFeedback.lightImpact();
                            },
                          );
                        }
                      ),
                    ),
                    if(widget.index != 0)
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.chat.message))
                              .then((_) {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  LocalizationManager()
                                      .translate('CopiedClipboard'),
                                ),
                              ),
                            );
                          });
                        },
                        child: Container(
                          // margin: EdgeInsets.only(right: 14.0,),
                          padding: const EdgeInsets.all(
                            5.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(
                              color: const Color(0xff575757),
                            ),
                          ),
                          child: Icon(
                            Icons.copy,
                            color: Colors.grey.shade500,
                            size: 20.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
