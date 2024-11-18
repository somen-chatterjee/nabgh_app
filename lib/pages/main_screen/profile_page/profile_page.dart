import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/edit_profile_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/faq_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/help_support_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/password_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/privacy_policyy_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/terms_condition_page.dart';
import 'package:nabgh_app/pages/splash_screen/rate_us_modal.dart';
import 'package:nabgh_app/provider/auth_provider.dart';

import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../provider/profile_provider.dart';
import '../../../widget/app_back_button.dart';
import '../subscription_page/subscription_detail_page.dart';
import '../subscription_page/subscription_page.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "profile-page";

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  buildAppBar() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 0).copyWith(top: 4, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          const SizedBox(
            width: 12,
          ),
          Text(
            LocalizationManager().translate('myProfile'),
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pushNamed(EditProfilePage.routeName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppConstants.secondaryColor),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icon/edit.svg"),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    LocalizationManager().translate('Edit'),
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildProfile() {
    return Consumer<AuthenticateProvider>(builder: (context, provider, _) {
      return Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              color: Color(0xff343434),
              shape: BoxShape.circle,
            ),
            child: provider.userDetail?.data?.profile != null
                ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: AppKey.baseUrlImg +
                    provider.userDetail!.data!.profile!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
              ),
            )
                : ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Image.asset("assets/icon/man.png"),
                )),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            provider.userDetail?.data?.name ?? "",
            style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(.9)),
          ),
          Text(
            provider.userDetail?.data?.email ?? "",
            style: TextStyle(color: Colors.white.withOpacity(.6)),
          ),
        ],
      );
    });
  }

  buildMenuTile({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 18),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          height: 55,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          child: Text(title),
        ),
      ),
    );
  }

  @override
  void initState() {
    var provider = Provider.of<AuthenticateProvider>(context, listen: false);
    provider.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              buildAppBar(),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        buildProfile(),
                        const SizedBox(
                          height: 30,
                        ),
                        buildMenuTile(
                            title:
                            LocalizationManager().translate('accountSettings'),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context)
                                  .pushNamed(EditProfilePage.routeName);
                            }),
                        buildMenuTile(
                            title: LocalizationManager().translate("Help"),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pushNamed(HelpPage
                                  .routeName);
                            }),
                        buildMenuTile(
                            title:
                            LocalizationManager().translate('changePassword'),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context)
                                  .pushNamed(ResetPasswordSettingPage
                                  .routeName);
                            }),
                        buildMenuTile(
                            title: LocalizationManager().translate(
                                'privacyPolicy'),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context)
                                  .pushNamed(PrivacyPolicyPage.routeName);
                            }),
                        buildMenuTile(
                            title:
                            LocalizationManager().translate('termsConditions'),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context)
                                  .pushNamed(TermConditionPage.routeName);
                            }),
                        Consumer<AuthenticateProvider>(builder: (context, provider, _)  {
                          return buildMenuTile(
                              title:
                              LocalizationManager().translate('rateUs'),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext _) => const RateUsModal(),
                                );
                                // provider.rateUs(buildContext: context);
                              });
                        }),
                        buildMenuTile(
                            title: LocalizationManager()
                                .translate('subscriptionManagement'),
                            onTap: () {
                              // HapticFeedback.lightImpact();
                              // Navigator.of(context)
                              //     .pushNamed(SubscriptionDetailPage.routeName);

                              HapticFeedback.lightImpact();
                              Navigator.of(context)
                                  .pushNamed(SubscriptionPage.routeName)
                                  .then((value) {
                                var profileProvider = Provider.of<
                                    ProfileProvider>(
                                    context,
                                    listen: false);
                                profileProvider.getSubscriptionPlan();
                                profileProvider.getMyPlan();
                              });
                            }),
                        buildMenuTile(
                            title: LocalizationManager().translate("FAQ"),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pushNamed(FaqPage
                                  .routeName);
                            }),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 45,
                          child: Consumer<AuthenticateProvider>(
                              builder: (context, provider, _) {
                                return AppSmallButton(
                                  title: Row(
                                    children: [
                                      const Spacer(),
                                      SvgPicture.asset(
                                          "assets/icon/logout.svg"),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        LocalizationManager().translate(
                                            "Logout"),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    // var auth = GoogleSignIn().signInOption;
                                    // print("somen ${provider.userDetail!.data!.socialId}");
                                    if (provider.userDetail!.data!.socialId !=
                                        null) {
                                      if (await GoogleSignIn().isSignedIn()) {
                                        await GoogleSignIn().signOut();
                                      }
                                    }
                                    provider.clearController();
                                    if (context.mounted) {
                                      provider.logOut(context: context);
                                    }
                                  },
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<AuthenticateProvider>(
                            builder: (context, provider, _) {
                              return TextButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  deleteFunction() async {
                                    Navigator.of(context).pop();
                                    if (provider.userDetail!.data!.socialId !=
                                        null) {
                                      if (await GoogleSignIn().isSignedIn()) {
                                        await GoogleSignIn().signOut();
                                      }
                                    }
                                    provider.clearController();
                                    if (context.mounted) {
                                      provider.deleteAccount(context: context);
                                    }
                                  }

                                  _showConfirmationDialog(
                                      context, provider, deleteFunction);
                                },
                                child: Text(
                                  LocalizationManager().translate(
                                      'deleteAccount'),
                                  style: const TextStyle(
                                    color: AppConstants.secondaryColor,
                                  ),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context,
      AuthenticateProvider provider, VoidCallback function) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationManager().translate('confirmation')),
          content: Text(LocalizationManager().translate('deleteConfirmation')),
          actions: <Widget>[
            TextButton(
              onPressed: function,
              child: Text(
                LocalizationManager().translate('Yes'),
                style: const TextStyle(
                  color: AppConstants.secondaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              child: Text(
                LocalizationManager().translate('Cancel'),
                style: const TextStyle(
                  color: AppConstants.secondaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
