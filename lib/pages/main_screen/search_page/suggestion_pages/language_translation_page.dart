import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:provider/provider.dart';

import '../../../../provider/chat_provider.dart';
import '../../../../widget/app_back_button.dart';
import '../widget/suggestion_bottom_bar.dart';

class LanguageTranslationPage extends StatefulWidget {
  static const routeName = "language-translation-page";

  const LanguageTranslationPage({super.key});

  @override
  State<LanguageTranslationPage> createState() =>
      _LanguageTranslationPageState();
}

class _LanguageTranslationPageState extends State<LanguageTranslationPage> {
  int selectedLanguageIdx = 0;
  TextEditingController inputController = TextEditingController();

  late ChatProvider chatProvider;

  List<String> languageList = [
    "English",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Japanese",
    "Korean",
    "Arabic",
    "Russian",
    "Portuguese",
    "Italian",
    "Dutch",
    "Turkish",
    "Swedish",
    "Danish",
    "Norwegian",
    "Finnish",
    "Greek",
    "Hindi",
    "Bengali",
    "Urdu",
    "Thai",
    "Vietnamese",
    "Hebrew",
    "Malay",
    "Indonesian",
    "Filipino",
    "Swahili",
    "Romanian",
    "Polish",
    "Ukrainian",
    "Czech",
    "Hungarian",
    "Bulgarian",
    "Croatian",
    "Serbian",
    "Slovak",
    "Slovenian"
  ];

  void _getLatestValue() {
    final text = inputController.text.trim();

    chatProvider.setKey(key: 'question', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (selectedLanguageIdx == 0) {
        chatProvider.setKey(key: 'language', value: languageList[selectedLanguageIdx]);
      }
      inputController.addListener(_getLatestValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String receivedArgument =
        ModalRoute.of(context)!.settings.arguments.toString();

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
                ...languageList.map((language) {
                  int currentIdx = languageList.indexOf(language);
                  bool isSelected = currentIdx == selectedLanguageIdx;

                  // print(currentIdx);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedLanguageIdx = currentIdx;
                        chatProvider.setKey(key: 'language', value: languageList[selectedLanguageIdx]);
                      });
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
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

    buildAppBar() {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Row(
          children: [
            const AppBackButton(),
            const Spacer(),
            Text(
              receivedArgument,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              width: 12,
            ),
            const Spacer(),
          ],
        ),
      );
    }

    buildLanguageSelector() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
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
                  languageList[selectedLanguageIdx],
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down_outlined)
              ],
            ),
          ),
        ),
      );
    }

    chatProvider.setKey(key: 'category', value: receivedArgument);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: Scaffold(
                bottomNavigationBar: SuggestionBottomBar(
                  title: receivedArgument,
                ),
                body: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      buildLanguageSelector(),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade900.withOpacity(.8),
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: inputController,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: LocalizationManager()
                                .translate('WriteSomethingToTranslate'),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      )
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
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    chatProvider.clearMap();
    super.dispose();
  }
}
