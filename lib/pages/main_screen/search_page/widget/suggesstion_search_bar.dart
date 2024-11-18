import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/scanner.dart';
import 'package:nabgh_app/router.dart';

import '../../chat_page/search_chat_screen.dart';

class SuggestionSearchBar extends StatefulWidget {
  final GlobalKey? coachKey;

  const SuggestionSearchBar({super.key, this.coachKey});

  @override
  State<SuggestionSearchBar> createState() => _SuggestionSearchBarState();
}

class _SuggestionSearchBarState extends State<SuggestionSearchBar> {
  final FocusNode _focus = FocusNode();

  bool isAnimate = true;

  final searchController = TextEditingController();

  changeField() {
    setState(() {
      isAnimate = !isAnimate;
    });
  }

  void _onFocusChange() {
    // debugPrint("Somen: ${_focus.hasFocus.toString()}");
    if (!_focus.hasFocus) {
      changeField();
    }
  }

  void onMassageSend() {
    if (searchController.text.trim().isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return SearchChatPage(
              title: LocalizationManager().translate('Search'),
              value: searchController.text.trim(),
              scanned: false,
            );
          },
        ),
      ).then((value) {
        setState(() {
          searchController.clear();
        });
      });
      // Navigator.of(context).pushNamed(ChatPage.routeName,arguments: value.trim());
      // changeField();
    }
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // print("Tap Event");
        // changeField();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return SearchChatPage(
                title: LocalizationManager().translate('Search'),
                value: searchController.text.trim(),
                scanned: false,
              );
            },
          ),
        );
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(.15), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 50,
        width: 500,
        child: Row(
          key: widget.coachKey,
          children: [
            const Icon(
              Icons.search,
              color: Colors.white70,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: isAnimate
                  ? DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                      child: IgnorePointer(
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText(
                              LocalizationManager().translate('HowICanHelpYou'),
                              duration: const Duration(milliseconds: 2000),
                            ),
                            FadeAnimatedText(
                                LocalizationManager()
                                    .translate('SearchAnything'),
                                duration: const Duration(milliseconds: 2000)),
                            FadeAnimatedText(
                                // LocalizationManager().translate('AskMeAnything'),
                                LocalizationManager().translate('TalkNabigh'),
                                duration: const Duration(milliseconds: 2000)),
                          ],
                          onTap: () {},
                        ),
                      ),
                    )
                  : TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            LocalizationManager().translate('SearchAnything'),
                      ),
                      focusNode: _focus,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                      onFieldSubmitted: (value) {
                        // print("onFieldSubmitted called");
                        onMassageSend();
                        // if (value.trim().isEmpty) {
                        //   changeField();
                        // } else {
                      },
                    ),
            ),
            const SizedBox(
              width: 12,
            ),
            searchController.text.isEmpty
                ? InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      navigatorKey.currentState!
                          .pushNamed(Scanner.routeName, arguments: "search");
                    },
                    child: const Icon(
                      Icons.document_scanner_outlined,
                      color: Colors.white70,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      onMassageSend();
                    },
                    child: SvgPicture.asset("assets/icon/send.svg"),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }
}
