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

class ResultViewPage extends StatefulWidget {
  final String title;
  final String question;
  final String answer;

  const ResultViewPage({super.key, required this.title, required this.question, required this.answer});

  @override
  State<ResultViewPage> createState() => _ResultViewPageState();
}

class _ResultViewPageState extends State<ResultViewPage> {
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
                    HapticFeedback.lightImpact();
                    Share.share(/*value.chatResponse ?? */widget.answer);
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
                    HapticFeedback.lightImpact();
                    Clipboard.setData(
                            ClipboardData(text: /*value.chatResponse ?? */widget.answer))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(LocalizationManager()
                              .translate('CopiedClipboard'))));
                    });
                    Navigator.pop(context);
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

  String question = "";

  late ChatProvider chatProvider;

  @override
  void initState() {
    question = widget.question;
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
    super.initState();
  }

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
                /*bottomNavigationBar: Consumer<ChatProvider>(
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
                          pChat.chatGpt(
                            context: context,
                            postBody: pChat.postBody,
                            isDiscover: false,
                          );
                          // Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),*/
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
                              question,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 18),
                            ),
                          ),
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
                              // provider.loadingStatus == AppLoadingStatus.loading
                              //     ? LocalizationManager().translate('aiTyping')
                              //     : provider.chatResponse ??
                                  widget.answer,
                              // LocalizationManager().translate('DemoResultText'),
                              style: TextStyle(
                                fontSize: 15,
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
