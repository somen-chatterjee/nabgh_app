import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../change_language/language_helper.dart';
import '../../../../constatns/app_constants.dart';
import '../../../../provider/chat_provider.dart';

class SuggestionFilter extends StatefulWidget {
  final List<String> suggestionList;

  final String title;

  const SuggestionFilter(
      {super.key, required this.suggestionList, required this.title,});

  @override
  State<SuggestionFilter> createState() => _SuggestionFilterState();
}

class _SuggestionFilterState extends State<SuggestionFilter> {
  late ChatProvider chatProvider;

  int selectedIdx = 0;

  buildToneTag({required String suggestion}) {
    int currIdx = widget.suggestionList.indexOf(suggestion);
    return Padding(
      padding: const EdgeInsets.only(right: 12, bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          setState(() {
            selectedIdx = currIdx;
            setFilter();
            HapticFeedback.lightImpact();
          });
        },
        child: selectedIdx == currIdx
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
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xff3E3E3E),
                ),
                child: Text(
                  suggestion,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ),
      ),
    );
  }

  buildFilter() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      children: [
        ...widget.suggestionList
            .map((suggestion) => buildToneTag(suggestion: suggestion))
      ],
    );
  }

  setFilter() {
    if (widget.title == LocalizationManager().translate("Topic")) {
      chatProvider.setKey(
          key: 'int_topic', value: widget.suggestionList[selectedIdx]);
    } else {
      chatProvider.setKey(
          key: 'tone', value: widget.suggestionList[selectedIdx]);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider = Provider.of<ChatProvider>(context, listen: false);
      setFilter();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        buildFilter(),
      ],
    );
  }
}
