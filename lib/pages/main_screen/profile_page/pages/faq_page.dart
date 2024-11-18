import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:provider/provider.dart';
import '../../../../change_language/language_helper.dart';
import '../../../../enum/app_loading_staus.dart';
import '../../../../models/model/faq_model.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../widget/app_back_button.dart';
import '../../../../widget/progress_page.dart';

class FaqPage extends StatefulWidget {
  static const routeName = "faq-page";

  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {

  @override
  void initState() {
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.clearModels();
    profileProvider.getFaq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildAppBar() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16)
            .copyWith(top: 6, bottom: 8),
        child: Row(
          children: [
            const AppBackButton(),
            const Spacer(),
            Text(
              LocalizationManager().translate("FAQ"),
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

    buildFAQCard({required List faqItems}) {
      return Container(
        color: Colors.black.withOpacity(.8),
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(children: [
          ...faqItems.map((faq) {
            return Column(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      faq.question,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 12),
                        child: Text(
                          faq.answer,
                          style: const TextStyle(
                            letterSpacing: 1.5,
                            // color: Colors.white60
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: const EdgeInsets.only(top: 8),
                  height: 1,
                ),
              ],
            );
          })
        ]),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                return Expanded(
                  child: provider.loadingStatus != AppLoadingStatus.loading
                      ? provider.faqList.isNotEmpty
                          ? SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 18, right: 18, bottom: 18),
                              child: ExpansionTileGroup(
                                toggleType: ToggleType.expandOnlyCurrent,
                                children: [
                                  ...provider.faqList
                                      .map(
                                        (faq) => ExpansionTileItem(
                                          title: Text(
                                            faq.question!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          tilePadding: EdgeInsets.zero,
                                          childrenPadding: EdgeInsets.zero,
                                          textColor:
                                              AppConstants.secondaryColor,
                                          expendedBorderColor:
                                              Colors.white.withOpacity(.2),
                                          children: [
                                            Text(
                                              faq.answer!,
                                              style: TextStyle(
                                                  color:
                                                      Colors.white.withOpacity(
                                                    .8,
                                                  ),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 22,
                                            )
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(LocalizationManager()
                                  .translate('noFaqFound')),
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
