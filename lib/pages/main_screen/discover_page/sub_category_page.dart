import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/models/model/sub_child_discover_model.dart';
import 'package:nabgh_app/pages/main_screen/chat_page/discover_chat_screen.dart';
import 'package:nabgh_app/provider/discover_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../enum/app_loading_staus.dart';
import '../../../models/model/discover_card_model.dart';
import '../../../models/model/sub_discover_model.dart';
import '../../../widget/app_back_button.dart';
import '../../../widget/progress_page.dart';
import '../../../widget/user_profile.dart';

class SubCategoryPage extends StatefulWidget {
  final String title;
  final int id;

  const SubCategoryPage({super.key, required this.title, required this.id});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {

  List<DiscoverCardModel> educationCardList = [
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/caption.svg',
        title: LocalizationManager().translate('WordAssociations'),
        subTitle: LocalizationManager().translate('ExpandYourAssociations')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/grammar.svg',
        title: LocalizationManager().translate('GrammarCheck'),
        subTitle: LocalizationManager().translate('CheckAndCorrect')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/paraphrasing.svg',
        title: LocalizationManager().translate('Paraphrasing'),
        subTitle: LocalizationManager().translate('RestatingOwnWords')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/riddles.svg',
        title: LocalizationManager().translate('WordplayRiddles'),
        subTitle: LocalizationManager().translate('SolveVocabulary')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/explorations.svg',
        title: LocalizationManager().translate('IdiomExplorations'),
        subTitle: LocalizationManager().translate('ExploreExpressions')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/proverbs.svg',
        title: LocalizationManager().translate('DailyProverbs'),
        subTitle: LocalizationManager().translate('LearnEnglishProverbs')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/translation.svg',
        title: LocalizationManager().translate('LanguageTranslation'),
        subTitle: LocalizationManager().translate('GetTranslation')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/solutions.svg',
        title: LocalizationManager().translate('MathSolutions'),
        subTitle: LocalizationManager().translate('GetSolutions')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/study-guides.svg',
        title: LocalizationManager().translate('StudyGuides'),
        subTitle: LocalizationManager().translate('AccessGuides')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/write_assistance.svg',
        title: LocalizationManager().translate('WritingAssistance'),
        subTitle: LocalizationManager().translate('GetTips')),
  ];

