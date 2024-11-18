import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/widget/app_back_button.dart';

import '../../subscription_page/subscription_page.dart';

class SelectModelSubscribePage extends StatefulWidget {
  static const routeName = "select-model-subscribe";

  const SelectModelSubscribePage({
    super.key,
  });

  @override
  State<SelectModelSubscribePage> createState() =>
      _SelectModelSubscribePageState();
}

class _SelectModelSubscribePageState extends State<SelectModelSubscribePage> {
  @override
  Widget build(BuildContext context) {
    buildAppBar() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0)
            .copyWith(bottom: 10, top: 4),
        child: Row(
          children: [
            const AppBackButton(),
            const Spacer(),
            Text(
              LocalizationManager().translate('selectModel'),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            const Spacer(),
            const SizedBox(
              width: 24.0,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40.0,
                      ),
                      //GPT 3.5
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22.0,
                          vertical: 18.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.transparent,
                          border: Border.all(
                            color: AppConstants.secondaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: AppConstants.secondaryColor,
                              ),
                              alignment: AlignmentDirectional.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                                vertical: 14.0,
                              ),
                              child: Text(
                                LocalizationManager().onlyEnglish('chatGpt3.5'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              LocalizationManager()
                                  .translate('chatGpt3.5txt'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 18.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppConstants.secondaryColor,
                                        backgroundColor: Colors.grey.shade700,
                                        value: 45 / 100,
                                        strokeWidth:
                                            7, // Adjust the thickness of the progress indicator
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Conciseness',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppConstants.secondaryColor,
                                        backgroundColor: Colors.grey.shade700,
                                        value: 100 / 100,
                                        strokeWidth:
                                            7, // Adjust the thickness of the progress indicator
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Speed',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppConstants.secondaryColor,
                                        backgroundColor: Colors.grey.shade700,
                                        value: 65 / 100,
                                        strokeWidth:
                                            7, // Adjust the thickness of the progress indicator
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Reasoning',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      //GPT 4
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context)
                              .pushNamed(SubscriptionPage.routeName)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22.0,
                            vertical: 20.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey.shade800,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: AppConstants.secondaryColor,
                                ),
                                alignment: AlignmentDirectional.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 30.0,
                                      height: 24.0,
                                    ),
                                    Text(
                                      LocalizationManager().onlyEnglish('gPT4'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        "assets/icon/crown.png",
                                        width: 20.0,
                                        height: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                LocalizationManager().translate('gPT4Txt'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 18.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppConstants.secondaryColor,
                                          backgroundColor: Colors.grey.shade700,
                                          value: 85 / 100,
                                          strokeWidth:
                                              7, // Adjust the thickness of the progress indicator
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Conciseness',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppConstants.secondaryColor,
                                          backgroundColor: Colors.grey.shade700,
                                          value: 45 / 100,
                                          strokeWidth:
                                              7, // Adjust the thickness of the progress indicator
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Speed',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppConstants.secondaryColor,
                                          backgroundColor: Colors.grey.shade700,
                                          value: 100 / 100,
                                          strokeWidth:
                                              7, // Adjust the thickness of the progress indicator
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Reasoning',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.info_outlined),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: LocalizationManager()
                                      .translate('caution'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                  ),
                                ),
                                TextSpan(
                                  text: LocalizationManager()
                                      .translate('cautionTxt'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
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
