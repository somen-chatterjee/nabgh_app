import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/models/model/subscription_plan_model.dart';
import 'package:nabgh_app/pages/main_screen/subscription_page/subscription_page.dart';
import 'package:nabgh_app/provider/profile_provider.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:nabgh_app/widget/progress_page.dart';
import 'package:provider/provider.dart';

import '../../../change_language/language_helper.dart';
import '../../../constatns/app_constants.dart';
import '../../../widget/app_back_button.dart';

class SubscriptionDetailPage extends StatefulWidget {
  static const routeName = "subscription_detail_page";

  const SubscriptionDetailPage({super.key});

  @override
  State<SubscriptionDetailPage> createState() => _SubscriptionDetailPageState();
}

class _SubscriptionDetailPageState extends State<SubscriptionDetailPage> {
  @override
  void initState() {
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getSubscriptionPlan();
    profileProvider.getMyPlan();
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
              LocalizationManager().translate("Subscription"),
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            const SizedBox(
              width: 18,
            )
          ],
        ),
      );
    }

    buildCard(List<SubscriptionPlanModel> subscriptionPlanList,
        ProfileProvider provider) {
      return ListView.builder(
        itemCount: subscriptionPlanList.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              if (subscriptionPlanList[index].id!.toString() ==
                  provider.myPlanModel.planId)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      gradient: AppConstants.gradient),
                  child: Text(
                    LocalizationManager().translate('currentPlan'),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: subscriptionPlanList[index].id!.toString() ==
                            provider.myPlanModel.planId
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(
                              18,
                            ),
                            bottomRight: Radius.circular(18),
                            topRight: Radius.circular(18))
                        : const BorderRadius.all(
                            Radius.circular(
                              18,
                            ),
                          ),
                    border: Border.all(color: AppConstants.secondaryColor)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius:
                              subscriptionPlanList[index].id!.toString() ==
                                      provider.myPlanModel.planId
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                        18,
                                      ),
                                      bottomRight: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                    )
                                  : const BorderRadius.all(
                                      Radius.circular(
                                        18,
                                      ),
                                    ),
                          color: AppConstants.secondaryColor),
                      child: Text(
                        subscriptionPlanList[index].description!,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Text(
                      subscriptionPlanList[index].title!,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "\$${subscriptionPlanList[index].price!}",
                      style: const TextStyle(color: Colors.white, fontSize: 35),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppConstants.secondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    LocalizationManager().translate("Cancel"),
                    style: const TextStyle(color: AppConstants.secondaryColor),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 22,
            ),
            Expanded(
              child: SizedBox(
                  height: 45,
                  child: AppSmallButton(
                      title: Text(
                        LocalizationManager().translate("Upgrade"),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        Navigator.of(context)
                            .pushNamed(SubscriptionPage.routeName).then((value) {
                          var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                          profileProvider.getSubscriptionPlan();
                          profileProvider.getMyPlan();
                        });
                      },
                  ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(child: Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                return provider.loadingStatus != AppLoadingStatus.loading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            buildCard(provider.subscriptionPlanList, provider),
                      )
                    : const ProgressPage();
              },
            )),
          ],
        ),
      ),
    );
  }
}
