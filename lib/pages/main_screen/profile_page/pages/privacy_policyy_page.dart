import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/provider/profile_provider.dart';
import 'package:nabgh_app/widget/progress_page.dart';
import 'package:provider/provider.dart';

import '../../../../widget/app_back_button.dart';

class PrivacyPolicyPage extends StatefulWidget {
  static const routeName = "privacy-policy-page";

  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {

  @override
  void initState() {
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.clearModels();
    profileProvider.getPrivacyPolicy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildAppBar() {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 6, bottom: 8),
        child: Row(
          children: [
            const AppBackButton(),
            const Spacer(),
            Text(
              LocalizationManager().translate('privacyPolicy'),
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                return Expanded(
                  child: provider.loadingStatus != AppLoadingStatus.loading &&
                          provider.privacyPolicyModel.description != null
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ).copyWith(top: 12, bottom: 18),
                          child: HtmlWidget(
                            provider.privacyPolicyModel.description!,
                            textStyle: const TextStyle(color: Colors.white70),
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
