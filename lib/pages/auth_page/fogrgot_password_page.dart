import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/helper/auth_helperr.dart';
import 'package:nabgh_app/router.dart';
import 'package:provider/provider.dart';

import '../../constatns/app_constants.dart';
import '../../enum/app_loading_staus.dart';
import '../../provider/auth_provider.dart';
import '../../widget/app_small_button.dart';
import '../../widget/app_textField.dart';
import '../../widget/auth_background.dart';
import 'forgot_pin_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = "forgot-password-page";

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var authProvider = context.read<AuthenticateProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const AuthBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * .08),
                          child: SvgPicture.asset("assets/icon/brain.svg",
                              height: height * .08, width: width * .8),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    Text(
                      LocalizationManager().translate('ForgotPassword1'),
                      style: const TextStyle(fontSize: 32),
                    ),
                    Text(
                      LocalizationManager()
                          .translate('enterEmailForgotPassword'),
                      style: TextStyle(color: Colors.white.withOpacity(.6)),
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    AppTextField(
                      controller:
                          context.read<AuthenticateProvider>().emailController,
                      imgSrc: "assets/icon/mail.svg",
                      title:
                          LocalizationManager().translate('EnterYourEmailId'),
                      validator: (_) => authProvider.validateEmail(),
                    ),
                    SizedBox(
                      height: height * .04,
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
                                    LocalizationManager().translate('GetOTP'),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black,
                                    ),
                                  ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              HapticFeedback.lightImpact();
                              // provider.validateForgotEmail(context);
                              if(_formKey.currentState!.validate()){
                                provider.forgotPassword(context: context, navigate: true);
                              }
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
