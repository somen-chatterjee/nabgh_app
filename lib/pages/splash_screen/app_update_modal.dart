import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';

import '../auth_page/login_page.dart';

class AppUpdateModal extends StatelessWidget {
  const AppUpdateModal({super.key});

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
              LocalizationManager().translate('updateAvailable'),
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
              LocalizationManager().translate('newUpdateAvailable'),
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
                        LocalizationManager().translate('update'),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        provider.rateUs(buildContext: context);
                      },
                  ),
                );
              }
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
