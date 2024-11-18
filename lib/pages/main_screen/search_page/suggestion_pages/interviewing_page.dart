import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestion_text_field.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/suggestionn_filter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../provider/chat_provider.dart';
import '../widget/suggestion_app_bar.dart';
import '../widget/suggestion_bottom_bar.dart';

class InterviewingPage extends StatefulWidget {
  static const routeName = "interviewing-page";

  const InterviewingPage({super.key});

  @override
  State<InterviewingPage> createState() => _InterviewingPageState();
}

class _InterviewingPageState extends State<InterviewingPage> {
  List<String> topicList = [
    LocalizationManager().translate('BackgroundExperience'),
    LocalizationManager().translate('CareerGoals'),
    LocalizationManager().translate('TechnicalSkills'),
    LocalizationManager().translate('CompanyKnowledge'),
    LocalizationManager().translate('InterpersonalSkills'),
    LocalizationManager().translate('Adaptability'),
    LocalizationManager().translate('ProblemSolvingAbilities'),
    LocalizationManager().translate('Leadership'),
    LocalizationManager().translate('TimeManagement')
  ];

  int selectedPage = 0;

  TextEditingController jobTitleController = TextEditingController();
  TextEditingController focusPointController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  late ChatProvider chatProvider;

  buildInterviewerTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SuggestionTextField(
          controller: jobTitleController,
          lines: 1,
          title: LocalizationManager().translate('JobTitle'),
        ),
        const SizedBox(
          height: 22,
        ),
        SuggestionTextField(
          controller: focusPointController,
          lines: 5,
          title: LocalizationManager().translate('FocusPoint'),
        ),
        const SizedBox(
          height: 22,
        ),
        SuggestionFilter(
          suggestionList: topicList,
          title: LocalizationManager().translate("Topic"),
        ),
        const SizedBox(
          height: 58,
        ),
      ],
    );
  }

  buildIntervieweeTab() {
    return Column(
      children: [
        SuggestionTextField(
          controller: positionController,
          lines: 1,
          title: LocalizationManager().translate("Position"),
        ),
        const SizedBox(
          height: 22,
        ),
        SuggestionTextField(
          controller: questionController,
          lines: 5,
          title: LocalizationManager().translate('ProvideAnswer'),
        ),
        const SizedBox(
          height: 22,
        ),
        SuggestionTextField(
          controller: answerController,
          lines: 1,
          title: LocalizationManager().translate('YourAnswer'),
        ),
        const SizedBox(
          height: 58,
        ),
      ],
    );
  }

  void _getLatestPotentialClient() {
    final text = jobTitleController.text.trim();

    chatProvider.setKey(key: 'int_job_title', value: text);
    chatProvider.setKey(
      key: 'question',
      value: text,
    );
  }

  void _getLatestPainPoint() {
    final text = focusPointController.text.trim();

    chatProvider.setKey(key: 'int_focus_point', value: text);
  }

  void _getLatestService() {
    final text = positionController.text.trim();

    chatProvider.setKey(key: 'int_position', value: text);
  }

  void _getLatestPricing() {
    final text = questionController.text.trim();

    chatProvider.setKey(key: 'int_question_to_ans', value: text);
    chatProvider.setKey(
      key: 'question',
      value: text,
    );
  }

  void _getLatestTimeLine() {
    final text = answerController.text.trim();

    chatProvider.setKey(key: 'int_your_question', value: text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.setKey(
          key: 'question',
          value: LocalizationManager().translate('Interviewing'),
      );
      // if(selectedPage == 0){
        chatProvider.setKey(key: 'int_job_title', value: "");
        chatProvider.setKey(key: 'int_focus_point', value: "");
      // } else {
        chatProvider.setKey(key: 'int_position', value: "");
        chatProvider.setKey(key: 'int_question_to_ans', value: "");
        chatProvider.setKey(key: 'int_your_question', value: "");
      // }
      jobTitleController.addListener(_getLatestPotentialClient);
      focusPointController.addListener(_getLatestPainPoint);
      positionController.addListener(_getLatestService);
      questionController.addListener(_getLatestPricing);
      answerController.addListener(_getLatestTimeLine);
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
    jobTitleController.dispose();
    focusPointController.dispose();
    positionController.dispose();
    questionController.dispose();
    answerController.dispose();
    chatProvider.clearMap();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final String receivedArgument = ModalRoute.of(context)!.settings.arguments.toString();
    if(selectedPage == 0) {
      chatProvider.setKey(key: 'int_type', value: 0);
    }else{
      chatProvider.setKey(key: 'int_type', value: 1);
    }
    var size = MediaQuery.of(context).size;

    print("receivedArgument $receivedArgument");

    chatProvider.setKey(key: 'category', value: receivedArgument,);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SuggestionAppBar(
              title: receivedArgument,
            ),
            Expanded(
                child: Scaffold(
              bottomNavigationBar: SuggestionBottomBar(title:LocalizationManager().translate("Interviewing"),
              interviewPage: selectedPage,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ToggleSwitch(
                        minWidth: size.width/2 - 30,
                        minHeight: 45,
                        cornerRadius: 12.0,
                        activeBgColors: [
                          [Colors.blue.shade800],
                          [Colors.blue.shade800]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.blue.withOpacity(.1),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: selectedPage,
                        totalSwitches: 2,fontSize: 12,
                        labels: [LocalizationManager().translate('Interviewer'), LocalizationManager().translate('Interviewee')],
                        radiusStyle: true,
                        onToggle: (index) {
                          if (index != null) {
                            setState(() {
                              selectedPage = index;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Builder(builder: (builder) {
                      if (selectedPage == 0) {
                        positionController.clear();
                        questionController.clear();
                        answerController.clear();
                        return buildInterviewerTab();
                      } else {
                        focusPointController.clear();
                        jobTitleController.clear();
                        return buildIntervieweeTab();
                      }
                    })
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

}
