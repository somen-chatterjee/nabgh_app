import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/pages/main_screen/search_page/history/search_history.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../enum/app_loading_staus.dart';
import '../../../widget/app_back_button.dart';
import '../../../widget/app_small_button.dart';

class ResultPage extends StatefulWidget {
  final String title;
  final String question;

  const ResultPage({super.key, required this.title, required this.question});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  final CancelToken _cancelToken = CancelToken();

  getBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade800,
      builder: (BuildContext context) {
        return Consumer<ChatProvider>(
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    CupertinoIcons.share,
                    color: Colors.white.withOpacity(.9),
                    size: 22,
                  ),
                  title: Text(
                    LocalizationManager().translate('Share'),
                    style: TextStyle(
                        color: Colors.white.withOpacity(.8), fontSize: 16),
                  ),
                  onTap: () {
                    Share.share(value.chatResponse ?? "");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.doc_on_clipboard,
                    color: Colors.white.withOpacity(.9),
                    size: 22,
                  ),
                  title: Text(
                    LocalizationManager().translate('Copy'),
                    style: TextStyle(
                        color: Colors.white.withOpacity(.8), fontSize: 16),
                  ),
                  onTap: () {
                    Clipboard.setData(
                            ClipboardData(text: value.chatResponse ?? ""))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(LocalizationManager()
                              .translate('CopiedClipboard'))));
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Colors.white.withOpacity(.9),
                    size: 22,
                  ),
                  title: Text(
                    LocalizationManager().translate('History'),
                    style: TextStyle(
                      color: Colors.white.withOpacity(.8),
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SearchHistory(
                            title: widget.title,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

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
          IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                getBottomSheet();
              },
              icon: const Icon(Icons.more_vert_sharp))
        ],
      ),
    );
  }

  late ChatProvider chatProvider;

  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: Scaffold(
                bottomNavigationBar: Consumer<ChatProvider>(
                  builder: (context, pChat, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ).copyWith(bottom: 12, top: 8),
                      height: 70,
                      child: AppSmallButton(
                        title: pChat.loadingStatus == AppLoadingStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                LocalizationManager().translate('Regenerate'),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          pChat.chatGpt(
                            context: context,
                            postBody: pChat.postBody,
                            isDiscover: false,
                            cancelToken: _cancelToken,
                          );
                          // Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.question,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 18),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppConstants.secondaryColor,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Consumer<ChatProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              provider.loadingStatus == AppLoadingStatus.loading
                                  ? LocalizationManager().translate('aiTyping')
                                  : provider.chatResponse ?? "",
                              // LocalizationManager().translate('DemoResultText'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(.75),
                              ),
                            ),
                          );
                        },
                      ),
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

  @override
  void dispose() {
    chatProvider.clearResponse();
    super.dispose();
  }
}
