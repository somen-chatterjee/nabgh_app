import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/models/api_model/chat_history.dart';
import 'package:nabgh_app/pages/main_screen/search_page/result_page_view.dart';
import 'package:nabgh_app/provider/chat_history_provider.dart';
import 'package:provider/provider.dart';

import '../../../../change_language/language_helper.dart';
import '../../../../constatns/app_constants.dart';
import '../../../../enum/app_loading_staus.dart';
import '../../../../widget/app_back_button.dart';
import '../../../../widget/app_small_button.dart';

class SearchHistory extends StatefulWidget {
  final String title;

  const SearchHistory({super.key, required this.title});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  late ChatHistoryProvider pChatHistory;

  buildChatCard(
      {required ChatHistory chatHistory,
      required String question,
      required String answer}) {
    return InkWell(
      onTap: () {
        if (pChatHistory.ids.isNotEmpty) {
          int currIdx = pChatHistory.chatHistoryList.indexOf(chatHistory);
          // pChatHistory.onHistorySelect(id: currIdx);
        } else {
          //navigate to chat screen to create new chat
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ResultViewPage(title: widget.title, question: question,answer: answer,);
          },));
        }
      },
      onLongPress: () {
        int currIdx = pChatHistory.chatHistoryList.indexOf(chatHistory);
        // pChatHistory.onHistorySelect(id: currIdx);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              color: chatHistory.isSelected
                  ? const Color(0xff3C3C6A)
                  : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              question,
              // LocalizationManager().translate('DemoResultText'),
              maxLines: 2,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(.75),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    pChatHistory = Provider.of<ChatHistoryProvider>(context, listen: false);
    pChatHistory.getChatHistory(
        context: context, type: 1, category: widget.title,
    tabId: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHistoryProvider>(
      builder: (context, value, child) {
        return Scaffold(
          bottomNavigationBar: pChatHistory.loadingStatus ==
                  AppLoadingStatus.loading
              ? const SizedBox()
              : pChatHistory.ids.isEmpty
                  ? null
                  : Container(
                      margin: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8)
                          .copyWith(bottom: 4),
                      height: 50,
                      child: pChatHistory.clearLoadingStatus ==
                              AppLoadingStatus.loading
                          ? AppSmallButton(
                              title: pChatHistory.clearLoadingStatus ==
                                      AppLoadingStatus.loading
                                  ? const CircularProgressIndicator()
                                  : const SizedBox(),
                              // const Row(
                              //   children: [
                              //     Spacer(),
                              //     SizedBox(
                              //       width: 12,
                              //     ),
                              //     Text(
                              //       "LocalizationManager()",
                              //       style: TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //     Spacer(),
                              //   ],
                              // ),
                              onTap: () {},
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: AppSmallButton(
                                    title: const Text(
                                      "Select all",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      pChatHistory.selectAllChats();
                                      // if (historyProvider.clearLoadingStatus !=
                                      //     AppLoadingStatus.loading) {
                                      //   if (historyProvider.ids.isEmpty) {
                                      //     AppConstants.getToast(
                                      //         message: LocalizationManager()
                                      //             .translate('deleteMessage'));
                                      //   } else {
                                      //     historyProvider.onDeleteHistory(
                                      //         context: context, type: widget.type);
                                      //   }
                                      // }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppSmallButton(
                                    title: const Text(
                                      "Clear",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      if (pChatHistory.clearLoadingStatus !=
                                          AppLoadingStatus.loading) {
                                        HapticFeedback.lightImpact();
                                        if (pChatHistory.ids.isEmpty) {
                                          AppConstants.getToast(
                                              message: LocalizationManager()
                                                  .translate('deleteMessage'));
                                        } else {
                                          pChatHistory.onDeleteHistory(
                                            context: context,
                                            type: 1,
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
                  height: 12,
                ),
                Expanded(
                  child: pChatHistory.loadingStatus == AppLoadingStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : pChatHistory.chatHistoryList.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: ListView.builder(
                                itemCount: pChatHistory.chatHistoryList.length,
                                itemBuilder: (context, index) => buildChatCard(
                                  chatHistory:
                                      pChatHistory.chatHistoryList[index],
                                  question: pChatHistory
                                      .chatHistoryList[index].question,
                                  answer: pChatHistory
                                      .chatHistoryList[index].answer,
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                LocalizationManager().translate('noDataFound'),
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    pChatHistory.clearChatHistory();
    pChatHistory.clearIds();
    super.dispose();
  }
}
