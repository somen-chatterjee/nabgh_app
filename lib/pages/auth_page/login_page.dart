import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/helper/firebase_service.dart';
import 'package:nabgh_app/helper/sp_helper.dart';
import 'package:nabgh_app/pages/auth_page/fogrgot_password_page.dart';
import 'package:nabgh_app/pages/auth_page/signup_page.dart';
import 'package:nabgh_app/pages/main_screen/main_screen.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:nabgh_app/widget/app_textField.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../change_language/language_helper.dart';
import '../../enum/app_loading_staus.dart';
import '../../provider/auth_provider.dart';
import '../../widget/app_loadig_indicator.dart';
import '../../widget/auth_background.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "login-page";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isCheckBox = false;

  Future<User?> signInWithGoogle(BuildContext context) async {
    showDialog(context: context, builder: (builder) => AppLoadingIndicator());

    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // if(context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text("Something Went Wrong!!")));
        // }
        // return null;
      }
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      var result = await FirebaseAuth.instance.signInWithCredential(credential);

      // print("print ${result.user}");

      if (context.mounted) {
        Navigator.pop(context);
      }
      return result.user;

      // socialLogin(
      //   type: "google",
      //   name: result.user?.displayName ?? "",
      //   email: result.user?.email ?? "",
      //   socialId: result.credential?.accessToken,
      // );
    } catch (e) {
      //BaseOverlays().showSnackBar(message: "${e}");
      // if(context.mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("Something Went Wrong!!")));
      // }
      if (context.mounted) {
        Navigator.pop(context);
      }
      return null;
    }
  }

  buildSocialIcon({required String imgSrc, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1C231C),
          // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey),
        ),
        child: Image.asset(
          imgSrc,
          height: 30,
          width: 30,
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = context.read<AuthenticateProvider>();

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const AuthBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: height * .05),
                              child: SvgPicture.asset("assets/icon/brain.svg",
                                  height: height * .08, width: width * .8),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16)),
                                  color: AppConstants.secondaryColor),
                              child: Text(
                                LocalizationManager()
                                    .translate("Login")
                                    .toUpperCase(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Text(
                          LocalizationManager().translate("Welcome"),
                          style: const TextStyle(fontSize: 32),
                        ),
                        Text(
                          LocalizationManager().translate("signInToContinue"),
                          style: TextStyle(color: Colors.white.withOpacity(.6)),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        AppTextField(
                          controller: authProvider.emailController,
                          imgSrc: "assets/icon/mail.svg",
                          title: LocalizationManager()
                              .translate('EnterYourEmailId'),
                          validator: (value) => authProvider.validateEmail(),
                          maxLine: 1,
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        AppTextField(
                          controller: authProvider.passwordController,
                          imgSrc: "assets/icon/lock.svg",
                          title: LocalizationManager().translate("Password"),
                          showHideBtn: true,
                          validator: (value) => authProvider.validatePassword(),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isCheckBox,
                              onChanged: (value) {
                                isCheckBox = value!;
                                setState(() {});
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              side: const BorderSide(color: AppConstants.secondaryColor, width: 1.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: const BorderSide(color: AppConstants.secondaryColor, width: 1.0),
                              ),
                              activeColor: AppConstants.secondaryColor,
                            ),
                            const SizedBox(width: 1,),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: " ${LocalizationManager().translate('iAgreeTo')} ",
                                  style: const TextStyle().copyWith(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " ${LocalizationManager().translate('termEULA')} ",
                                      style: const TextStyle().copyWith(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        fontSize: 12.5,
                                      ),
                                      recognizer: TapGestureRecognizer()..onTap = (){
                                        launchUrl(Uri.parse(AppKey.privacyPolicyUrl), mode: LaunchMode.externalApplication);
                                        // Get.to(TermsAndConditionUrlScreen(url: WebApiConstant.termsAndConditionUrl,));
                                      },
                                    ),
                                    TextSpan(
                                      text: " ${LocalizationManager().translate('and')} ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ${LocalizationManager().translate('privacyPolicy.')} ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        fontSize: 12.5,
                                      ),
                                      recognizer: TapGestureRecognizer()..onTap = (){
                                        launchUrl(Uri.parse(AppKey.privacyPolicyUrl), mode: LaunchMode.externalApplication);
                                        // Get.to(TermsAndConditionUrlScreen(url: WebApiConstant.privacyPolicyUrl,));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              authProvider.clearController();
                              Navigator.of(context)
                                  .pushNamed(ForgotPasswordPage.routeName)
                                  .then((value) =>
                                      authProvider.clearController());
                            },
                            child: Text(
                              LocalizationManager().translate('ForgotPassword'),
                              style: const TextStyle(color: Color(0xffA8A8A8)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Consumer<AuthenticateProvider>(
                          builder: (context, provider, _) {
                            return SizedBox(
                              height: 45,
                              child: AppSmallButton(
                                title: provider.loadingStatus ==
                                        AppLoadingStatus.loading
                                    ? CircularProgressIndicator(
                                        color: Colors.black.withOpacity(.8),
                                      )
                                    : Text(
                                        LocalizationManager()
                                            .translate("Login"),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  HapticFeedback.lightImpact();
                                  if (_formKey.currentState!.validate()) {
                                    if(isCheckBox) {
                                      provider.login(
                                        context: context,
                                        social: false,
                                        map: {},
                                      );
                                    } else {
                                      AppConstants.getToast(message: LocalizationManager().translate('checkTermsAndConditions'));
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                              children: [
                                TextSpan(
                                  text: LocalizationManager()
                                      .translate('DontHaveAccount'),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(.6)),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return const SignUpPage();
                                          })).then((value) =>
                                          authProvider.clearController());
                                      authProvider.clearController();
                                    },
                                    child: Text(
                                      LocalizationManager().translate('SignUp'),
                                      style: const TextStyle(
                                        color: AppConstants.secondaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * .15,
                            ),
                            Expanded(
                              child: Container(
                                height: .3,
                                color: Colors.white.withOpacity(.4),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              LocalizationManager().translate('Or'),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.6)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                height: .3,
                                color: Colors.white.withOpacity(.4),
                              ),
                            ),
                            SizedBox(
                              width: width * .15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .025,
                        ),
                        Center(
                            child: Text(
                          LocalizationManager().translate('SocialMediaLogin'),
                          style: TextStyle(color: Colors.white.withOpacity(.6)),
                        )),
                        SizedBox(
                          height: height * .015,
                        ),
                        Consumer<AuthenticateProvider>(
                          builder: (context, value, child) {
                            return Row(
                              children: [

                                Expanded(child: buildSocialIcon(
                                  imgSrc: 'assets/icon/google.png',
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    // var v = await signInWithGoogle();
                                    // setState(() {
                                    //
                                    // });
                                    // print('UserCredential $v');
                                    signInWithGoogle(context)
                                        .then((user) async {
                                      var fcmToken = await SpHelper.loadString(SpKey.FCMtoken);
                                      if (user != null) {
                                        Map<String, dynamic> postBody = {
                                          "email": user.email,
                                          "name": user.displayName,

                                          /// todo: replace with fcm id
                                          "device_token": fcmToken ?? "",
                                          "login_type": "1",
                                          "social_id": user.uid,
                                          "device_id":
                                          await value.getDeviceIdentifier(),
                                        };

                                        if (context.mounted) {
                                          value.login(
                                              context: context,
                                              social: true,
                                              map: postBody);
                                        }
                                      }
                                    });
                                  },
                                ),),
                                /*SizedBox(
                              width: width * .05,
                            ),
                            buildSocialIcon(
                                imgSrc: 'assets/icon/facebook.png', onTap: () {}),*/
                                if (Platform.isIOS)
                                  SizedBox(
                                    width: width * .05,
                                  ),
                                if (Platform.isIOS)
                                  Expanded(child: buildSocialIcon(
                                    imgSrc: 'assets/icon/apple.png',
                                    onTap: () async {
                                      final apple = await SignInWithApple
                                          .getAppleIDCredential(scopes: [
                                        AppleIDAuthorizationScopes.email,
                                        AppleIDAuthorizationScopes.fullName
                                      ]);
                                      var fcmToken = await SpHelper.loadString(SpKey.FCMtoken);
                                      if (apple.userIdentifier != null) {
                                        print(apple.givenName);
                                        print(apple.givenName);
                                        print(apple.familyName);
                                        Map<String, dynamic> postBody = {
                                          "email": apple.email,
                                          "name": apple.givenName,

                                          /// todo: replace with fcm id
                                          "device_token": fcmToken ?? "",
                                          "login_type": "1",
                                          "social_id": apple.userIdentifier,
                                          "device_id":
                                          await value.getDeviceIdentifier(),
                                        };

                                        if (context.mounted) {
                                          value.login(
                                              context: context,
                                              social: true,
                                              map: postBody);
                                        }
                                      }
                                    },
                                  ),),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  MainScreen.routeName,
                                      (Route<dynamic> route) => false);
                            },
                            child: Text(
                              LocalizationManager()
                                  .translate('ContinueAsGuest'),
                              style: const TextStyle(
                                  color: AppConstants.secondaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                      ],
                    ),
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
