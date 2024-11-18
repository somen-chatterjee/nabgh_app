import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/widget/app_small_button.dart';

import '../auth_page/login_page.dart';

class LoginModal extends StatelessWidget {
  const LoginModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0,),
              child: IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                icon: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade600,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.grey.shade600,
                    size: 18.0,
                  ),
                ),
              ),
            ),
          ),

          Text(
            LocalizationManager().translate('pleaseLoginFirst'),
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
            LocalizationManager().translate('getRecommendations'),
            style: const TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: AppSmallButton(
                title: Text(
                  LocalizationManager().translate('Login'),
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (builder) {
                      return const LoginPage();
                    }),
                    (route) => false,
                  );
                }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
