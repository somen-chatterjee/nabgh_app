import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestion_text_field.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestionn_filter.dart';
import 'package:provider/provider.dart';
import '../../../../provider/chat_provider.dart';
import '../widget/suggestion_app_bar.dart';
import '../widget/suggestion_bottom_bar.dart';

class ProposalForClient extends StatefulWidget {
  static const routeName = "proposal-for-client";

  const ProposalForClient({super.key});

  @override
  State<ProposalForClient> createState() => _ProposalForClientState();
}

class _ProposalForClientState extends State<ProposalForClient> {
  late ChatProvider chatProvider;

  TextEditingController potentialClientController = TextEditingController();
  TextEditingController painPointController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController pricingController = TextEditingController();
  TextEditingController timeLineController = TextEditingController();

  List<String> toneList = [
    LocalizationManager().translate("Formal"),
    LocalizationManager().translate("Informal"),
    LocalizationManager().translate("Optimistic"),
    LocalizationManager().translate("Worried"),
    LocalizationManager().translate("Friendly"),
    LocalizationManager().translate("Curious"),
    LocalizationManager().translate("Assertive"),
    LocalizationManager().translate("Encouraging"),
    LocalizationManager().translate("Surprised"),
    LocalizationManager().translate("Cooperative")
  ];

  void _getLatestPotentialClient() {
    final text = potentialClientController.text.trim();

    chatProvider.setKey(key: 'p_potential_client', value: text);
  }

  void _getLatestPainPoint() {
    final text = painPointController.text.trim();

    chatProvider.setKey(key: 'p_plan_point', value: text);
  }

  void _getLatestService() {
    final text = serviceController.text.trim();

    chatProvider.setKey(key: 'p_service', value: text);
  }

  void _getLatestPricing() {
    final text = pricingController.text.trim();

    chatProvider.setKey(key: 'p_pricing', value: text);
  }

  void _getLatestTimeLine() {
    final text = timeLineController.text.trim();

    chatProvider.setKey(key: 'p_timeline', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.setKey(
          key: 'question',
          value: LocalizationManager().translate('proposalClient'),
      );

      chatProvider.setKey(key: 'p_potential_client', value: "");
      chatProvider.setKey(key: 'p_plan_point', value: "");
      chatProvider.setKey(key: 'p_service', value: "");

      potentialClientController.addListener(_getLatestPotentialClient);
      painPointController.addListener(_getLatestPainPoint);
      serviceController.addListener(_getLatestService);
      pricingController.addListener(_getLatestPricing);
      timeLineController.addListener(_getLatestTimeLine);
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
    potentialClientController.dispose();
    painPointController.dispose();
    serviceController.dispose();
    pricingController.dispose();
    timeLineController.dispose();
    chatProvider.clearMap();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String receivedArgument =
        ModalRoute.of(context)!.settings.arguments.toString();

    chatProvider.setKey(key: 'category', value: receivedArgument,);

    // chatProvider.setKey(
    //     key: 'question',
    //     value: LocalizationManager().translate('proposalClient'),
    // );
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
                  title: LocalizationManager().translate('ProposalsClients'),
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
                      SuggestionTextField(
                        controller: potentialClientController,
                        lines: 1,
                        title: LocalizationManager()
                            .translate('YourPotentialClient'),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SuggestionTextField(
                        controller: painPointController,
                        lines: 1,
                        title:
                            LocalizationManager().translate('TheirPainPoints'),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SuggestionTextField(
                        controller: serviceController,
                        lines: 1,
                        title: LocalizationManager().translate('YourServices'),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SuggestionFilter(
                          suggestionList: toneList,
                          title: LocalizationManager().translate("Tone")),
                      const SizedBox(
                        height: 18,
                      ),
                      SuggestionTextField(
                        controller: pricingController,
                        lines: 1,
                        title: LocalizationManager().translate('Pricing'),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SuggestionTextField(
                        controller: timeLineController,
                        lines: 1,
                        title: LocalizationManager().translate('Timeline'),
                      ),
                      const SizedBox(
                        height: 68,
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
