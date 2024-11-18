import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/helper/ad_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/search_screen.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/provider/chat_history_provider.dart';
import 'package:nabgh_app/widget/error_page.dart';
import 'package:provider/provider.dart';

import '../../provider/chat_provider.dart';
import '../../widget/progress_page.dart';
import 'chat_history_page/chat_history_page.dart';
import 'discover_page/discover_page.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "main-screen-page";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  AdHelper adHelper = AdHelper();

  late Timer _timer;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    var provider = Provider.of<AuthenticateProvider>(context, listen: false);
    var pChat = Provider.of<ChatProvider>(context, listen: false);

    provider.getUser();

    pChat.userAttempt(context: context);

    // });
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: pageIdx.value);
    _tabController.addListener(() {
      // setState(() {
      pageIdx.value = _tabController.index;
      // });
      // print("Selected Index: " + _tabController.index.toString());
    });

    _timer = Timer.periodic(const Duration(minutes: 4), (timer) {
      adHelper.showAd(context: context);
    });
  }

  ValueNotifier<int> pageIdx = ValueNotifier(1);

  buildBottomBar() {
    bool isDiscoverSelected = pageIdx.value == 0;
    bool isSearchSelected = pageIdx.value == 1;
    bool isRecentSelected = pageIdx.value == 2;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // setState(() {
              pageIdx.value = 0;
              _tabController.animateTo(pageIdx.value);
              // });
            },
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: isDiscoverSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: Colors.white54,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    )
                  : const BoxDecoration(),
              child: isDiscoverSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/discover.svg",
                          color: AppConstants.secondaryColor,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          LocalizationManager().translate('Discover'),
                          style: const TextStyle(
                            color: AppConstants.secondaryColor,
                          ),
                        )
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/discover.svg",
                          color: Colors.white70,
                        ),
                        Text(
                          LocalizationManager().translate('Discover'),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        )
                      ],
                    ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // setState(() {
              pageIdx.value = 1;
              _tabController.animateTo(pageIdx.value);
              // });
            },
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: isSearchSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: Colors.white54,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    )
                  : const BoxDecoration(),
              child: isSearchSelected
                  ? Row(
                      children: [
                        SvgPicture.asset("assets/icon/search.svg"),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          LocalizationManager().translate('Search'),
                          style: const TextStyle(
                              color: AppConstants.secondaryColor),
                        )
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/search.svg",
                          color: Colors.white38,
                        ),
                        Text(
                          LocalizationManager().translate('Search'),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        )
                      ],
                    ),
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // setState(() {
                pageIdx.value = 2;
                _tabController.animateTo(pageIdx.value);
                // });
              },
              icon: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: isRecentSelected
                    ? BoxDecoration(
                        border: Border.all(
                          color: Colors.white54,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      )
                    : const BoxDecoration(),
                child: isRecentSelected
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/icon/recent.svg",
                            color: AppConstants.secondaryColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            LocalizationManager().translate('History'),
                            style: const TextStyle(
                              color: AppConstants.secondaryColor,
                            ),
                          )
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/icon/recent.svg",
                            color: Colors.white70,
                          ),
                          Text(
                            LocalizationManager().translate('History'),
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
              ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildBottomBar1() {
    bool isDiscoverSelected = pageIdx.value == 0;
    bool isSearchSelected = pageIdx.value == 1;
    bool isRecentSelected = pageIdx.value == 2;
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        child: isDiscoverSelected
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/icon/discover.svg",
                    color: AppConstants.secondaryColor,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    LocalizationManager().translate('Discover'),
                    style: const TextStyle(
                      color: AppConstants.secondaryColor,
                    ),
                  )
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/icon/discover.svg",
                    color: Colors.white70,
                  ),
                  Text(
                    LocalizationManager().translate('Discover'),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        child: isSearchSelected
            ? Row(
                children: [
                  SvgPicture.asset("assets/icon/search.svg"),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    LocalizationManager().translate('Search'),
                    style: const TextStyle(color: AppConstants.secondaryColor),
                  )
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/icon/search.svg",
                    color: Colors.white38,
                  ),
                  Text(
                    LocalizationManager().translate('Search'),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        child: isRecentSelected
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/icon/recent.svg",
                    color: AppConstants.secondaryColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    LocalizationManager().translate('History'),
                    style: const TextStyle(
                      color: AppConstants.secondaryColor,
                    ),
                  )
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/icon/recent.svg",
                    color: Colors.white70,
                  ),
                  Text(
                    LocalizationManager().translate('History'),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
      )
    ];
  }

  Widget getBody({required int index}) {
    switch (index) {
      case 0:
        return const DiscoverPage();
      case 1:
        return const SearchPage();
      case 2:
        return const ChatHistoryPage(
          type: null,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // bottomNavigationBar: TabBar(
      //   indicator: BoxDecoration(
      //     border: Border.all(
      //       color: Colors.white54,
      //     ),
      //     borderRadius: BorderRadius.circular(18),
      //   ),
      //   indicatorSize: TabBarIndicatorSize.label,
      //   controller: _tabController,
      //   tabs: buildBottomBar1(),
      // ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: pageIdx,
        builder: (context, value, child) {
          return buildBottomBar();
        },
      ),
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          if (pageIdx.value != 2) {
            // Show dialog and handle exit confirmation
            bool exit = await showDialog(
              context: context,
              builder: (context) => const ExitConfirmationDialog(),
            );
            return exit;
          } else {
            var pChatHistory =
                Provider.of<ChatHistoryProvider>(context, listen: false);
            if (pChatHistory.ids.isNotEmpty) {
              pChatHistory.getChatHistory(
                  context: context, type: null, category: '',tabId: '',);
            }
            return false;
          }
        },
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if(_tabController.index != 0) {
              if (details.primaryDelta! > 0 &&
                  details.globalPosition.dx < screenWidth * 0.2) {
                HapticFeedback.lightImpact();
                if (LocalizationManager().locale.languageCode == 'ar') {
                  _tabController.animateTo(2);
                } else {
                  _tabController.animateTo(1);
                }
              } else if (details.primaryDelta! < 0 &&
                  details.globalPosition.dx > screenWidth * 0.8) {
                HapticFeedback.lightImpact();
                if (LocalizationManager().locale.languageCode == 'ar') {
                  _tabController.animateTo(1);
                } else {
                  _tabController.animateTo(2);
                }
              }
            }
          },
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Consumer<AuthenticateProvider>(
                builder: (context, provider, _) {
                  if (provider.loadingStatus == AppLoadingStatus.loading) {
                    return const ProgressPage();
                  } else if (provider.loadingStatus ==
                      AppLoadingStatus.success) {
                    return const DiscoverPage();
                  } else {
                    return ErrorPage(onTap: () {
                      HapticFeedback.lightImpact();
                      provider.getUser();
                    });
                  }
                },
              ),
              const SearchPage(),
              // Consumer<AuthenticateProvider>(
              //   builder: (context, provider, _) {
              //     if (provider.loadingStatus == AppLoadingStatus.loading) {
              //       return const ProgressPage();
              //     } else if (provider.loadingStatus ==
              //         AppLoadingStatus.success) {
              //       return const SearchPage();
              //     } else {
              //       return ErrorPage(onTap: () {
              //         HapticFeedback.lightImpact();
              //         provider.getUser();
              //       });
              //     }
              //   },
              // ),
              Consumer<AuthenticateProvider>(
                builder: (context, provider, _) {
                  if (provider.loadingStatus == AppLoadingStatus.loading) {
                    return const ProgressPage();
                  } else if (provider.loadingStatus ==
                      AppLoadingStatus.success) {
                    return const ChatHistoryPage(
                      type: null,
                    );
                  } else {
                    return ErrorPage(onTap: () {
                      HapticFeedback.lightImpact();
                      provider.getUser();
                    });
                  }
                },
              ),
              /*Consumer<AuthenticateProvider>(
              builder: (context, provider, _) {
                if (provider.loadingStatus == AppLoadingStatus.loading) {
                  return const ProgressPage();
                } else if (provider.loadingStatus == AppLoadingStatus.success) {
                  return getBody(index: pageIdx);
                } else {
                  return ErrorPage(onTap: () {
                    provider.getUser();
                  });
                }
              },
            ),*/
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    adHelper.adDispose();
    print("somen timer  dispose");
  }
}

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocalizationManager().translate('exitApp'),
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(LocalizationManager().translate('wantExit')),
            const SizedBox(
              height: 14.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.secondaryColor),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    LocalizationManager().translate('no'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.secondaryColor),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    LocalizationManager().translate('yes'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
