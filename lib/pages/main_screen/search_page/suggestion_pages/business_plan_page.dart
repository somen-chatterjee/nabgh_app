import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestion_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../provider/chat_provider.dart';
import '../widget/suggestion_app_bar.dart';
import '../widget/suggestion_bottom_bar.dart';

class BusinessPlanPage extends StatefulWidget {
  static const routeName = "business-plan-page";

  const BusinessPlanPage({super.key});

  @override
  State<BusinessPlanPage> createState() => _BusinessPlanPageState();
}

class _BusinessPlanPageState extends State<BusinessPlanPage> {
  late ChatProvider chatProvider;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController nicheController = TextEditingController();
  TextEditingController goalsController = TextEditingController();

  void _getLatestCompanyName() {
    final text = companyNameController.text.trim();

    chatProvider.setKey(key: 'b_company_name', value: text);
  }

  void _getLatestProductName() {
    final text = productNameController.text.trim();

    chatProvider.setKey(key: 'b_product', value: text);
  }

  void _getLatestNiche() {
    final text = nicheController.text.trim();

    chatProvider.setKey(key: 'b_niche', value: text);
  }

  void _getLatestGoals() {
    final text = goalsController.text.trim();

    chatProvider.setKey(key: 'b_goal', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.setKey(key: 'question', value: LocalizationManager().translate('WriteBusinessPlan'));
      chatProvider.setKey(key: 'b_company_name', value: "");
      chatProvider.setKey(key: 'b_product', value: "");
      chatProvider.setKey(key: 'b_niche', value: "");
      chatProvider.setKey(key: 'b_goal', value: "");

      companyNameController.addListener(_getLatestCompanyName);
      productNameController.addListener(_getLatestProductName);
      nicheController.addListener(_getLatestNiche);
      goalsController.addListener(_getLatestGoals);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    productNameController.dispose();
    nicheController.dispose();
    goalsController.dispose();
    chatProvider.clearMap();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String receivedArgument =
        ModalRoute.of(context)!.settings.arguments.toString();
    chatProvider.setKey(key: 'category',value: receivedArgument,);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SuggestionAppBar(
              title: receivedArgument,
            ),
            Expanded(
              child: Scaffold(
                bottomNavigationBar: SuggestionBottomBar(
                  title: LocalizationManager().translate('BusinessPlan'),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        LocalizationManager().translate('WriteBusinessPlan'),
                        style: TextStyle(
                            color: Colors.green.shade300,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SuggestionTextField(
                          controller: companyNameController,
                          title: LocalizationManager().translate('CompanyName'),
                          lines: 1,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SuggestionTextField(
                          controller: productNameController,
                          title:
                              LocalizationManager().translate('ProductService'),
                          lines: 1,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SuggestionTextField(
                          controller: nicheController,
                          title: LocalizationManager().translate("Niche"),
                          lines: 1),
                      const SizedBox(
                        height: 22,
                      ),
                      SuggestionTextField(
                          controller: goalsController,
                          title: LocalizationManager().translate("Goals"),
                          lines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
