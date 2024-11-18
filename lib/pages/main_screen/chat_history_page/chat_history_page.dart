import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/provider/chat_history_provider.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:nabgh_app/widget/error_page.dart';
import 'package:nabgh_app/widget/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../helper/ad_helper.dart';
import '../../../helper/auth_helperr.dart';
import '../../../models/api_model/chat_history.dart';
import '../../../models/model/chat_history_model.dart';
import '../chat_page/chat_history_view_screen.dart';

class ChatHistoryPage extends StatefulWidget {
  final int? type;

  const ChatHistoryPage({super.key, required this.type});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  // AdHelper adHelper = AdHelper();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    var provider = Provider.of<ChatHistoryProvider>(context, listen: false);
    provider.clearIds();
    if (provider.isFirst) {
      provider.getChatHistory(
        context: context,
        type: widget.type,
        category: '',
        tabId: '',
      );
      // adHelper.showAd(context: context);
    }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<ChatHistoryProvider>(context, listen: false);

    buildAppBar() {
      return FutureBuilder(
        future: AuthHelper.isUserExist(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0)
                .copyWith(bottom: 10, top: 4),
            child: Row(
              children: [
                if (snapshot.data != null && snapshot.data != false)
                  const SizedBox(
                    width: 18,
                  ),
                if (snapshot.data != null && snapshot.data != false)
                  const Spacer(),
                Text(
                  LocalizationManager().translate('ChatHistory'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                const Spacer(),
                const UserProfile(),
              ],
            ),
          );
        },
      );
    }

