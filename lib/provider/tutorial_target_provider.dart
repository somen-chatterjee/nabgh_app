import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/helper/sp_helper.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialTargetProvider with ChangeNotifier {
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey tab1 = GlobalKey();
  GlobalKey searchTab = GlobalKey();
  GlobalKey sidebarTab = GlobalKey();
  GlobalKey slideTab = GlobalKey();

  void showTutorial({required BuildContext context}) async {
    tutorialCoachMark.show(context: context);
    await SpHelper.saveBool(SpKey.tutorialShowed, true);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.grey.shade900,
      textSkip: LocalizationManager().translate('Skip'),
      paddingFocus: 10,
      opacityShadow: 0.5,
      hideSkip: true,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        debugPrint("finish");
      },
      onClickTarget: (target) {
        debugPrint('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        debugPrint("target: $target");
        debugPrint(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay: $target');
      },
      onSkip: () {
        debugPrint("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    //target for focus on category and tab
    targets.add(
      TargetFocus(
        identify: "tab1",
        keyTarget: tab1,
        alignSkip: Alignment.topRight,
        // enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        // radius: 5,
        paddingFocus: 115.0,
        contents: [
          TargetContent(
            padding: const EdgeInsets.symmetric(
              vertical: 150.0,
              horizontal: 20.0,
            ),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey.shade800,
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "استخدم القائمة الرئيسية في أسفل الشاشة للانتقال بين مختلف الأقسام. اختر من بين الخيارات مثل الرئيسية البحث الاكتشاف .والمزيد",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.secondaryColor),
                          onPressed: () {
                            controller.skip();
                          },
                          child: Text(
                            LocalizationManager().translate('Skip'),
                            style: const TextStyle(color: Colors.white,fontSize: 12.0,),
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.secondaryColor),
                          onPressed: () {
                            controller.next();
                          },
                          child: Text(
                            LocalizationManager().translate('Next'),
                            style: const TextStyle(color: Colors.white,fontSize: 12.0,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    //target for search bar
    targets.add(
      TargetFocus(
        identify: "searchTab",
        keyTarget: searchTab,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        paddingFocus: 20.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.symmetric(
              vertical: 150.0,
              horizontal: 20.0,
            ),
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey.shade800,
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "أطلب أو أستفسر : نابغ في خدمتك للإجابة أو المساعدة",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.secondaryColor),
                          onPressed: () {
                            controller.skip();
                          },
                          child: Text(
                            LocalizationManager().translate('Skip'),
                            style: const TextStyle(color: Colors.white,fontSize: 12.0,),
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.secondaryColor),
                          onPressed: () {
                            controller.next();
                          },
                          child: Text(
                            LocalizationManager().translate('Next'),
                            style: const TextStyle(color: Colors.white,fontSize: 12.0,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    //target for side bar button
    targets.add(
      TargetFocus(
        identify: "sidebarTab",
        keyTarget: sidebarTab,
        alignSkip: Alignment.topLeft,
        shape: ShapeLightFocus.Circle,
        // paddingFocus: 20.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.symmetric(
              vertical: 150.0,
              horizontal: 20.0,
            ),
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey.shade800,
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "اكتشف المزيد: انقر هنا لتصفح جميع الفئات والخدمات المتاحة بسهولة",
                        style: TextStyle(color: Colors.white,),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.secondaryColor),
                          onPressed: () {
                            controller.skip();
                          },
                          child: Text(
                            LocalizationManager().translate('Skip'),
                            style: const TextStyle(color: Colors.white,fontSize: 12.0,),
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.secondaryColor),
                          onPressed: () {
                            controller.next();
                          },
                          child: Text(
                            LocalizationManager().translate('Next'),
                            style: const TextStyle(color: Colors.white,fontSize: 12.0,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    //target for side bar button
    targets.add(
      TargetFocus(
        identify: "slideTab",
        keyTarget: slideTab,
        alignSkip: Alignment.topRight,
        // shape: ShapeLightFocus.RRect,
        // paddingFocus: 20.0,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            padding: const EdgeInsets.symmetric(
              vertical: 90.0,
              horizontal: 20.0,
            ),
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Lottie.asset(
                    'assets/lottie/swipe_right.json',
                    width: 40,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey.shade800,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Text(
                          "اسحب الشاشة لليسار للوصول إلى سجل المحادثات بشكل أسرع",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5.0,),
                        Row(
                          children: [

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.secondaryColor),
                              onPressed: () {
                                controller.skip();
                              },
                              child: Text(
                                LocalizationManager().translate('done'),
                                style: const TextStyle(color: Colors.white,fontSize: 12.0,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }
}
