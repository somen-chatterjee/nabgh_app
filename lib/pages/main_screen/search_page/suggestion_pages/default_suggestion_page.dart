import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/pages/main_screen/search_page/advance_filter_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestion_text_field.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:nabgh_app/provider/scan_data_provider.dart';
import 'package:nabgh_app/provider/search_provider.dart';
import 'package:nabgh_app/widget/app_back_button.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';

import '../../../../enum/app_loading_staus.dart';
import '../../../../router.dart';
import '../result_page.dart';
import '../widget/scanner.dart';
import '../widget/suggestion_bottom_bar.dart';

class DefaultSuggestionPage extends StatefulWidget {
  static const routeName = "default-suggestion-page";
  final String title;

  const DefaultSuggestionPage({super.key, required this.title});

  @override
  State<DefaultSuggestionPage> createState() => _DefaultSuggestionPageState();
}

class _DefaultSuggestionPageState extends State<DefaultSuggestionPage> {
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
          const SizedBox(
            width: 22,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  TextEditingController inputController = TextEditingController();

  late SearchProvider searchProvider;
  late ScanDataProvider scanDataProvider;
  late ChatProvider chatProvider;

  void _getLatestValue() {
    final text = inputController.text.trim();

    chatProvider.setKey(key: 'question', value: text);
  }

  String giveHint({int? id}) {
    if (id != null) {
      if (id == 4) {
        return LocalizationManager().translate('academicHint');
      }
      if (id == 5) {
        return LocalizationManager().translate('grammarHint');
      }
      if (id == 6) {
        return LocalizationManager().translate('comedyHint');
      }
      if (id == 7) {
        return LocalizationManager().translate('lyricsHint');
      }
      if (id == 8) {
        return LocalizationManager().translate('storyTellingHint');
      }
      if (id == 10) {
        return LocalizationManager().translate('poemHint');
      }
      if (id == 11) {
        return LocalizationManager().translate('letterHint');
      }
      if (id == 12) {
        return LocalizationManager().translate('easyHint');
      }
      if (id == 13) {
        return LocalizationManager().translate('complaintsHint');
      }
      if (id == 18) {
        return LocalizationManager().translate('phrasingHint');
      }
      if (id == 19) {
        return LocalizationManager().translate('summaryHint');
      }
      if (id == 20) {
        return LocalizationManager().translate('plagiarismHint');
      }
      if (id == 21) {
        return LocalizationManager().translate('symptomHint');
      }
      if (id == 22) {
        return LocalizationManager().translate('mentalHealthHint');
      }
      if (id == 23) {
        return LocalizationManager().translate('fitnessHint');
      }
      if (id == 25) {
        return LocalizationManager().translate('mathHint');
      }
      if (id == 26) {
        return LocalizationManager().translate('homeWorkHint');
      }
      if (id == 27) {
        return LocalizationManager().translate('historyHint');
      }
      if (id == 28) {
        return LocalizationManager().translate('scienceHint');
      }
      if (id == 29) {
        return LocalizationManager().translate('islamicHint');
      }
      if (id == 30) {
        return LocalizationManager().translate('cvBuildingHint');
      }
      if (id == 31) {
        return LocalizationManager().translate('jobSearchHint');
      }
      if (id == 32) {
        return LocalizationManager().translate('conflictHint');
      }
      if (id == 33) {
        return LocalizationManager().translate('managementHint');
      }
      if (id == 34) {
        return LocalizationManager().translate('parentingHint');
      }
      if (id == 36) {
        return LocalizationManager().translate('chefNabeghHint');
      }
      if (id == 37) {
        return LocalizationManager().translate('relationshipHint');
      }
      if (id == 38) {
        return LocalizationManager().translate('familyBudgetHint');
      }
      if (id == 39) {
        return LocalizationManager().translate('passGenHint');
      }
      if (id == 40) {
        return LocalizationManager().translate('dreamInterpreterHint');
      }
      if (id == 41) {
        return LocalizationManager().translate('talkWithNabighHint');
      }
      if (id == 42) {
        return LocalizationManager().translate('policyHint');
      }
      if (id == 43) {
        return LocalizationManager().translate('deviceCareHint');
      }
    }
    return LocalizationManager().translate('defaultHint');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      inputController.addListener(_getLatestValue);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    searchProvider = Provider.of<SearchProvider>(context);
    scanDataProvider = Provider.of<ScanDataProvider>(context);
    chatProvider = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchProvider.clearSuggestionId();
    scanDataProvider.clearData();
    inputController.dispose();
    chatProvider.clearMap();
    super.dispose();
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
                      Consumer2<SearchProvider, ScanDataProvider>(
                        builder:
                            (context, searchProvider, scanDataProvider, child) {
                          var id = searchProvider.suggestionSubCategoryModel.id;
                          if (scanDataProvider.scanText != null) {
                            inputController.text = scanDataProvider.scanText!;
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900.withOpacity(.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                SuggestionTextField(
                                  controller: inputController,
                                  lines: 10,
                                  hintText: giveHint(id: id),
                                  scanner:
                                      id != null && id == 25 ? true : false,
                                ),
                                if (id != null && id == 25)
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
}