    buildRecentCard({
      required String day,
      required ChatHistoryProvider provider,
      required List<ChatHistory> chatDataList,
      required int mainIndex,
    }) {
      var langCode = LocalizationManager().locale.languageCode;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: chatDataList.length,
            itemBuilder: (context, qIndex) {
              // ChatHistory recent = ChatHistory.fromJson(chatDataList[qIndex]);
              ChatHistory recent = chatDataList[qIndex];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (provider.ids.isNotEmpty) {
                      // int currIdx = provider.chatHistoryShowList.indexOf(recent);
                      provider.onHistorySelect(
                          mainIndex: mainIndex, chatIndex: qIndex);
                    } else {
                      // adHelper.showAd(context: context);
                      print("somen ${recent.category}");
                      //navigate to chat screen to display chat
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatHistoryViewPage(
                              category: recent.category,
                              type: recent.type,
                              tabId: recent.tabId ?? "",
                              isImage: recent.category == "صانع الصور",

                            ),
                          )).then((value) {
                        // var pChat = Provider.of<ChatProvider>(context,listen: false);

                        if (provider.isFirst) {
                          provider.getChatHistory(
                            context: context,
                            type: widget.type,
                            category: '',
                            tabId: '',
                          );
                        }
                      });
                    }
                  },
                  onLongPress: () {
                    // print("somen ${qIndex}");
                    // log("somen ${provider.chatHistoryShowList.toJson().values.toList()[]}");
                    // log("somen ${recent.isSelected}");
                    // log("somen contain ${provider.chatHistoryShowList.toJson()[day].length}");
                    // int currIdx = provider.chatHistoryShowList.indexOf(recent);
                    HapticFeedback.lightImpact();
                    provider.onHistorySelect(
                        mainIndex: mainIndex, chatIndex: qIndex);
                  },
                  child: Container(
                    alignment: langCode == 'ar'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: recent.isSelected
                          ? const Color(0xff3C3C6A)
                          : Colors.black,
                      border: Border.all(
                        color: const Color(0xff3C3C6A),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recent.category ?? "",
                          maxLines: 1,
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          recent.question,
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    return Consumer<ChatHistoryProvider>(
      builder: (context, historyProvider, _) {
        if (historyProvider.loadingStatus == AppLoadingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (historyProvider.loadingStatus == AppLoadingStatus.success) {
          // AppSmallButton(
          //   title: historyProvider.clearLoadingStatus ==
          //       AppLoadingStatus.loading
          //       ? const CircularProgressIndicator()
          //       : Row(
          //     children: [
          //       const Spacer(),
          //       SvgPicture.asset("assets/icon/delete.svg"),
          //       const SizedBox(
          //         width: 12,
          //       ),
          //       const Text(
          //         "LocalizationManager()",
          //         style: TextStyle(
          //           fontSize: 16,
          //           color: Colors.black,
          //         ),
          //       ),
          //       const Spacer(),
          //     ],
          //   ),
          //   onTap: () {
          //     if (historyProvider.clearLoadingStatus !=
          //         AppLoadingStatus.loading) {
          //       if (historyProvider.ids.isEmpty) {
          //         AppConstants.getToast(
          //             message: LocalizationManager()
          //                 .translate('deleteMessage'));
          //       } else {
          //         historyProvider.onDeleteHistory(
          //             context: context, type: widget.type);
          //       }
          //     }
          //   },
          // )
          return Scaffold(
            bottomNavigationBar: historyProvider.ids.isEmpty
                ? null
                : Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8)
                            .copyWith(bottom: 4),
                    height: 50,
                    child: historyProvider.clearLoadingStatus ==
                            AppLoadingStatus.loading
                        ? AppSmallButton(
                            title: historyProvider.clearLoadingStatus ==
                                    AppLoadingStatus.loading
                                ? const CircularProgressIndicator()
                                : Row(
                                    children: [
                                      const Spacer(),
                                      SvgPicture.asset(
                                          "assets/icon/delete.svg"),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      const Text(
                                        "LocalizationManager()",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                            onTap: () {},
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: AppSmallButton(
                                  title: Text(
                                    // !historyProvider.isSelectAll
                                    // ?
                                    LocalizationManager()
                                        .translate('selectAll'),
                                    // : LocalizationManager().translate('deselectAll'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    // if(!historyProvider.isSelectAll) {
                                    historyProvider.selectAllChats();
                                    // } else {
                                    //   historyProvider.deSelectAll();
                                    // }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: AppSmallButton(
                                  title: Text(
                                    LocalizationManager().translate('clear'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    if (historyProvider.clearLoadingStatus !=
                                        AppLoadingStatus.loading) {
                                      if (historyProvider.ids.isEmpty) {
                                        AppConstants.getToast(
                                            message: LocalizationManager()
                                                .translate('deleteMessage'));
                                      } else {
                                        // confirmation dialog for chat delete
                                        showGeneralDialog(
                                          context: context,
                                          transitionBuilder:
                                              (dContext, a1, a2, _) {
                                            return Transform.scale(
                                              scale: a1.value,
                                              child: DeleteConfirmationDialog(
                                                onNo: () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pop(dContext);
                                                },
                                                onYes: () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pop(dContext);
                                                  historyProvider
                                                      .onDeleteHistory(
                                                    context: context,
                                                    type: widget.type,
                                                  );
                                                  // Navigator.pop(context);
                                                },
                                              ),
                                            );
                                          },
                                          pageBuilder: (context, animation1,
                                              animation2) {
                                            return const SizedBox();
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
            body: SafeArea(
              child: Column(
                children: [
                  buildAppBar(),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: SmartRefresher(
                      controller: RefreshController(initialRefresh: false),
                      onRefresh: () {
                        // adHelper.showAd(context: context);
                        historyProvider.getChatHistory(
                          context: context,
                          type: widget.type,
                          category: "",
                          tabId: '',
                        );
                      },
                      child: historyProvider.chatHistoryShowList
                              .toJson()
                              .values
                              .every((list) => list.isEmpty)
                          ? Column(
                              children: [
                                const Spacer(),
                                Center(
                                  child: Text(LocalizationManager()
                                      .translate('NoHistoryFound')),
                                ),
                                const Spacer(),
                              ],
                            )
                          : SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Column(
                                children: [
                                  // ...historyProvider.chatHistoryShowList.map(
                                  //     (search) => buildRecentCard(
                                  //         recent: search,
                                  //         provider: historyProvider))

                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: historyProvider
                                        .chatHistoryShowList
                                        .toJson()
                                        .length,
                                    itemBuilder: (context, index) {
                                      ChatHistoryModel data =
                                          historyProvider.chatHistoryShowList;

                                      var day =
                                          data.toJson().keys.toList()[index];

                                      List<ChatHistory> chatHistoryList =
                                          data.getListByKey(day, data);

                                      if (chatHistoryList.isNotEmpty) {
                                        return buildRecentCard(
                                          // recent: search,
                                          provider: historyProvider,
                                          day: day,
                                          chatDataList: data.getListByKey(
                                            day,
                                            data,
                                          ),
                                          mainIndex: index,
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),

                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   physics: const NeverScrollableScrollPhysics(),
                                  //   itemCount: historyProvider.chatHistoryShowList.toJson().length,
                                  //   itemBuilder: (context, index) {
                                  //     var data = historyProvider.chatHistoryShowList.toJson();
                                  //     var day = data.keys.toList()[index];
                                  //     List<ChatHistory> questions = data[day]!;
                                  //
                                  //     return Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Text(
                                  //             day,
                                  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  //           ),
                                  //         ),
                                  //         ListView.builder(
                                  //           shrinkWrap: true,
                                  //           physics: ClampingScrollPhysics(),
                                  //           itemCount: questions.length,
                                  //           itemBuilder: (context, qIndex) {
                                  //             var question = questions[qIndex];
                                  //             return ListTile(
                                  //               title: Text(question['question']),
                                  //               subtitle: Text('Category: ${question['category']}'),
                                  //             );
                                  //           },
                                  //         ),
                                  //         Divider(),
                                  //       ],
                                  //     );
                                  //   },
                                  // )
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return ErrorPage(onTap: () {
          HapticFeedback.lightImpact();
          historyProvider.getChatHistory(
              context: context, type: widget.type, category: "", tabId: '');
        });
      },
    );
    // provider.userDetail?.data != null
    // ? : const LoginModal();
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const DeleteConfirmationDialog(
      {super.key, required this.onYes, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocalizationManager().translate('deleteChat'),
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(LocalizationManager().translate('wantDeleteChat')),
            const SizedBox(
              height: 14.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.secondaryColor),
                  onPressed: onNo,
                  child: Text(
                    LocalizationManager().translate('no'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.secondaryColor),
                  onPressed: onYes,
                  child: Text(
                    LocalizationManager().translate('yes'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
