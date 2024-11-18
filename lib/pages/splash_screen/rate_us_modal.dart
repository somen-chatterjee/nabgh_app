import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';

import '../auth_page/login_page.dart';

class RateUsModal extends StatelessWidget {
  const RateUsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),
            Text(
              LocalizationManager().translate('rateThisApp'),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              LocalizationManager().translate('rateDescription'),
              style: const TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer<AuthenticateProvider>(
                builder: (context, provider, _)  {
                return SizedBox(
                  height: 40,
                  width: 150,
                  child: AppSmallButton(
                      title: Text(
                        LocalizationManager().translate('rateUs'),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                        provider.rateUs(buildContext: context);
                      },
                  ),
                );
              }
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                LocalizationManager().translate("noThanks"),
                style: const TextStyle(
                  // fontSize: 25,
                  color: AppConstants.secondaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppConstants.secondaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
