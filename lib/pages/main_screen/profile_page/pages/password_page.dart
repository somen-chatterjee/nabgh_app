import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/provider/profile_provider.dart';

import 'package:nabgh_app/widget/app_back_button.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';

import '../../../../widget/app_textField.dart';

class ResetPasswordSettingPage extends StatefulWidget {
  static const routeName = "reset-password-settings-page";

  const ResetPasswordSettingPage({super.key});

  @override
  State<ResetPasswordSettingPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ResetPasswordSettingPage> {
  buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16)
          .copyWith(top: 6, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            LocalizationManager().translate('changePassword'),
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          const SizedBox(
            width: 18,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).clearModels();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var profileProvider = context.read<ProfileProvider>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      AppTextField(
                        controller: profileProvider.currentPasswordController,
                        imgSrc: "assets/icon/lock.svg",
                        title:
                            LocalizationManager().translate('currentPassword'),
                        showHideBtn: true,
                        validator: (_) => profileProvider.validatePassword(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AppTextField(
                        controller: profileProvider.passwordController,
                        imgSrc: "assets/icon/lock.svg",
                        title: LocalizationManager().translate('newPassword'),
                        showHideBtn: true,
                        validator: (_) => profileProvider.validateNewPassword(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AppTextField(
                        controller:
                            profileProvider.passwordConfirmationController,
                        imgSrc: "assets/icon/lock.svg",
                        title: LocalizationManager()
                            .translate('confirmNewPassword'),
                        showHideBtn: true,
                        validator: (_) =>
                            profileProvider.validateConfirmPassword(),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        height: 45,
                        child: Consumer<ProfileProvider>(
                            builder: (context, provider, _) {
                          return AppSmallButton(
                            title: provider.loadingStatus ==
                                    AppLoadingStatus.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Text(
                                    LocalizationManager().translate("Save"),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              if (_formKey.currentState!.validate()) {
                                provider.changePassword();
                              }
                            },
                          );
                        }),
                      )
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
