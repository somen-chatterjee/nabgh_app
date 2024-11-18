import 'dart:async';
import 'dart:io';

// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:nabgh_app/widget/app_back_button.dart';
import 'package:nabgh_app/widget/app_loadig_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../enum/app_loading_staus.dart';
import '../../../helper/sp_helper.dart';
import '../../../models/model/category_model.dart';
import '../../../models/model/chat_model.dart';
import '../../../widget/code_display_widget.dart';
import '../../../widget/user_profile.dart';
import '../new_screen_modal.dart';
import '../search_page/select_model/select_model_page.dart';
import '../subscription_page/subscription_page.dart';

class DiscoverChatPage extends StatefulWidget {
  static const routeName = "chat-page";

  final String? title;
  final String? value;

  const DiscoverChatPage({
    super.key,
    this.title,
    this.value,
  });

  @override
  State<DiscoverChatPage> createState() => _DiscoverChatPageState();
}

class _DiscoverChatPageState extends State<DiscoverChatPage> {
  String apiKey = "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";
  TextEditingController controller = TextEditingController();
  StreamSubscription? streamSubscription;

  // late OpenAI? chatGPT;

  late ChatProvider pChat;

  ValueNotifier<int> numLines = ValueNotifier<int>(1);
  ValueNotifier<String> input = ValueNotifier<String>("");

  ValueNotifier<int> modelIndex = ValueNotifier<int>(0);
  String? userModel;

  final ScrollController _scrollController = ScrollController();

  late String uniqueId;

  late CancelToken _cancelToken;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final receivedArgument =
          ModalRoute.of(context)!.settings.arguments as GetDiscover;

      _cancelToken = CancelToken();

      // chatGPT = OpenAI.instance.build(
      //     token: apiKey,
      //     orgId: "org-U5Im73fm82X69ZQe2bQgilGN",
      //     baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));

      pChat = Provider.of<ChatProvider>(context, listen: false);

      if (mounted) {
        pChat.userAttempt(
            context: context, image: receivedArgument.id == 1 ? 1 : null);
      }

      pChat.clearChat();

      // print("somen ${widget.title}");

      userModel = await SpHelper.loadString(SpKey.userModel);

      if (userModel != null) {
        if (userModel == "1") {
          modelIndex.value = 0;
        } else {
          modelIndex.value = 1;
        }
      }

      if (widget.title != null) {
        pChat.setNewChat(
          message: LocalizationManager().translate('HowCanIHelpYouToday'),
          isUser: false,
        );
      } else {
        pChat.setNewChat(
          message: receivedArgument.suggestion!,
          isUser: false,
        );
        //add this for category chat
        pChat.setKey(key: 'name', value: receivedArgument.titleEn);
        pChat.setKey(key: 'description', value: receivedArgument.descriptionEn);
        pChat.setKey(key: 'category', value: receivedArgument.slug);
      }

      //to get search content
      if (widget.value != null && widget.value!.isNotEmpty) {
        controller.text = widget.value!;
      }

      uniqueId = AppConstants.getUniqueId();
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    pChat.clearMap();
    pChat.clearChat();
    pChat.clearAttempt();
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
    final receivedArgument =
        ModalRoute.of(context)!.settings.arguments as GetDiscover;

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

