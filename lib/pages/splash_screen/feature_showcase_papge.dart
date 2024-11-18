import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../change_language/language_helper.dart';
import '../../models/model/feature_showcase_model.dart';
import '../../widget/app_small_button.dart';
import '../auth_page/login_page.dart';

class FeatureShowCasePage extends StatefulWidget {
  const FeatureShowCasePage({super.key});

  @override
  State<FeatureShowCasePage> createState() => _FeatureShowCasePageState();
}

class _FeatureShowCasePageState extends State<FeatureShowCasePage> {
  PageController pageController = PageController(
    viewportFraction: 0.9,
    initialPage: 0,
  );
  final List<FeatureShowCaseModel> _featureList = [
    FeatureShowCaseModel(
        subtitle: LocalizationManager().translate("LearnSmartInteractive"),
        // title: "This can help you anytime, anywhere",
        title: LocalizationManager().translate('WelcomeToNabigh'),
        imgPath: "assets/showcase/showcase_1.svg"),
    FeatureShowCaseModel(
        subtitle: LocalizationManager().translate("EducationToHealth"),
        title: LocalizationManager().translate("DiscoverWideRangeServices"),
        imgPath: "assets/showcase/showcase_2.svg"),
    FeatureShowCaseModel(
        subtitle: LocalizationManager().translate("AdaptsToYourNeeds"),
        title: LocalizationManager().translate("PersonalUniqueExperience"),
        imgPath: "assets/showcase/showcase_3.svg"),
  ];

  final ValueNotifier<int> _pageIndex = ValueNotifier(0);

  onNext() {
    HapticFeedback.lightImpact();
    pageController.animateToPage(_pageIndex.value + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.linear);

  }

  goToNextPage() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) {
        return const LoginPage();
      }),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: .5,
            child: SvgPicture.asset(
              "assets/app_background.svg",
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    _pageIndex.value = index;
                  },
                  itemCount: _featureList.length,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BuildFeatureDetail(
                      index: index,
                      imagePath: _featureList[index].imgPath,
                      title: _featureList[index].title,
                      listLength: _featureList.length,
                      subtitle: _featureList[index].subtitle,
                      goToNextPage: goToNextPage,
                      onNext: onNext,
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _pageIndex,
                  builder: (context, value,_) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _featureList.length,
                          (id) {
                        if (id == value) {
                          return Container(
                            width: 28,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xff06CFF1))),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: Colors.white.withOpacity(.7),
                            ),
                          );
                        }
                      },
                    ).toList(),
                  );
                }
              ),
              const SizedBox(
                height: 60,
              ),
              ValueListenableBuilder(
                valueListenable: _pageIndex,
                builder: (context, value,_) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 22.0,
                      right: 22.0,
                      bottom: 45.0,
                    ),
                    child: value == 2
                        ? SizedBox(
                            width: 150,
                            height: 40,
                            child: AppSmallButton(
                              onTap: goToNextPage,
                              title: Text(
                                LocalizationManager().translate("StartNow"),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          )
                        : Row(
                          children: [
                            TextButton(
                              onPressed: goToNextPage,
                              child: Text(
                                LocalizationManager().translate("Skip"),
                                style: const TextStyle(color: Color(0xff06CFF1)),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 90,
                              height: 40,
                              child: AppSmallButton(
                                onTap: onNext,
                                title: Text(
                                  LocalizationManager().translate("Next"),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildFeatureDetail extends StatelessWidget {
  final int index;
  final String imagePath;
  final String title;
  final String subtitle;
  final int listLength;
  final VoidCallback goToNextPage;
  final VoidCallback onNext;

  const BuildFeatureDetail(
      {super.key,
      required this.index,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.listLength,
      required this.goToNextPage,
      required this.onNext});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          const Spacer(
            flex: 4,
          ),
          SvgPicture.asset(
            imagePath,
            height: height * .32,
            width: width * .8,
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .05),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: height * .02,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(.6),
            ),
          ),
          SizedBox(
            height: height * .08,
          ),
         /* Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              listLength,
              (id) {
                if (id == index) {
                  return Container(
                    width: 28,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xff06CFF1))),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white.withOpacity(.7),
                    ),
                  );
                }
              },
            ).toList(),
          ),*/
          // const Spacer(
          //   flex: 2,
          // ),
          /*index == 2
              ? SizedBox(
                  width: 150,
                  height: 40,
                  child: AppSmallButton(
                    onTap: goToNextPage,
                    title: Text(
                      LocalizationManager().translate("StartNow"),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                )
              : Row(
                  children: [
                    TextButton(
                      onPressed: goToNextPage,
                      child: Text(
                        LocalizationManager().translate("Skip"),
                        style: const TextStyle(color: Color(0xff06CFF1)),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 90,
                      height: 40,
                      child: AppSmallButton(
                        onTap: onNext,
                        title: Text(
                          LocalizationManager().translate("Next"),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),*/
          // const SizedBox(
          //   height: 40,
          // ),
        ],
      ),
    );
  }
}
