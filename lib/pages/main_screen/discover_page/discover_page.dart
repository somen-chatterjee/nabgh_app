import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/models/model/category_model.dart';
import 'package:nabgh_app/pages/main_screen/chat_page/discover_chat_screen.dart';
import 'package:nabgh_app/provider/discover_provider.dart';
import 'package:nabgh_app/widget/progress_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../helper/ad_helper.dart';
import '../../../helper/auth_helperr.dart';
import '../../../models/model/discover_card_model.dart';
import '../../../provider/chat_provider.dart';
import '../../../widget/user_profile.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {

  buildAppBar() {
    return FutureBuilder(
      future: AuthHelper.isUserExist(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0)
              .copyWith(bottom: 10, top: 4),
          child: Row(
            children: [
              if (snapshot.data != null && snapshot.data != false)
                const SizedBox(
                  width: 18,
                ),
              if (snapshot.data != null && snapshot.data != false)
                const Spacer(),
              Text(
                LocalizationManager().translate("Discover"),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const Spacer(),
              const UserProfile(),
            ],
          ),
        );
      },
    );
  }

  Widget buildDiscoverCard({required GetDiscover discover}) {
    return InkWell(
      onTap: () async {
        HapticFeedback.lightImpact();
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           SubCategoryPage(
        //             title: discover.title!,
        //             id: discover.id!,
        //           ),
        //     ));

        if(discover.id != null && discover.id == 1){
          var pChat = Provider.of<ChatProvider>(context, listen: false);

          if (mounted) {
            pChat.userAttempt(
                context: context, image: 1);
          }
        }

        Navigator.of(context)
            .pushNamed(DiscoverChatPage.routeName, arguments: discover);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: discover.titleEn == 'Image maker\n'
              ? const Color(0xff714DD7)
              : const Color(0xff3B3B3B),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            discover.image != null && discover.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      color: discover.titleEn == 'Image maker\n'
                          ? const Color(0xff3f2296)
                          : Colors.grey.shade900,
                      height: 38,
                      width: 38,
                      padding: const EdgeInsets.all(8.0),
                      child: discover.image!.contains('svg')
                          ? SvgPicture.network(
                              AppKey.baseUrlImg + discover.image!,
                            )
                          : CachedNetworkImage(
                              imageUrl: AppKey.baseUrlImg + discover.image!,
                              height: 30,
                              width: 30,
                              fit: BoxFit.fill,
                            ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 8,
            ),
            Text(
              discover.title!,
              style: TextStyle(
                color: AppConstants.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15 / MediaQuery.textScaleFactorOf(context),
              ),
              maxLines: 1,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              discover.description!,
              style: const TextStyle(fontSize: 15),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // AdHelper adHelper = AdHelper();

  @override
  void initState() {
    var provider = Provider.of<DiscoverProvider>(context, listen: false);
    if (provider.isFirst) {
      provider.getCategory();
      // adHelper.showAd(context: context);
    }
    super.initState();
  }

  @override
  void dispose() {
    // adHelper.adDispose();
    super.dispose();
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
                  child: provider.loadingStatus != AppLoadingStatus.loading
                      ? SmartRefresher(
                          controller: RefreshController(initialRefresh: false),
                          enablePullDown: true,
                          onRefresh: () {
                            // adHelper.showAd(context: context);
                            provider.getCategory();
                          },
                          child: provider.categoryList.isNotEmpty
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: provider.categoryList.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (provider.categoryList[index]
                                                          .getDiscover !=
                                                      null &&
                                                  provider.categoryList[index]
                                                      .getDiscover!.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(
                                                    provider.categoryList[index]
                                                        .title!,
                                                    style: const TextStyle(
                                                      fontSize: 22.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              if (provider.categoryList[index]
                                                          .getDiscover !=
                                                      null &&
                                                  provider.categoryList[index]
                                                      .getDiscover!.isNotEmpty)
                                                GridView.builder(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: provider
                                                      .categoryList[index]
                                                      .getDiscover!
                                                      .length,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 22.0,
                                                    mainAxisSpacing: 22.0,
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int gridIndex) {
                                                    return buildDiscoverCard(
                                                      discover:
                                                          provider
                                                                  .categoryList[
                                                                      index]
                                                                  .getDiscover![
                                                              gridIndex],
                                                    );
                                                  },
                                                ),
                                            ],
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
                                    LocalizationManager()
                                        .translate('noDataFound'),
                                  ),
                                ),
                        )
                      : const ProgressPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
