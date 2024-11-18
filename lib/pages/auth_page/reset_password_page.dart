import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../enum/app_loading_staus.dart';
import '../../widget/app_small_button.dart';
import '../../widget/app_textField.dart';
import '../../widget/auth_background.dart';
import 'login_page.dart';

class PasswordResetPage extends StatefulWidget {
  static const routeName = "reset-password-page";

  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authProvider = context.read<AuthenticateProvider>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
                          padding: EdgeInsets.only(top: height * .09),
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
                      LocalizationManager().translate('ResetPassword'),
                      style: const TextStyle(fontSize: 32),
                    ),
                    Text(
                      LocalizationManager().translate('signInToContinue'),
                      style: TextStyle(color: Colors.white.withOpacity(.6)),
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    AppTextField(
                      controller: authProvider.passwordController,
                      imgSrc: "assets/icon/lock.svg",
                      title: LocalizationManager().translate("Password"),
                      showHideBtn: true,
                      validator: (_) => authProvider.validateNewPassword(),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    AppTextField(
                      controller: authProvider.confirmPasswordController,
                      imgSrc: "assets/icon/lock.svg",
                      title: LocalizationManager().translate("ConfirmPassword"),
                      showHideBtn: true,
                      validator: (_) => authProvider.validateConfirmPassword(),
                    ),
                    SizedBox(
                      height: height * .04,
                    ),
                    Consumer<AuthenticateProvider>(
                        builder: (context, provider, _) {
                      return SizedBox(
                        height: 45,
                        child: AppSmallButton(
                          title:
                              provider.loadingStatus == AppLoadingStatus.loading
                                  ? CircularProgressIndicator(
                                      color: Colors.black.withOpacity(.8),
                                    )
                                  : Text(
                                      LocalizationManager()
                                          .translate('ResetPassword'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            if (_formKey.currentState!.validate()) {
                              provider.resetPassword(context: context);
                            }
                          },
                        ),
                      );
                    }),
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
