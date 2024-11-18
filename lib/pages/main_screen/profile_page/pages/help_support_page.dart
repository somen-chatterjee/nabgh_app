
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/provider/profile_provider.dart';
import 'package:nabgh_app/widget/app_back_button.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';

import '../../../../enum/app_loading_staus.dart';
import '../../../../widget/app_textField.dart';

class HelpPage extends StatefulWidget {
  static const routeName = "help-support-page";

  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<HelpPage> {
  final TextEditingController phoneController = TextEditingController();

  buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16)
          .copyWith(top: 6, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            LocalizationManager().translate("Help"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Consumer<ProfileProvider>(
              builder: (context, pProfile, child) {
                return Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        AppTextField(
                          controller: pProfile.nameController,
                          imgSrc: "assets/icon/name_input.svg",
                          title: LocalizationManager().translate("Name"),
                          // inputFormat: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AppTextField(
                          controller: pProfile.emailController,
                          imgSrc: "assets/icon/mail.svg",
                          title: LocalizationManager().translate("Email"),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // AppTextField(
                        //     controller: phoneController,
                        //     imgSrc: "assets/icon/call.svg",
                        //     title: "Phone"),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        AppTextField(
                          maxLine: 5,
                          controller: pProfile.messageController,
                          imgSrc: "assets/icon/mail.svg",
                          title: LocalizationManager().translate("Message"),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 45,
                          child: AppSmallButton(
                            title: pProfile.loadingStatus !=
                                    AppLoadingStatus.loading
                                ? Text(
                                    LocalizationManager().translate("Send"),
                                    style: const TextStyle(color: Colors.black),
                                  )
                                : const CircularProgressIndicator(),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (pProfile.loadingStatus !=
                                  AppLoadingStatus.loading) {
                                HapticFeedback.lightImpact();
                                pProfile.validateHelp();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
