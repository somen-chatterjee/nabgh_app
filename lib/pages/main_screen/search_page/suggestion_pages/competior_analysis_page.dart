import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:provider/provider.dart';

import '../../../../provider/chat_provider.dart';
import '../widget/suggestion_app_bar.dart';
import '../widget/suggestion_bottom_bar.dart';
import '../widget/suggestion_text_field.dart';

class CompetiorAnalysis extends StatefulWidget {
  static const routeName = "copetitor-analysis";

  const CompetiorAnalysis({super.key});

  @override
  State<CompetiorAnalysis> createState() => _CompetiorAnalysisState();
}

class _CompetiorAnalysisState extends State<CompetiorAnalysis> {
  late ChatProvider chatProvider;

  TextEditingController industryController = TextEditingController();
  TextEditingController competitorController = TextEditingController();
  TextEditingController productsController = TextEditingController();

  void _getLatestIndustry() {
    final text = industryController.text.trim();

    chatProvider.setKey(key: 'c_industry', value: text);
  }

  void _getLatestCompetitor() {
    final text = competitorController.text.trim();

    chatProvider.setKey(key: 'c_competitor', value: text);
  }

  void _getLatestProducts() {
    final text = productsController.text.trim();

    chatProvider.setKey(key: 'c_product', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.setKey(
          key: 'question',
          value: LocalizationManager().translate('ResearchCompetitors'));
      chatProvider.setKey(key: 'c_industry', value: "");
      chatProvider.setKey(key: 'c_competitor', value: "");
      chatProvider.setKey(key: 'c_product', value: "");

      industryController.addListener(_getLatestIndustry);
      competitorController.addListener(_getLatestCompetitor);
      productsController.addListener(_getLatestProducts);
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
    industryController.dispose();
    competitorController.dispose();
    productsController.dispose();
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
                  title: LocalizationManager().translate('CompetitorAnalysis'),
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
                        LocalizationManager().translate('ResearchCompetitors'),
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
                          controller: industryController,
                          title: LocalizationManager().translate("Industry"),
                          lines: 1,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SuggestionTextField(
                          controller: competitorController,
                          title: LocalizationManager().translate("Competitor"),
                          lines: 1,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SuggestionTextField(
                          controller: productsController,
                          title: LocalizationManager()
                              .translate('ProductsServiceOptional'),
                          lines: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
