import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/pages/main_screen/main_screen.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:nabgh_app/widget/app_textField.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/app_loadig_indicator.dart';
import '../../widget/auth_background.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  bool isCheckBox = false;

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
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var authProvider = context.read<AuthenticateProvider>();

    Future<User?> signInWithGoogle(BuildContext context) async {
      showDialog(context: context, builder: (builder) => AppLoadingIndicator());
      try {
        final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

        if (gUser == null) {
          //return BaseOverlays().showSnackBar(message: "Something Went Wrong!!");
        }
        final GoogleSignInAuthentication gAuth = await gUser!.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken, idToken: gAuth.idToken);
        var result =
            await FirebaseAuth.instance.signInWithCredential(credential);

        print("print ${result.user}");

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
        if (context.mounted) {
          Navigator.pop(context);
        }
        return null;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const AuthBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                                  .translate('SignUp')
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
                        LocalizationManager().translate("Hi"),
                        style: const TextStyle(fontSize: 32),
                      ),
                      Text(
                        LocalizationManager().translate('createNewAccount'),
                        style: TextStyle(color: Colors.white.withOpacity(.6)),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      AppTextField(
                        controller: authProvider.nameController,
                        imgSrc: "assets/icon/name_input.svg",
                        title: LocalizationManager().translate('Name'),
                        // inputFormat: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),],
                        validator: (_) => authProvider.validateName(),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      AppTextField(
                        controller: authProvider.emailController,
                        imgSrc: "assets/icon/mail.svg",
                        title: LocalizationManager().translate('EnterEmailId'),
                        validator: (_) => authProvider.validateEmail(),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      AppTextField(
                        controller: authProvider.passwordController,
                        imgSrc: "assets/icon/lock.svg",
                        title: LocalizationManager().translate('Password'),
                        showHideBtn: true,
                        validator: (_) => authProvider.validateNewPassword(),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      AppTextField(
                        controller: authProvider.confirmPasswordController,
                        imgSrc: "assets/icon/lock.svg",
                        title:
                            LocalizationManager().translate('ConfirmPassword'),
                        showHideBtn: true,
                        validator: (_) =>
                            authProvider.validateConfirmPassword(),
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
                                      launchUrl(Uri.parse(AppKey.termsCondition), mode: LaunchMode.externalApplication);
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
                      SizedBox(
                        height: height * .03,
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
                                      LocalizationManager().translate('SignUp'),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // provider.validateSignUp(context);
                                HapticFeedback.lightImpact();
                                if (_formKey.currentState!.validate()) {
                                  if(isCheckBox) {
                                    provider.signUp(
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
                                    .translate('AlreadyHaveAnAccount'),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(.6),
                                ),
                              ),
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    LocalizationManager().translate('Login'),
                                    style: const TextStyle(
                                      color: AppConstants.secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
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
                            "Or",
                            style:
                                TextStyle(color: Colors.white.withOpacity(.6)),
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
                        LocalizationManager()
                            .translate('ContinueWithSocialMedia'),
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
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  signInWithGoogle(context).then((user) async {
                                    if (user != null) {
                                      Map<String, dynamic> postBody = {
                                        "email": user.email,
                                        "name": user.displayName,

                                        /// todo: replace with fcm id
                                        "device_token": "12345",
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
                                    final _apple = await SignInWithApple
                                        .getAppleIDCredential(scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName
                                    ]);

                                    if (_apple.userIdentifier != null) {
                                      Map<String, dynamic> postBody = {
                                        "email": _apple.email,
                                        "name": _apple.givenName,

                                        /// todo: replace with fcm id
                                        "device_token": "12345",
                                        "login_type": "1",
                                        "social_id": _apple.userIdentifier,
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
                            Navigator.of(context)
                                .pushNamed(MainScreen.routeName);
                          },
                          child: Text(
                            LocalizationManager().translate('ContinueAsGuest'),
                            style: const TextStyle(
                              color: AppConstants.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
