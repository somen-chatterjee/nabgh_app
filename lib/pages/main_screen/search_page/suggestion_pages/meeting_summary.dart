import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestion_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../provider/chat_provider.dart';
import '../widget/suggestion_app_bar.dart';
import '../widget/suggestion_bottom_bar.dart';
import '../widget/suggestionn_filter.dart';

class MeetingSummeryPage extends StatefulWidget {
  static const routeName = "meeting-summery-page";

  const MeetingSummeryPage({super.key});

  @override
  State<MeetingSummeryPage> createState() => _MeetingSummeryPageState();
}

class _MeetingSummeryPageState extends State<MeetingSummeryPage> {
  late ChatProvider chatProvider;

  TextEditingController noteController = TextEditingController();

  List<String> toneList = [
    LocalizationManager().translate("Formal"),
    LocalizationManager().translate("Informal"),
    LocalizationManager().translate("Optimistic"),
    LocalizationManager().translate("Worried"),
    LocalizationManager().translate("Friendly"),
    LocalizationManager().translate("Curious"),
    LocalizationManager().translate("Assertive"),
    LocalizationManager().translate("Encouraging"),
    LocalizationManager().translate("Surprised"),
    LocalizationManager().translate("Cooperative")
  ];

  void _getLatestValue() {
    final text = noteController.text.trim();

    chatProvider.setKey(key: 'question', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // chatProvider.setKey(key: 'email_type', value: filterList[selectedIdx]);
      noteController.addListener(_getLatestValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String receivedArgument =
        ModalRoute.of(context)!.settings.arguments.toString();
    chatProvider.setKey(key: 'category', value: receivedArgument);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SuggestionAppBar(
              title: receivedArgument,
            ),
            Expanded(
              child: Scaffold(
                bottomNavigationBar: SuggestionBottomBar(
                  title: LocalizationManager().translate('MeetingSummary'),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      SuggestionTextField(
                        hintText:
                            LocalizationManager().translate('MeetingNote'),
                        lines: 8,
                        controller: noteController,
                        title:
                            LocalizationManager().translate('EnterMeetingNote'),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      SuggestionFilter(
                        suggestionList: toneList,
                        title: LocalizationManager().translate("Tone"),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    noteController.dispose();
    chatProvider.clearMap();
    super.dispose();
  }
}
