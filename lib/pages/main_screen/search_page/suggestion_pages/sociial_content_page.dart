import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestion_text_field.dart';
import 'package:provider/provider.dart';
import '../../../../provider/chat_provider.dart';
import '../widget/suggestion_app_bar.dart';
import '../widget/suggestion_bottom_bar.dart';

class SocialContentPage extends StatefulWidget {
  static const routeName = "social-content-page";

  const SocialContentPage({super.key});

  @override
  State<SocialContentPage> createState() => _LanguageTranslationPageState();
}

class _LanguageTranslationPageState extends State<SocialContentPage> {

  int selectedIdx = 0;
  List<String> filterList = [
    LocalizationManager().translate("Twitter"),
    LocalizationManager().translate("Facebook"),
    LocalizationManager().translate("Linkedin")
  ];

  TextEditingController contentController = TextEditingController();

  late ChatProvider chatProvider;

  getBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ...filterList.map((language) {
                int currentIdx = filterList.indexOf(language);
                bool isSelected = currentIdx == selectedIdx;

                print(currentIdx);
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIdx = currentIdx;
                      chatProvider.setKey(key: 'social_type', value: filterList[selectedIdx]);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Text(language),
                        const Spacer(),
                        isSelected
                            ? const Icon(Icons.radio_button_checked_outlined)
                            : const Icon(Icons.radio_button_off),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        );
      },
    );
  }

  buildLanguageSelector() {
    return InkWell(
      onTap: () {
        getBottomSheet();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(.3)),
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey.shade900),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Text(
              filterList[selectedIdx],
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down_outlined)
          ],
        ),
      ),
    );
  }

  void _getLatestValue() {
    final text = contentController.text.trim();

    chatProvider.setKey(key: 'question', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.setKey(key: 'social_type', value: filterList[selectedIdx]);
      contentController.addListener(_getLatestValue);
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
                  title: receivedArgument,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      buildLanguageSelector(),
                      const SizedBox(height: 12),
                      SuggestionTextField(
                          hintText: LocalizationManager()
                              .translate('WriteTopicAbout'),
                          controller: contentController,
                          lines: 10)
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
    contentController.dispose();
    chatProvider.clearMap();
    super.dispose();
  }
}
