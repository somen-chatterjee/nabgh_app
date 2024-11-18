import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nabgh_app/pages/auth_page/fogrgot_password_page.dart';
import 'package:nabgh_app/pages/auth_page/forgot_pin_page.dart';
import 'package:nabgh_app/pages/auth_page/login_page.dart';
import 'package:nabgh_app/pages/auth_page/register_pin_page.dart';
import 'package:nabgh_app/pages/auth_page/reset_password_page.dart';
import 'package:nabgh_app/pages/main_screen/chat_page/discover_chat_screen.dart';
import 'package:nabgh_app/pages/main_screen/discover_page/sub_category_page.dart';
import 'package:nabgh_app/pages/main_screen/main_screen.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/edit_profile_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/faq_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/help_support_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/password_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/privacy_policyy_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/pages/terms_condition_page.dart';
import 'package:nabgh_app/pages/main_screen/profile_page/profile_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/business_plan_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/competior_analysis_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/default_suggestion_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/interviewing_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/language_translation_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/meeting_summary.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/proposals_for_clients.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/sociial_content_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/suggestion_pages/write_email_page.dart';
import 'package:nabgh_app/pages/main_screen/search_page/widget/scanner.dart';
import 'package:nabgh_app/pages/main_screen/subscription_page/subscription_detail_page.dart';
import 'package:nabgh_app/pages/main_screen/subscription_page/subscription_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case ForgotPasswordPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ForgotPasswordPage(),
        settings: routeSettings,
      );

    case PasswordResetPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const PasswordResetPage(),
        settings: routeSettings,
      );

    case ForgotPinInputPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ForgotPinInputPage(),
        settings: routeSettings,
      );

    case RegisterPinInputPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const RegisterPinInputPage(),
        settings: routeSettings,
      );

    case ResetPasswordSettingPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ResetPasswordSettingPage(),
        settings: routeSettings,
      );

    case HelpPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const HelpPage(),
        settings: routeSettings,
      );

    case MainScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const MainScreen(),
        settings: routeSettings,
      );

    case ProfilePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ProfilePage(),
        settings: routeSettings,
      );

    case EditProfilePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const EditProfilePage(),
        settings: routeSettings,
      );

    case PrivacyPolicyPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const PrivacyPolicyPage(),
        settings: routeSettings,
      );

    case TermConditionPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const TermConditionPage(),
        settings: routeSettings,
      );

    case SubscriptionPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const SubscriptionPage(),
        settings: routeSettings,
      );

    case SubscriptionDetailPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const SubscriptionDetailPage(),
        settings: routeSettings,
      );

    case FaqPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const FaqPage(),
        settings: routeSettings,
      );

    case DiscoverChatPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const DiscoverChatPage(),
        settings: routeSettings,
      );

    case LanguageTranslationPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const LanguageTranslationPage(),
        settings: routeSettings,
      );

    case LoginPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
        settings: routeSettings,
      );

    case MeetingSummeryPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const MeetingSummeryPage(),
        settings: routeSettings,
      );

    case WriteEmailPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const WriteEmailPage(),
        settings: routeSettings,
      );

    case SocialContentPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const SocialContentPage(),
        settings: routeSettings,
      );

    case BusinessPlanPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const BusinessPlanPage(),
        settings: routeSettings,
      );

    case CompetiorAnalysis.routeName:
      return MaterialPageRoute(
        builder: (_) => const CompetiorAnalysis(),
        settings: routeSettings,
      );

    case ProposalForClient.routeName:
      return MaterialPageRoute(
        builder: (_) => const ProposalForClient(),
        settings: routeSettings,
      );

    case InterviewingPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const InterviewingPage(),
        settings: routeSettings,
      );

    case DefaultSuggestionPage.routeName:
      String title = routeSettings.arguments as String;

      return MaterialPageRoute(
        builder: (_) => DefaultSuggestionPage(
          title: title,
        ),
        settings: routeSettings,
      );

    case Scanner.routeName:
      return MaterialPageRoute(
        builder: (_) => const Scanner(),
        settings: routeSettings,
      );

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text("route not implemented "),
                ),
              ));
  }
}
