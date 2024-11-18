import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestion_text_field.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:provider/provider.dart';
import '../../../../provider/scan_data_provider.dart';
import '../../../../router.dart';
import '../widget/scanner.dart';
import '../widget/suggestion_app_bar.dart';
import '../widget/suggestion_bottom_bar.dart';

class WriteEmailPage extends StatefulWidget {
  static const routeName = "write-email-page";

  const WriteEmailPage({super.key});

  @override
  State<WriteEmailPage> createState() => _LanguageTranslationPageState();
}

class _LanguageTranslationPageState extends State<WriteEmailPage> {
  late ScanDataProvider scanDataProvider;
  late ChatProvider chatProvider;

  int selectedIdx = 0;
  List<String> filterList = [
    LocalizationManager().translate('CreateNew'),
    LocalizationManager().translate("Reply")
  ];

  TextEditingController emailController = TextEditingController();

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

                // print(currentIdx);
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIdx = currentIdx;
                      chatProvider.setKey(key: 'email_type', value: filterList[selectedIdx]);
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
    final text = emailController.text.trim();

    chatProvider.setKey(key: 'question', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.setKey(key: 'email_type', value: filterList[selectedIdx]);
      emailController.addListener(_getLatestValue);
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
                      Consumer<ScanDataProvider>(
                        builder: (context, value, child) {
                          if (value.scanText != null) {
                            emailController.text = value.scanText!;
                          }
                          return Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              SuggestionTextField(
                                hintText: selectedIdx == 0 ? LocalizationManager()
                                    .translate('WriteAbout') : LocalizationManager()
                                    .translate('replyEmail') ,
                                controller: emailController,
                                lines: 10,
                                scanner: true,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    navigatorKey.currentState!.pushNamed(
                                        Scanner.routeName,
                                        arguments: "",
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.document_scanner_outlined,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
  void didChangeDependencies() {
    scanDataProvider = Provider.of<ScanDataProvider>(context);
    chatProvider = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    emailController.dispose();
    scanDataProvider.clearData();
    chatProvider.clearMap();
    super.dispose();
  }
}