  List<DiscoverCardModel> funCardList = [
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/translation.svg',
        title: LocalizationManager().translate('EmojiTranslator'),
        subTitle: LocalizationManager().translate('ConvertExpressions')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/netflix.svg',
        title: LocalizationManager().translate('NetflixByMood'),
        subTitle: LocalizationManager().translate('NetflixMood')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/apple-tv.svg',
        title: LocalizationManager().translate('AppleTVByMood'),
        subTitle: LocalizationManager().translate('AppleTVMood')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/prime.svg',
        title: LocalizationManager().translate('PrimeByMood'),
        subTitle: LocalizationManager().translate('PrimeMood')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/films.svg',
        title: LocalizationManager().translate('FilmsByMood'),
        subTitle: LocalizationManager().translate('FilmsMood')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/song.svg',
        title: LocalizationManager().translate('SongsByMood'),
        subTitle: LocalizationManager().translate('SongsMood')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/party.svg',
        title: LocalizationManager().translate('KaraokeParty'),
        subTitle: LocalizationManager().translate('OrganizeSessions')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/club.svg',
        title: LocalizationManager().translate('BookClub'),
        subTitle: LocalizationManager().translate('StartFriends')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/movie.svg',
        title: LocalizationManager().translate('MovieMarathon'),
        subTitle: LocalizationManager().translate('EnjoyFriends')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/artwork.svg',
        title: LocalizationManager().translate('ArtworkInspiration'),
        subTitle: LocalizationManager().translate('GetProject')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/write_assistance.svg',
        title: LocalizationManager().translate('LyricWriter'),
        subTitle: LocalizationManager().translate('GenerateMusic')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/search-insights.svg',
        title: LocalizationManager().translate('LyricInspiration'),
        subTitle: LocalizationManager().translate('FindSongwriting')),
  ];

  List<DiscoverCardModel> forWorkCardList = [
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/gmail.svg',
        title: LocalizationManager().translate('EmailDrafting'),
        subTitle: LocalizationManager().translate('DraftProfessionalEmails')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/project-management.svg',
        title: LocalizationManager().translate('ProjectManagement'),
        subTitle: LocalizationManager().translate('AssistCoordination')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/analytic-graph.svg',
        title: LocalizationManager().translate('DataAnalysis'),
        subTitle: LocalizationManager().translate('AnalyzeData')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/associations.svg',
        title: LocalizationManager().translate('TaskOrganizer'),
        subTitle: LocalizationManager().translate('PlanWorkTasks')),
  ];

  List<DiscoverCardModel> socialMediaCardList = [
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/twitter.svg',
        title: LocalizationManager().translate('Tweets'),
        subTitle: LocalizationManager().translate('ComposeTwitterAPosts')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/share.svg',
        title: LocalizationManager().translate('ShareArticleLink'),
        subTitle: LocalizationManager().translate('TurnATweet')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/retweet.svg',
        title: LocalizationManager().translate('Retweet'),
        subTitle: LocalizationManager().translate('RetweetWithComment')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/hashtag.svg',
        title: LocalizationManager().translate('Hashtags'),
        subTitle: LocalizationManager().translate('ComposeHashtagsTweet')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/posts.svg',
        title: LocalizationManager().translate('Posts'),
        subTitle: LocalizationManager().translate('ComposeInstagramPosts')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/caption.svg',
        title: LocalizationManager().translate('Captions'),
        subTitle: LocalizationManager().translate('ComposeInstagramCaptions')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/responsibility.svg',
        title: LocalizationManager().translate('Response'),
        subTitle: LocalizationManager().translate('CommentInstagramPost')),
    DiscoverCardModel(
        imgSrc: 'assets/sub_category/hashtag.svg',
        title: LocalizationManager().translate('Hashtags'),
        subTitle: LocalizationManager().translate('ComposeHashtagsInstagram')),
    /*DiscoverCardModel(
        imgSrc: 'assets/discover/translator.svg',
        title: 'Translator',
        subTitle: 'Extract key points from long text.'),
    DiscoverCardModel(
        imgSrc: 'assets/discover/art.svg',
        title: 'Health',
        subTitle: 'Extract key points from long text.'),
    DiscoverCardModel(
        imgSrc: 'assets/discover/music.svg',
        title: 'Music',
        subTitle: 'Extract key points from long text.'),*/
  ];

  selectCardList(String title) {
    if (title == LocalizationManager().translate('Education')) {
      return educationCardList;
    }
    if (title == LocalizationManager().translate('Fun')) {
      return funCardList;
    }
    if (title == LocalizationManager().translate('ForWork')) {
      return forWorkCardList;
    }
    if (title == LocalizationManager().translate('SocialMedia')) {
      return socialMediaCardList;
    }
  }

  buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0)
          .copyWith(bottom: 10, top: 4),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            LocalizationManager().translate(widget.title),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          const Spacer(),
          const UserProfile(),
        ],
      ),
    );
  }

  buildDiscoverCard({required SubChildDiscoverModel discover}) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(DiscoverChatPage.routeName,arguments: discover.title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xff3B3B3B),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            // if (discover.image != null && discover.image!.isNotEmpty)
            //   CachedNetworkImage(
            //     imageUrl: AppKey.baseUrlImg + discover.image!,
            //     height: 30,
            //     width: 30,
            //   ),
            const SizedBox(
              height: 14,
            ),
            Text(
              discover.title!,
              style: const TextStyle(
                color: AppConstants.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              discover.description!,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    var provider = Provider.of<DiscoverProvider>(context, listen: false);
    provider.getSubChildCategory(categoryId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          buildAppBar(),
          Consumer<DiscoverProvider>(
            builder: (context, provider, child) {
              return Expanded(
                child: provider.subLoadingStatus != AppLoadingStatus.loading
                    ? SmartRefresher(
                controller: provider.subCatRefreshController,
                  onRefresh: () {
                    provider.getSubChildCategory(categoryId: widget.id);
                  },
                      child: provider.subCategoryList.isNotEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: provider.subCategoryList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 22.0,
                                      mainAxisSpacing: 22.0,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return buildDiscoverCard(
                                        discover: provider.subCategoryList[index],
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                  LocalizationManager().translate('noDataFound')),
                            ),
                    )
                    : const ProgressPage(),
              );
            },
          ),
        ],
      ),
    ));
  }
}