      if (mounted) {
        pChat
            .discoverChatGpt(
          context: context,
          postBody: pChat.postBody,
          isDiscover: true,
          isGlobal: false,
          cancelToken: _cancelToken,
        )
            .then((value) {
          scrollDown();
          pChat.userAttempt(
              context: context, image: receivedArgument.id == 1 ? 1 : null);
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

  buildListView(List<String> suggestion) {
    if (suggestion.isNotEmpty) {
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
                horizontal: 12,
                vertical: 5,
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
        },
      );
    } else {
      return const SizedBox();
    }
  }

  forSuggestion({required List<String> suggestionList}) {
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
                const SizedBox(
                  height: 5.0,
                ),
                Flexible(
                  child: buildListView(suggestionList.sublist(midIndex)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: buildListView(suggestionList.sublist(0, midIndex)),
                ),
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
            //       const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            //                   suggestion,
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
                    const SizedBox(
                      width: 5.0,
                    ),
                    LoadingAnimationWidget.staggeredDotsWave(
                      size: 30.0,
                      color: Colors.grey,
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
                                //     builder: (BuildContext _) =>
                                //         const LoginModal(),
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
                  child: TextField(
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 15.0,
                      ),
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.white60),
                      hintText:
                          LocalizationManager().translate('writeAnything'),
                      fillColor: Colors.transparent,
                    ),
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
          FittedBox(
            child: Text(
              widget.title != null ? widget.title! : title,
              // LocalizationManager().translate('Codding'),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
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

  Future<void> _saveImage(BuildContext context, String url) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AppLoadingIndicator(),
    );

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      var timeStamp = DateTime.now().millisecondsSinceEpoch;

      // Create an image name
      var filename = '${dir.path}/$timeStamp.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = 'An error occurred while saving the image';
    }

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  _saveImageToIos(String url) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AppLoadingIndicator(),
    );

    try {
      var timeStamp = DateTime.now().millisecondsSinceEpoch;

      var filename = '$timeStamp.png';

      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        // quality: 60,
        name: filename,
      );
      // print("somen ${result}");

      if (result['isSuccess'] == true) {
        message = LocalizationManager()
            .translate('saveToGallery'); //Image saved to disk
      } else {
        throw const FormatException('Permission Denied');
      }
    } catch (e) {
      message = LocalizationManager().translate('errorSaveImage');
    }

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void openNewScreen({required String model}) {
    final receivedArgument =
        ModalRoute.of(context)!.settings.arguments as GetDiscover;

    // print("model $model");
    if (pChat.chatList.length > 2) {
      showGeneralDialog(
        context: context,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
              scale: a1.value,
              child: NewScreenModal(
                function: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return SearchChatPage(
                  //         title: widget.title,
                  //         value: widget.value,
                  //         scanned: widget.scanned,
                  //       );
                  //     },
                  //   ),
                  // );

                  modelIndex.value = model == "2" ? 1 : 0;
                  userModel = model;
                  pChat.clearChat();
                  setState(() {
                    pChat.setNewChat(
                      message: receivedArgument.suggestion!,
                      isUser: false,
                    );
                    uniqueId = AppConstants.getUniqueId();
                  });
                },
              ));
        },
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      );
    } else {
      if (modelIndex.value == 0) {
        modelIndex.value = 1;
        userModel = "2";
      } else {
        modelIndex.value = 0;
        userModel = "1";
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final receivedArgument =
        ModalRoute.of(context)!.settings.arguments as GetDiscover;

    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    buildBotImageTile({required String source}) {
      var langCode = LocalizationManager().locale.languageCode;

      return Align(
        alignment: langCode == 'ar' ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.only(bottom: 18),
          constraints: const BoxConstraints(maxWidth: double.infinity),
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
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 300.0,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 14.0, right: 12.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: langCode == 'en'
                              ? const Radius.circular(18)
                              : const Radius.circular(0.0),
                          topLeft: langCode == 'en'
                              ? const Radius.circular(0.0)
                              : const Radius.circular(18.0),
                          bottomLeft: const Radius.circular(18),
                          bottomRight: const Radius.circular(18),
                        ),
                        border: Border.all(color: const Color(0xff575757)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: langCode == 'en'
                              ? const Radius.circular(12)
                              : const Radius.circular(0.0),
                          topLeft: langCode == 'en'
                              ? const Radius.circular(0.0)
                              : const Radius.circular(12.0),
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        ),
                        child: Image.network(
                          source,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppConstants.secondaryColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                                child: Text(LocalizationManager()
                                    .translate('imageNotFound')));
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        // if (Platform.isAndroid) {
                        //   _saveImage(context, source);
                        // } else {
                        _saveImageToIos(source);
                        // }
                      },
                      child: Container(
                        // margin: EdgeInsets.only(right: 14.0,),
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          border: Border.all(
                            color: const Color(0xff575757),
                          ),
                        ),
                        child: Icon(
                          Icons.save_alt_rounded,
                          color: Colors.grey.shade500,
                          size: 22.0,
                        ),
                      ),
                    )
                  ],
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppConstants.gradient,
                  borderRadius: BorderRadius.only(
                    topLeft: langCode == 'en'
                        ? const Radius.circular(18)
                        : const Radius.circular(0.0),
                    topRight: langCode == 'en'
                        ? const Radius.circular(0.0)
                        : const Radius.circular(18.0),
                    bottomRight: const Radius.circular(18),
                    bottomLeft: const Radius.circular(18),
                  ),
                ),
                // width: width * .7,
                constraints: BoxConstraints(maxWidth: width * .7),
                child: SelectableText(
                  chat.message,
                  style: const TextStyle(color: Colors.black),
                  onSelectionChanged: (textSelection, selectionChangedCause) {
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
      return Consumer<ChatProvider>(
        builder: (context, pChat, _) {
          var attemptModel = pChat.attemptModel;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      // horizontal: 16.0,
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
                                  // modelIndex.value = 0;
                                  // userModel = "1";
                                  if (pChat.attemptLoadingStatus !=
                                      AppLoadingStatus.loading &&
                                      pChat.loadingStatus !=
                                          AppLoadingStatus.loading) {
                                    if (modelIndex.value == 1) {
                                      HapticFeedback.lightImpact();

                                      if (pChat.chatList.length > 2) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.grey.shade900,
                                          // constraints: BoxConstraints.loose(Size(
                                          //     MediaQuery.of(context).size.width,
                                          //     MediaQuery.of(context).size.height * 0.90)),
                                          useSafeArea: true,
                                          builder: (context) {
                                            return SelectModelPage(
                                              modelIndex: modelIndex.value,
                                              onTap: () =>
                                                  openNewScreen(model: "1"),
                                            );
                                          },
                                        );
                                        // openNewScreen(model: "1");
                                      } else {
                                        if (modelIndex.value == 0) {
                                          modelIndex.value = 1;
                                          userModel = "2";
                                        } else {
                                          modelIndex.value = 0;
                                          userModel = "1";
                                        }
                                        // modelIndex.value = modelIndex.value == 0 ? 1 : 0;
                                      }
                                    }
                                  }
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
                                  if (pChat.attemptLoadingStatus !=
                                      AppLoadingStatus.loading &&
                                      pChat.loadingStatus !=
                                          AppLoadingStatus.loading) {
                                    HapticFeedback.lightImpact();
                                    if (attemptModel != null &&
                                        attemptModel.plan == 1) {
                                      if (pChat.chatList.length > 2) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.grey.shade900,
                                          // constraints: BoxConstraints.loose(Size(
                                          //     MediaQuery.of(context).size.width,
                                          //     MediaQuery.of(context).size.height * 0.85)),
                                          useSafeArea: true,
                                          builder: (context) {
                                            return SelectModelPage(
                                              modelIndex: modelIndex.value,
                                              onTap: () =>
                                                  openNewScreen(model: "2"),
                                            );
                                          },
                                        );

                                        // openNewScreen(model: "2");
                                      } else {
                                        if (modelIndex.value == 0) {
                                          modelIndex.value = 1;
                                          userModel = "2";
                                        } else {
                                          modelIndex.value = 0;
                                          userModel = "1";
                                        }

                                        // modelIndex.value = modelIndex.value == 0 ? 1 : 0;
                                      }
                                    } else {
                                      Navigator.of(context)
                                          .pushNamed(SubscriptionPage.routeName)
                                          .then((value) => pChat.userAttempt(
                                          context: context));
                                    }
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
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (attemptModel != null && attemptModel.plan == 1) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.grey.shade900,
                        // constraints: BoxConstraints.loose(Size(
                        //     MediaQuery.of(context).size.width,
                        //     MediaQuery.of(context).size.height * 0.85)),
                        useSafeArea: true,
                        builder: (context) {
                          return SelectModelPage(
                            modelIndex: modelIndex.value,
                            onTap: () =>
                                openNewScreen(
                                    model: modelIndex.value == 1 ? "1" : "2"),
                          );
                        },
                      );
                    } else {
                      Navigator.of(context)
                          .pushNamed(SubscriptionPage.routeName)
                          .then((value) => pChat.userAttempt(
                          context: context));
                    }
                  },
                  child: const Icon(Icons.info),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: buildSearchBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              buildAppBar(receivedArgument.title!),
              switchModel(),
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
                                  if (!chat.message
                                      .contains('https://oaidalleapiprodscus')) {
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
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: langCode == 'en'
                              ? const Radius.circular(18)
                              : const Radius.circular(0.0),
                          topLeft: langCode == 'en'
                              ? const Radius.circular(0.0)
                              : const Radius.circular(18.0),
                          bottomLeft: const Radius.circular(18),
                          bottomRight: const Radius.circular(18),
                        ),
                        border: Border.all(
                          color: const Color(0xff575757),
                        ),
                      ),
                      child: ValueListenableBuilder(
                          valueListenable: index,
                          builder: (context, value, _) {
                            String displayText =
                                widget.chat.message.substring(0, index.value);
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
                          }),
                    ),
                    if (widget.index != 0)
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
