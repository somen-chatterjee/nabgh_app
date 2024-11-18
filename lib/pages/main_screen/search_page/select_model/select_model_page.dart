import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';

class SelectModelPage extends StatelessWidget {
  static const routeName = "select-model";
  final int modelIndex;
  final VoidCallback onTap;

  const SelectModelPage({
    super.key,
    required this.modelIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 46.0,
              height: 6.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    children: [
                      //GPT 3.5
                      InkWell(
                        onTap: modelIndex == 1 ? onTap : () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 18.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: modelIndex == 0
                                ? Colors.transparent
                                : Colors.grey.shade800,
                            border: modelIndex == 0
                                ? Border.all(
                                    color: AppConstants.secondaryColor,
                                    width: 1.5,
                                  )
                                : null,
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
                                  horizontal: 14.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  LocalizationManager()
                                      .onlyEnglish('chatGpt3.5'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                LocalizationManager()
                                    .translate('chatGpt3.5txt'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 16.0,
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
                                          value: 50 / 100,
                                          strokeWidth:
                                              7, // Adjust the thickness of the progress indicator
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          LocalizationManager()
                                              .translate('conciseness'),
                                          style: const TextStyle(
                                            fontSize: 12,
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
                                          value: 40 / 100,
                                          strokeWidth:
                                              7, // Adjust the thickness of the progress indicator
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          LocalizationManager()
                                              .translate('speed'),
                                          style: const TextStyle(
                                            fontSize: 12,
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
                                          value: 65 / 100,
                                          strokeWidth:
                                              7, // Adjust the thickness of the progress indicator
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          LocalizationManager()
                                              .translate('reasoning'),
                                          style: const TextStyle(
                                            fontSize: 12,
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
                        height: 20.0,
                      ),
                      //GPT 4
                      InkWell(
                        onTap: modelIndex == 0 ? onTap : () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 18.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: modelIndex == 1
                                ? Colors.transparent
                                : Colors.grey.shade800,
                            border: modelIndex == 1
                                ? Border.all(
                                    color: AppConstants.secondaryColor,
                                    width: 1.5,
                                  )
                                : null,
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
                                  horizontal: 14.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  LocalizationManager().onlyEnglish('gPT4'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                LocalizationManager().translate('gPT4Txt'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 16.0,
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
                                        Text(
                                          LocalizationManager()
                                              .translate('conciseness'),
                                          style: const TextStyle(
                                            fontSize: 12,
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
                                        Text(
                                          LocalizationManager()
                                              .translate('speed'),
                                          style: const TextStyle(
                                            fontSize: 12,
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
                                        Text(
                                          LocalizationManager()
                                              .translate('reasoning'),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
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
                                    fontWeight: FontWeight.bold,
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
