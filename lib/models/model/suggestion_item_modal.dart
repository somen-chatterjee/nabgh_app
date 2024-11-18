import 'package:flutter/cupertino.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import '../model/suggestion_card_model.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/default_suggestion_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/write_email_page.dart';

import '../../pages/main_screen/search_page/suggestion_pages/business_plan_page.dart';
import '../../pages/main_screen/search_page/suggestion_pages/competior_analysis_page.dart';
import '../../pages/main_screen/search_page/suggestion_pages/interviewing_page.dart';
import '../../pages/main_screen/search_page/suggestion_pages/language_translation_page.dart';
import '../../pages/main_screen/search_page/suggestion_pages/meeting_summary.dart';
import '../../pages/main_screen/search_page/suggestion_pages/proposals_for_clients.dart';
import '../../pages/main_screen/search_page/suggestion_pages/sociial_content_page.dart';
import '../../router.dart';

// class SuggestionItem {
//   static List<SuggestionCardModel> writingSuggestionList = [
//     academicWriting,
//     comedy,
//     lyrics,
//     storyTelling,
//     email,
//     socialContent,
//     poem,
//     letter,
//     essayAssistance,
//     complaints
//   ];
//
//   static List<SuggestionCardModel> businessSuggestionList = [
//     businessPlan,
//     competitorAnalysis,
//     interviewing,
//     meetingSummary,
//     proposals,
//   ];
//
//   static List<SuggestionCardModel> mostlyUsed = [
//     meetingSummary,
//     translation,
//     email,
//     academicWriting,
//     grammar,
//   ];
//
//   static List<SuggestionCardModel> languageSuggestionList = [
//     grammar,
//     paraphrasing,
//     translation,
//     summary,
//     plagiarismChecker
//   ];
//
//   static List<SuggestionCardModel> otherCategoryList = [
//     passwordGenerator,
//     dreamInterpreter,
//     talkWithNabigh,
//     policiesProcedures,
//     smartDeviceCare
//   ];
//
//   static List<SuggestionCardModel> allList = [
//     ...writingSuggestionList,
//     ...businessSuggestionList,
//     ...languageSuggestionList,
//     ...healthList,
//     ...educationList,
//     ...workList,
//     ...familyList,
//     ...otherCategoryList,
//   ];
//
//   /// writing
//
//   static SuggestionCardModel academicWriting = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('AcademicWriting')),
//       title: LocalizationManager().translate('AcademicWriting'),
//       subtitle: LocalizationManager().translate('ResearchAndAcademic'),
//       imgSrc: "assets/suggestion/academic_writing.png");
//
//   static SuggestionCardModel comedy = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('Comedy')),
//       title: LocalizationManager().translate('Comedy'),
//       subtitle: LocalizationManager().translate('ComposeComedic'),
//       imgSrc: "assets/suggestion/comedy.png");
//
//   static SuggestionCardModel lyrics = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate("Lyrics")),
//       title:  LocalizationManager().translate("Lyrics"),
//       subtitle: LocalizationManager().translate('ComposeCaptivating'),
//       imgSrc: "assets/suggestion/lyrics.png");
//
//   static SuggestionCardModel storyTelling = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('Storytelling')),
//       title: LocalizationManager().translate('Storytelling'),
//       subtitle: LocalizationManager().translate('CraftEngaging'),
//       imgSrc: "assets/suggestion/storytelling.png");
//
//   static SuggestionCardModel email = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(WriteEmailPage.routeName,
//           arguments: LocalizationManager().translate("Email")),
//       title: LocalizationManager().translate("Email"),
//       subtitle: LocalizationManager().translate("WriteRespondEmails"),
//       imgSrc: "assets/suggestion/academic_writing.png");
//
//   static SuggestionCardModel socialContent = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//             SocialContentPage.routeName,
//           ),
//       title: LocalizationManager().translate('SocialContent'),
//       subtitle: LocalizationManager().translate('WriteSocialMediaContent'),
//       imgSrc: "assets/suggestion/email.png");
//
//   static SuggestionCardModel poem = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate("Poem")),
//       title: LocalizationManager().translate("Poem"),
//       subtitle: LocalizationManager().translate('ComposeInspiring'),
//       imgSrc: "assets/suggestion/poem.png");
//
//   static SuggestionCardModel letter = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate("Letters")),
//       title: LocalizationManager().translate("Letters"),
//       subtitle: LocalizationManager().translate('writeLetters'),
//       imgSrc: "assets/suggestion/letter.png");
//
//   static SuggestionCardModel essayAssistance = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('EssayAssistance')),
//       title: LocalizationManager().translate('EssayAssistance'),
//       subtitle: LocalizationManager().translate('GuideForEssayWriting'),
//       imgSrc: "assets/suggestion/email.png");
//
//   static SuggestionCardModel complaints = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('Complaints')),
//       title: LocalizationManager().translate('Complaints'),
//       subtitle: LocalizationManager().translate('ExpertAssistance'),
//       imgSrc: "assets/suggestion/complaints.png");
//
//   ///  Business
//
//   static SuggestionCardModel businessPlan = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//             BusinessPlanPage.routeName,
//           ),
//       title: LocalizationManager().translate('BusinessPlan'),
//       subtitle: LocalizationManager().translate('StrategiesBusiness'),
//       imgSrc: "assets/suggestion/business_plan.png");
//
//   static SuggestionCardModel competitorAnalysis = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//             CompetiorAnalysis.routeName,
//           ),
//       title: LocalizationManager().translate('CompetitorAnalysis'),
//       subtitle: LocalizationManager().translate('ResearchStrategies'),
//       imgSrc: "assets/suggestion/pie_chart.png");
//
//   static SuggestionCardModel interviewing = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//             InterviewingPage.routeName,
//           ),
//       title: LocalizationManager().translate('Interviewing'),
//       subtitle: LocalizationManager().translate('Interviewing'),
//       imgSrc: "assets/suggestion/interviewing.png");
//
//   static SuggestionCardModel meetingSummary = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//             MeetingSummeryPage.routeName,
//           ),
//       title: LocalizationManager().translate('MeetingSummary'),
//       subtitle: LocalizationManager().translate('EfficientlySum'),
//       imgSrc: "assets/suggestion/meeting_summary.png");
//
//   static SuggestionCardModel proposals = SuggestionCardModel(
//       onTap: () =>
//           navigatorKey.currentState!.pushNamed(ProposalForClient.routeName),
//       title: LocalizationManager().translate('ProposalsClients'),
//       subtitle: LocalizationManager().translate('CraftProposals'),
//       imgSrc: "assets/suggestion/proposals_for_clients.png");
//
//   /// Language tools
//
//   static SuggestionCardModel grammar = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate("Grammar")),
//       title: LocalizationManager().translate("Grammar"),
//       subtitle: LocalizationManager().translate('CorrectGrammar'),
//       imgSrc: "assets/suggestion/grammar.png");
//
//   static SuggestionCardModel paraphrasing = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('Paraphrasing')),
//       title: LocalizationManager().translate('Paraphrasing'),
//       subtitle: LocalizationManager().translate('ParaphraseWording'),
//       imgSrc: "assets/suggestion/paraphrasing.png");
//
//   static SuggestionCardModel translation = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(LanguageTranslationPage.routeName),
//       title: LocalizationManager().translate("Translation"),
//       subtitle: LocalizationManager().translate('TranslateLanguages'),
//       imgSrc: "assets/suggestion/translation.png");
//
//   static SuggestionCardModel summary = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate("Summary")),
//       title: LocalizationManager().translate("Summary"),
//       subtitle: LocalizationManager().translate('CondenseSummaries'),
//       imgSrc: "assets/suggestion/summary.png");
//
//   static SuggestionCardModel plagiarismChecker = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('PlagiarismChecker')),
//       title: LocalizationManager().translate('PlagiarismChecker'),
//       subtitle: LocalizationManager().translate('DetectInstances'),
//       imgSrc: "assets/suggestion/plagiarism_checker.png");
//
//   static List<SuggestionCardModel> healthList = [
//     symptomsChecker,
//     mentalHealth,
//     fitness,
//     nutrition,
//   ];
//
//   static SuggestionCardModel symptomsChecker = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('SymptomsChecker')),
//       title: LocalizationManager().translate('SymptomsChecker'),
//       subtitle: LocalizationManager().translate('identifyAilments'),
//       imgSrc: "assets/suggestion/symptoms_checker.png");
//
//   static SuggestionCardModel mentalHealth = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('MentalHealth')),
//       title: LocalizationManager().translate('MentalHealth'),
//       subtitle: LocalizationManager().translate('WellnessAdvice'),
//       imgSrc: "assets/suggestion/mental_health.png");
//
//   static SuggestionCardModel fitness = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate("Fitness")),
//       title: LocalizationManager().translate("Fitness"),
//       subtitle: LocalizationManager().translate('WorkoutMore'),
//       imgSrc: "assets/suggestion/fitness.png");
//
//   static SuggestionCardModel nutrition = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate("Nutrition")),
//       title: LocalizationManager().translate("Nutrition"),
//       subtitle: LocalizationManager().translate('DietGuidance'),
//       imgSrc: "assets/suggestion/ntrition.png");
//
//   static List<SuggestionCardModel> educationList = [
//     mathSolver,
//     homeworkHelper,
//     history,
//     science,
//     islamics,
//   ];
//
//   static SuggestionCardModel mathSolver = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate('MathSolver')),
//       title: LocalizationManager().translate('MathSolver'),
//       subtitle: LocalizationManager().translate('QuickSolutions'),
//       imgSrc: "assets/suggestion/maths.png");
//
//   static SuggestionCardModel homeworkHelper = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('HomeworkHelper')),
//       title: LocalizationManager().translate('HomeworkHelper'),
//       subtitle: LocalizationManager().translate('EfficientHelper'),
//       imgSrc: "assets/suggestion/maths.png");
//
//   static SuggestionCardModel history = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate("History")),
//       title: LocalizationManager().translate("History"),
//       subtitle: LocalizationManager().translate('ExploringPast'),
//       imgSrc: "assets/suggestion/history.png");
//
//   static SuggestionCardModel science = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate("Science")),
//       title: LocalizationManager().translate("Science"),
//       subtitle: LocalizationManager().translate('UnlockingDiscovery'),
//       imgSrc: "assets/suggestion/science.png");
//
//   static SuggestionCardModel islamics = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate("Islamics")),
//       title: LocalizationManager().translate("Islamics"),
//       subtitle: LocalizationManager().translate('DeepTeachings'),
//       imgSrc: "assets/suggestion/islam.png");
//
//   /// work list
//
//   static List<SuggestionCardModel> workList = [
//     cvBuilding,
//     jobSearchStratigies,
//     conflictResolution,
//     management
//   ];
//
//   static SuggestionCardModel cvBuilding = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate('CVBuilding')),
//       title: LocalizationManager().translate('CVBuilding'),
//       subtitle: LocalizationManager().translate('CraftingCareers'),
//       imgSrc: "assets/suggestion/resume.png");
//
//   static SuggestionCardModel jobSearchStratigies = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('JobStrategies')),
//       title: LocalizationManager().translate('JobStrategies'),
//       subtitle: LocalizationManager().translate('StrategicHiring'),
//       imgSrc: "assets/suggestion/job.png");
//
//   static SuggestionCardModel conflictResolution = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('ConflictResolution')),
//       title: LocalizationManager().translate('ConflictResolution'),
//       subtitle: LocalizationManager().translate('ResolvingHarmony'),
//       imgSrc: "assets/suggestion/conflict.png");
//
//   static SuggestionCardModel management = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate('Management')),
//       title: LocalizationManager().translate('Management'),
//       subtitle: LocalizationManager().translate('StreamliningLeadership'),
//       imgSrc: "assets/suggestion/management.png");
//
//   /// family list
//
//   static List<SuggestionCardModel> familyList = [
//     parentingAdvice,
//     bedtimeStories,
//     chefNabigh,
//     relationship,
//     familyBudgeting
//   ];
//
//   static SuggestionCardModel parentingAdvice = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('ParentingAdvice')),
//       title: LocalizationManager().translate('ParentingAdvice'),
//       subtitle: LocalizationManager().translate('PositiveTechniques'),
//       imgSrc: "assets/suggestion/parrenting.png");
//
//   static SuggestionCardModel bedtimeStories = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('BedtimeStories')),
//       title: LocalizationManager().translate('BedtimeStories'),
//       subtitle: LocalizationManager().translate('ClassicChildren'),
//       imgSrc: "assets/suggestion/storytelling.png");
//
//   static SuggestionCardModel chefNabigh = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!
//           .pushNamed(DefaultSuggestionPage.routeName, arguments: LocalizationManager().translate('ChefNabigh')),
//       title: LocalizationManager().translate('ChefNabigh'),
//       subtitle: LocalizationManager().translate('YourPersonalDelights'),
//       imgSrc: "assets/suggestion/chef.png");
//
//   static SuggestionCardModel relationship = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate("Relationship")),
//       title: LocalizationManager().translate("Relationship"),
//       subtitle: LocalizationManager().translate('NurturingUnderstanding'),
//       imgSrc: "assets/suggestion/relationship.png");
//
//   static SuggestionCardModel familyBudgeting = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('FamilyBudgeting')),
//       title: LocalizationManager().translate('FamilyBudgeting'),
//       subtitle: LocalizationManager().translate('ManagingHouseholdFinances'),
//       imgSrc: "assets/suggestion/budget.png");
//
//   /// other list
//
//   static SuggestionCardModel passwordGenerator = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('PasswordGenerator')),
//       title: LocalizationManager().translate('PasswordGenerator'),
//       subtitle: LocalizationManager().translate('GenerateApplications'),
//       imgSrc: "assets/suggestion/password.png");
//
//   static SuggestionCardModel dreamInterpreter = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('DreamInterpreter')),
//       title: LocalizationManager().translate('DreamInterpreter'),
//       subtitle: LocalizationManager().translate('GainMeanings'),
//       imgSrc: "assets/suggestion/dream.png");
//
//   static SuggestionCardModel talkWithNabigh = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('TalkNabigh')),
//       title: LocalizationManager().translate('TalkNabigh'),
//       subtitle: LocalizationManager().translate('ConverseTopics'),
//       imgSrc: "assets/suggestion/talk_with_nabigh.png");
//
//   static SuggestionCardModel policiesProcedures = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('PoliciesProcedures')),
//       title: LocalizationManager().translate('PoliciesProcedures'),
//       subtitle: LocalizationManager().translate('GuidingClear'),
//       imgSrc: "assets/suggestion/policy_procedure.png");
//
//   static SuggestionCardModel smartDeviceCare = SuggestionCardModel(
//       onTap: () => navigatorKey.currentState!.pushNamed(
//           DefaultSuggestionPage.routeName,
//           arguments: LocalizationManager().translate('SmartDeviceCare')),
//       title: LocalizationManager().translate('SmartDeviceCare'),
//       subtitle: LocalizationManager().translate('DiagnoseOptimize'),
//       imgSrc: "assets/suggestion/smart_device.png");
// }

class SuggestionTagModel {
  final String title;
  final List<SuggestionCardModel> categorySuggestionList;

  SuggestionTagModel(
      {required this.title, required this.categorySuggestionList});
}

// List<SuggestionTagModel> allSuggestion = [
//   SuggestionTagModel(
//       title: LocalizationManager().translate('MostlyUsed'),
//       categorySuggestionList: SuggestionItem.mostlyUsed),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("Writing"),
//       categorySuggestionList: SuggestionItem.writingSuggestionList),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("Business"),
//       categorySuggestionList: SuggestionItem.businessSuggestionList),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("LanguageTools"),
//       categorySuggestionList: SuggestionItem.languageSuggestionList),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("Health"), categorySuggestionList: SuggestionItem.healthList),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("Education"), categorySuggestionList: SuggestionItem.educationList),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("Work"), categorySuggestionList: SuggestionItem.workList),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("Family"), categorySuggestionList: SuggestionItem.familyList),
//   SuggestionTagModel(
//       title: LocalizationManager().translate("OtherTools"),
//       categorySuggestionList: SuggestionItem.otherCategoryList),
// ];
