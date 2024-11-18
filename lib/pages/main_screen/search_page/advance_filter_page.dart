import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';

import '../../../constatns/app_constants.dart';
import '../../../provider/chat_provider.dart';
import '../../../widget/app_back_button.dart';

class AdvanceFilterPage extends StatefulWidget {
  const AdvanceFilterPage({super.key});

  @override
  State<AdvanceFilterPage> createState() => _AdvanceFilterPageState();
}

class _AdvanceFilterPageState extends State<AdvanceFilterPage> {
  int toneSelectedIdx = 0;
  int lengthSelectedIdx = 0;

  List<String> toneList = [
    LocalizationManager().translate('Formal'),
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

  List<String> lengthList = [
    LocalizationManager().translate("Short"),
    LocalizationManager().translate("Medium"),
    LocalizationManager().translate("Long")
  ];

  late ChatProvider pChat;

  @override
  void didChangeDependencies() {
    pChat = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    buildToneTag({required String suggestion}) {
      int currIdx = toneList.indexOf(suggestion);
      return Padding(
        padding: const EdgeInsets.only(right: 12, bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            setState(() {
              HapticFeedback.lightImpact();
              toneSelectedIdx = currIdx;
            });
          },
          child: toneSelectedIdx == currIdx
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: AppConstants.gradient),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ))
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xff3E3E3E)),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  )),
        ),
      );
    }

    buildToneFilter() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          children: [
            ...toneList
                .map((suggestion) => buildToneTag(suggestion: suggestion))
          ],
        ),
      );
    }

    buildLengthTag({required String suggestion}) {
      int currIdx = lengthList.indexOf(suggestion);
      return Padding(
        padding: const EdgeInsets.only(right: 12, bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            setState(() {
              HapticFeedback.lightImpact();
              lengthSelectedIdx = currIdx;
            });
          },
          child: lengthSelectedIdx == currIdx
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: AppConstants.gradient),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ))
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xff3E3E3E)),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  )),
        ),
      );
    }

    buildLengthFilter() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Wrap(
          children: [
            ...lengthList
                .map((suggestion) => buildLengthTag(suggestion: suggestion))
          ],
        ),
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
              LocalizationManager().translate('AdvanceFilter'),
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

    buildDivider() {
      return Container(
        height: 1,
        width: double.infinity,
        color: Colors.white.withOpacity(.1),
      );
    }

    return Scaffold(
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(bottom: 16, top: 8),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: .5),
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.grey.shade900),
                  child: Center(
                    child: Text(
                      LocalizationManager().translate('Cancel'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: AppSmallButton(
                title: Text(
                  LocalizationManager().translate('Apply'),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  pChat.setKey(key: 'tone', value: toneList[toneSelectedIdx]);
                  pChat.setKey(
                      key: 'length', value: lengthList[lengthSelectedIdx]);

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LocalizationManager().translate('Tone'),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    buildToneFilter(),
                    const SizedBox(
                      height: 4,
                    ),
                    buildDivider(),
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LocalizationManager().translate("Length"),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    buildLengthFilter(),
                    const SizedBox(
                      height: 4,
                    ),
                    buildDivider(),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
