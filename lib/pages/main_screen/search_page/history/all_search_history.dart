import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:provider/provider.dart';

import '../../../../constatns/app_constants.dart';
import '../../../../enum/app_loading_staus.dart';
import '../../../../models/model/suggestion_category_model.dart';
import '../../../../provider/search_provider.dart';
import '../../../../widget/app_back_button.dart';

class AllSearchHistory extends StatefulWidget {
  const AllSearchHistory({super.key});

  @override
  State<AllSearchHistory> createState() => _AllSearchHistoryState();
}

class _AllSearchHistoryState extends State<AllSearchHistory> {
  int selectedTagIdx = 0;

  buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            LocalizationManager().translate('History'),
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          const SizedBox(
            width: 22,
          ),
        ],
      ),
    );
  }

  historyCard() {
    return Container(
      // height: 200.0,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xff3E3E3E),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Question",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.trash,
            color: Colors.grey,
            size: 25.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    buildTag(
        {required SuggestionCategoryModel suggestion,
        required List<SuggestionCategoryModel> allSuggestionList,
        required SearchProvider provider}) {
      int currIdx = allSuggestionList.indexOf(suggestion);
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            setState(() {
              selectedTagIdx = currIdx;
              provider.getSuggestion(
                context: context,
                categoryId: suggestion.id!,
                index: selectedTagIdx,
                initial: false,
                isRefreshed: false,
              );
            });
          },
          child: selectedTagIdx == currIdx
              ? Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: AppConstants.gradient,
                  ),
                  child: Text(
                    suggestion.title!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xff3E3E3E),
                  ),
                  child: Text(
                    suggestion.title!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
        ),
      );
    }

    buildTags() {
      return Consumer<SearchProvider>(
        builder: (context, provider, child) {
          return provider.loadingStatus != AppLoadingStatus.loading
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...provider.suggestionCategoryList.map(
                        (suggestion) => buildTag(
                          suggestion: suggestion,
                          allSuggestionList: provider.suggestionCategoryList,
                          provider: provider,
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox();
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            buildTags(),
            const SizedBox(
              height: 12.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return historyCard();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
