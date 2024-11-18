import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../../enum/app_loading_staus.dart';
import '../../../../widget/app_back_button.dart';
import '../../../../widget/progress_page.dart';

class TermConditionPage extends StatefulWidget {
  static const routeName = "terms-condition-page";

  const TermConditionPage({super.key});

  @override
  State<TermConditionPage> createState() => _TermConditionPageState();
}

class _TermConditionPageState extends State<TermConditionPage> {
  @override
  void initState() {
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.clearModels();
    profileProvider.getTermsConditions();
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
              LocalizationManager().translate('termsConditions'),
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
                          provider.termConditionModel.description != null
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ).copyWith(top: 12, bottom: 18),
                          child: HtmlWidget(
                            provider.termConditionModel.description!,
                            textStyle: const TextStyle(color: Colors.white70),
                          ),
                        )
                      : const ProgressPage(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
