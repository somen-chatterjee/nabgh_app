import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/models/model/subscription_plan_model.dart';
import 'package:nabgh_app/widget/app_back_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../enum/app_loading_staus.dart';
import '../../../helper/InApp.dart';
import '../../../helper/auth_helperr.dart';
import '../../../provider/profile_provider.dart';
import '../../../provider/subscription_provider.dart';
import '../../../widget/app_small_button.dart';
import '../../../widget/progress_page.dart';
import '../login_modal.dart';

class SubscriptionPage extends StatefulWidget {
  static const routeName = "subscription-page";

  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>
    with WidgetsBindingObserver {
  final ScrollController _listViewController = ScrollController();
  int selectedIdx = 0;
  List<SubscriptionPriceModel> subscriptionList = [
    SubscriptionPriceModel(
        title: LocalizationManager().translate('popular'),
        duration: LocalizationManager().translate('weekly'),
        price: '\$7.99'),
    SubscriptionPriceModel(
        title: LocalizationManager().translate('dayFreeTrail'),
        duration: LocalizationManager().translate('monthly'),
        price: '\$14.99'),
    // SubscriptionPriceModel(
    //     title: 'Best price', duration: 'Yearly', price: '\$79.99'),
  ];

  List<Map<String, String>> featureList = [
    {
      'title': LocalizationManager().translate('unlimitedQ&A'),
      'image': 'assets/icon/Picture1.png'
    },
    {
      'title': LocalizationManager().translate('poweredByGpt'),
      'image': 'assets/icon/Picture2.png'
    },
    {
      'title':
      LocalizationManager().translate('gainAccessAssistants'),
      'image': 'assets/icon/Picture3.png'
    },
    {
      'title':LocalizationManager().translate('adsFreeExperience'),
      'image': 'assets/icon/Picture4.png'
    },
  ];

  double selectedPrice = 0;

  late String? token;

  late InAppProvider pInApp;

  late ProfileProvider profileProvider;

  void onReturnFromUrl() {
    // Your callback code here
    // print("Welcome back!");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // The user has returned to the app! You can call your callback here.
      onReturnFromUrl();
    }
  }

  @override
  void dispose() {
    pInApp.onDispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    profileProvider.clearModels();

    profileProvider.getSubscriptionPlan();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pInApp = Provider.of<InAppProvider>(context, listen: false);

      pInApp.initIAP();

      await Future.delayed(const Duration(milliseconds: 200));

      token = await AuthHelper.getToken();
      if (token != null && token!.isNotEmpty) {
        profileProvider.getMyPlan().then((value) async {
          try {
            if (value.data["status"].toString() == "200") {
              await setCurrentPlan(profileProvider: profileProvider);
              await Future.delayed(const Duration(milliseconds: 500));

              if (selectedIdx != 0) {
                // _scrollDown(selectedIdx);
              }
            }
          } catch (e) {
            // print(e);
          }
        });
      }
    });
    super.initState();
  }

  Future<void> setCurrentPlan(
      {required ProfileProvider profileProvider}) async {
    var subscriptionPlanList = profileProvider.subscriptionPlanList;
    for (int i = 0; i < subscriptionPlanList.length; i++) {
      if (profileProvider.myPlanModel.planId != null &&
          profileProvider.myPlanModel.planId ==
              subscriptionPlanList[i].id.toString()) {
        selectedIdx = i;
        selectedPrice = double.parse(profileProvider.myPlanModel.amount!);
        // _scrollDown(selectedIdx);
        break;
      }
    }
  }

  void _scrollDown(int index) {
    var subscriptionPlanList = profileProvider.subscriptionPlanList;
    // if(_listViewController.hasClients) {
    final position = subscriptionPlanList.length - 1 == index
        ? MediaQuery.of(context).size.width + 12.0
        : index * 120.0;
    // final position = index * 140.0 ;
    _listViewController.animateTo(
      position,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print("width $width");
    print("width $height");

    Widget buildAppBar() {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16)
            .copyWith(top: 8, bottom: 8),
        child: Row(
          children: [
            const AppBackButton(),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: SvgPicture.asset(
                "assets/icon/brain.svg",
                height: 44.0,
              ),
            ),
            const Spacer(),
            const SizedBox(
              width: 42,
            ),
          ],
        ),
      );
    }

    Widget checkSubscribed(
        {required String? myPlanId,
        required SubscriptionPlanModel subscription,
        required bool selected}) {
      if (myPlanId != null && int.parse(myPlanId) == subscription.id) {
        return Container(
          decoration: BoxDecoration(
            color: selected ? Colors.white : AppConstants.secondaryColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Text(
            LocalizationManager().translate('subscribed'),
            style: TextStyle(
              fontSize: 22,
              color: selected ? Colors.black : Colors.white,
            ),
          ),
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visibility(
            //   visible: subscription.productId == "weekly_subscription",
            //   child: const Text(
            //     "\$8.00",
            //     style: TextStyle(
            //       fontSize: 18,
            //       decoration: TextDecoration.lineThrough,
            //     ),
            //   ),
            // ),

          Text(
                  "SAR ${subscription.price!}",
                  style: const TextStyle(
                      fontSize: 18,
                  ),
                ),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: "${subscription.price!}\$",
            //         style: const TextStyle(
            //             fontSize: 18,
            //         ),
            //       ),
            //       TextSpan(
            //         text: subscription.time,
            //         style: const TextStyle(fontSize: 18),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        );
      }
    }

    Widget selectedCard(
        {required SubscriptionPlanModel subscription, String? myPlanId}) {
      return Container(
        // width: width * .5,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: height > 750 ? 12 : 5,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppConstants.secondaryColor.withOpacity(0.5),
            border: Border.all(color: AppConstants.secondaryColor, width: 1.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         subscription.title!,
            //         style: const TextStyle(color: Colors.white, fontSize: 18),
            //       ),
            //       // const SizedBox(
            //       //   height: 5.0,
            //       // ),
            //       // Text(
            //       //   subscription.description!,
            //       //   style: const TextStyle(
            //       //       fontSize: 16.0,
            //       //       color: Colors.white,
            //       //       fontWeight: FontWeight.bold),
            //       // ),
            //     ],
            //   ),
            // ),
            // const SizedBox(width: 5.0,),
            // Text(
            //   subscription.title!,
            //   style: const TextStyle(color: Colors.white, fontSize: 18),
            // ),
            Text(
              subscription.time!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            checkSubscribed(
              myPlanId: myPlanId,
              subscription: subscription,
              selected: true,
            ),
          ],
        ),
      );
    }

    Widget unSelectedCard(
        {required SubscriptionPlanModel subscription,
        required String? myPlanId}) {
      return Container(
        // width: width * .5,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: height > 750 ? 12 :5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppConstants.secondaryColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       subscription.title!,
            //       style: const TextStyle(color: Colors.white, fontSize: 18),
            //     ),
            //     // const SizedBox(
            //     //   height: 5.0,
            //     // ),
            //     // Text(
            //     //   subscription.description!,
            //     //   style: const TextStyle(
            //     //       fontSize: 16.0,
            //     //       color: Colors.white,
            //     //       fontWeight: FontWeight.bold),
            //     // ),
            //   ],
            // ),
            // Text(
            //   subscription.title!,
            //   style: const TextStyle(color: Colors.white, fontSize: 18),
            // ),
            Text(
              subscription.time!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            // const SizedBox(width: 8.0,),
            checkSubscribed(
              myPlanId: myPlanId,
              subscription: subscription,
              selected: false,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Opacity(
        //   opacity: 1,
        //   child: SvgPicture.asset(
        //     "assets/subscription_background.svg",
        //     height: double.infinity,
        //     width: double.infinity,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        const SizedBox(
          height: double.infinity, width: double.infinity,
          // color: Colors.black.withOpacity(.5),
        ),
        Scaffold(
          // bottomNavigationBar: ,
          //  backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                buildAppBar(),
                Expanded(
                  child: Consumer<ProfileProvider>(
                    builder: (context, pProfile, child) {
                      return pProfile.loadingStatus != AppLoadingStatus.loading
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [

                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10.0, sigmaY: 10.0),
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xff7c9774)
                                                      .withOpacity(.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                children: [
                                                  const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'نابغ',
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                          )
                                                      ),
                                                      Text(
                                                        ' | Premium',
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    LocalizationManager()
                                                        .translate(
                                                            'atFullPower'),
                                                    style: const TextStyle(
                                                        fontSize: 16,),
                                                  ),
                                                  const SizedBox(
                                                    height: 12.0,
                                                  ),
                                                  Text(
                                                    LocalizationManager()
                                                        .translate(
                                                            'accessAllFeature'),
                                                    style: const TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height > 750 ? 26 : 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        ...featureList
                                            .map((feature) => Row(
                                                  children: [
                                                    Image.asset(
                                                      feature['image'].toString(),
                                                      width: 30.0,
                                                      height: 30.0,
                                                      // fit: BoxFit.,
                                                    ),
                                                    const SizedBox(
                                                      width: 14,
                                                    ),
                                                    Text(
                                                      feature['title'].toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                        textDirection: TextDirection.ltr
                                                    )
                                                  ],
                                                ))
                                            .toList()
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height > 750 ? 28 : 8,
                                  ),
                                  // Text(
                                  //   LocalizationManager()
                                  //       .translate('selectYourPlan'),
                                  //   style: const TextStyle(
                                  //     fontSize: 22,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 12,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: SizedBox(
                                      // height: height * .25,
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        controller: _listViewController,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: pProfile
                                            .subscriptionPlanList.length,
                                        itemBuilder: (context, index) {
                                          int currIdx = pProfile
                                              .subscriptionPlanList
                                              .indexOf(pProfile
                                                  .subscriptionPlanList[index]);
                                          return InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              setState(() {
                                                if (selectedIdx != currIdx) {
                                                  selectedIdx = currIdx;
                                                  // _scrollDown(selectedIdx);
                                                }
                                              });
                                            },
                                            child: currIdx == selectedIdx
                                                ? selectedCard(
                                                    subscription: pProfile
                                                            .subscriptionPlanList[
                                                        index],
                                                    myPlanId: pProfile
                                                        .myPlanModel.planId,
                                                  )
                                                : unSelectedCard(
                                                    subscription: pProfile
                                                            .subscriptionPlanList[
                                                        index],
                                                    myPlanId: pProfile
                                                        .myPlanModel.planId,
                                                  ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 20.0,
                                  //   ),
                                  //   child: Column(
                                  //     children: [
                                  //       const SizedBox(
                                  //         height: 40.0,
                                  //       ),
                                  //       //GPT 3.5
                                  //       Container(
                                  //         width: double.infinity,
                                  //         padding: const EdgeInsets.symmetric(
                                  //           horizontal: 22.0,
                                  //           vertical: 18.0,
                                  //         ),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(20.0),
                                  //           color: Colors.grey.shade800,
                                  //         ),
                                  //         child: Column(
                                  //           children: [
                                  //             Container(
                                  //               width: double.infinity,
                                  //               decoration: BoxDecoration(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         20.0),
                                  //                 color: AppConstants
                                  //                     .secondaryColor,
                                  //               ),
                                  //               alignment:
                                  //                   AlignmentDirectional.center,
                                  //               padding:
                                  //                   const EdgeInsets.symmetric(
                                  //                 horizontal: 18.0,
                                  //                 vertical: 14.0,
                                  //               ),
                                  //               child: Text(
                                  //                 LocalizationManager()
                                  //                     .onlyEnglish(
                                  //                         'chatGpt3.5'),
                                  //                 style: const TextStyle(
                                  //                   fontWeight: FontWeight.w500,
                                  //                   fontSize: 18.0,
                                  //                   color: Colors.black,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             const SizedBox(
                                  //               height: 10.0,
                                  //             ),
                                  //             Text(
                                  //               LocalizationManager()
                                  //                   .translate('chatGpt3.5txt'),
                                  //               style: const TextStyle(
                                  //                 fontWeight: FontWeight.w500,
                                  //                 fontSize: 13.0,
                                  //                 color: Colors.white,
                                  //               ),
                                  //               textAlign: TextAlign.center,
                                  //             ),
                                  //             const SizedBox(
                                  //               height: 18.0,
                                  //             ),
                                  //             Row(
                                  //               children: [
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .center,
                                  //                     children: [
                                  //                       CircularProgressIndicator(
                                  //                         color: AppConstants
                                  //                             .secondaryColor,
                                  //                         backgroundColor:
                                  //                             Colors.grey
                                  //                                 .shade700,
                                  //                         value: 50 / 100,
                                  //                         strokeWidth:
                                  //                             7, // Adjust the thickness of the progress indicator
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 10),
                                  //                       Text(
                                  //                         LocalizationManager()
                                  //                             .translate(
                                  //                                 'conciseness'),
                                  //                         style:
                                  //                             const TextStyle(
                                  //                           fontSize: 13,
                                  //                           fontWeight:
                                  //                               FontWeight.bold,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .center,
                                  //                     children: [
                                  //                       CircularProgressIndicator(
                                  //                         color: AppConstants
                                  //                             .secondaryColor,
                                  //                         backgroundColor:
                                  //                             Colors.grey
                                  //                                 .shade700,
                                  //                         value: 40 / 100,
                                  //                         strokeWidth:
                                  //                             7, // Adjust the thickness of the progress indicator
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 10),
                                  //                       Text(
                                  //                         LocalizationManager()
                                  //                             .translate(
                                  //                                 'speed'),
                                  //                         style:
                                  //                             const TextStyle(
                                  //                           fontSize: 13,
                                  //                           fontWeight:
                                  //                               FontWeight.bold,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .center,
                                  //                     children: [
                                  //                       CircularProgressIndicator(
                                  //                         color: AppConstants
                                  //                             .secondaryColor,
                                  //                         backgroundColor:
                                  //                             Colors.grey
                                  //                                 .shade700,
                                  //                         value: 65 / 100,
                                  //                         strokeWidth:
                                  //                             7, // Adjust the thickness of the progress indicator
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 10),
                                  //                       Text(
                                  //                         LocalizationManager()
                                  //                             .translate(
                                  //                                 'reasoning'),
                                  //                         style:
                                  //                             const TextStyle(
                                  //                           fontSize: 13,
                                  //                           fontWeight:
                                  //                               FontWeight.bold,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         height: 30.0,
                                  //       ),
                                  //       //GPT 4
                                  //       Container(
                                  //         width: double.infinity,
                                  //         padding: const EdgeInsets.symmetric(
                                  //           horizontal: 22.0,
                                  //           vertical: 20.0,
                                  //         ),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(20.0),
                                  //           color: Colors.grey.shade800,
                                  //         ),
                                  //         child: Column(
                                  //           children: [
                                  //             Container(
                                  //               width: double.infinity,
                                  //               decoration: BoxDecoration(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         20.0),
                                  //                 color: AppConstants
                                  //                     .secondaryColor,
                                  //               ),
                                  //               alignment:
                                  //                   AlignmentDirectional.center,
                                  //               padding:
                                  //                   const EdgeInsets.symmetric(
                                  //                 horizontal: 18.0,
                                  //                 vertical: 10.0,
                                  //               ),
                                  //               child: Row(
                                  //                 children: [
                                  //                   if (pProfile.myPlanModel
                                  //                           .planId ==
                                  //                       null)
                                  //                     const SizedBox(
                                  //                       width: 30.0,
                                  //                       height: 24.0,
                                  //                     ),
                                  //                   Expanded(
                                  //                     child: Text(
                                  //                       LocalizationManager()
                                  //                           .onlyEnglish(
                                  //                               'gPT4'),
                                  //                       style: const TextStyle(
                                  //                         fontWeight:
                                  //                             FontWeight.w500,
                                  //                         fontSize: 18.0,
                                  //                         color: Colors.black,
                                  //                       ),
                                  //                       textAlign:
                                  //                           TextAlign.center,
                                  //                     ),
                                  //                   ),
                                  //                   if (pProfile.myPlanModel
                                  //                           .planId ==
                                  //                       null)
                                  //                     Container(
                                  //                       decoration:
                                  //                           const BoxDecoration(
                                  //                         shape:
                                  //                             BoxShape.circle,
                                  //                         color: Colors.black,
                                  //                       ),
                                  //                       padding:
                                  //                           const EdgeInsets
                                  //                               .all(6.0),
                                  //                       child: Image.asset(
                                  //                         "assets/icon/crown.png",
                                  //                         width: 20.0,
                                  //                         height: 20.0,
                                  //                       ),
                                  //                     ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             const SizedBox(
                                  //               height: 12.0,
                                  //             ),
                                  //             Text(
                                  //               LocalizationManager()
                                  //                   .translate('gPT4Txt'),
                                  //               style: const TextStyle(
                                  //                 fontWeight: FontWeight.w500,
                                  //                 fontSize: 13.0,
                                  //                 color: Colors.white,
                                  //               ),
                                  //               textAlign: TextAlign.center,
                                  //             ),
                                  //             const SizedBox(
                                  //               height: 18.0,
                                  //             ),
                                  //             Row(
                                  //               children: [
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .center,
                                  //                     children: [
                                  //                       CircularProgressIndicator(
                                  //                         color: AppConstants
                                  //                             .secondaryColor,
                                  //                         backgroundColor:
                                  //                             Colors.grey
                                  //                                 .shade700,
                                  //                         value: 85 / 100,
                                  //                         strokeWidth:
                                  //                             7, // Adjust the thickness of the progress indicator
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 10),
                                  //                       Text(
                                  //                         LocalizationManager()
                                  //                             .translate(
                                  //                                 'conciseness'),
                                  //                         style:
                                  //                             const TextStyle(
                                  //                           fontSize: 13,
                                  //                           fontWeight:
                                  //                               FontWeight.bold,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .center,
                                  //                     children: [
                                  //                       CircularProgressIndicator(
                                  //                         color: AppConstants
                                  //                             .secondaryColor,
                                  //                         backgroundColor:
                                  //                             Colors.grey
                                  //                                 .shade700,
                                  //                         value: 100 / 100,
                                  //                         strokeWidth:
                                  //                             7, // Adjust the thickness of the progress indicator
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 10),
                                  //                       Text(
                                  //                         LocalizationManager()
                                  //                             .translate(
                                  //                                 'speed'),
                                  //                         style:
                                  //                             const TextStyle(
                                  //                           fontSize: 13,
                                  //                           fontWeight:
                                  //                               FontWeight.bold,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .center,
                                  //                     children: [
                                  //                       CircularProgressIndicator(
                                  //                         color: AppConstants
                                  //                             .secondaryColor,
                                  //                         backgroundColor:
                                  //                             Colors.grey
                                  //                                 .shade700,
                                  //                         value: 100 / 100,
                                  //                         strokeWidth:
                                  //                             7, // Adjust the thickness of the progress indicator
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 10),
                                  //                       Text(
                                  //                         LocalizationManager()
                                  //                             .translate(
                                  //                                 'reasoning'),
                                  //                         style:
                                  //                             const TextStyle(
                                  //                           fontSize: 13,
                                  //                           fontWeight:
                                  //                               FontWeight.bold,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         height: 40.0,
                                  //       ),
                                  //       Row(
                                  //         children: [
                                  //           const Icon(Icons.info_outlined),
                                  //           const SizedBox(
                                  //             width: 8.0,
                                  //           ),
                                  //           Flexible(
                                  //             child: RichText(
                                  //               text: TextSpan(children: [
                                  //                 TextSpan(
                                  //                   text: LocalizationManager()
                                  //                       .translate('caution'),
                                  //                   style: const TextStyle(
                                  //                     fontWeight:
                                  //                         FontWeight.w600,
                                  //                     fontSize: 13.0,
                                  //                   ),
                                  //                 ),
                                  //                 TextSpan(
                                  //                   text: LocalizationManager()
                                  //                       .translate(
                                  //                           'cautionTxt'),
                                  //                   style: const TextStyle(
                                  //                     fontWeight:
                                  //                         FontWeight.w400,
                                  //                     fontSize: 12.0,
                                  //                   ),
                                  //                 )
                                  //               ]),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: height > 750 ? 28 : 12,
                                  ),
                                  Consumer2<ProfileProvider, SubscriptionProvider>(
                                    builder: (context, pProfile, pSubscription, child) {
                                      if (pProfile.loadingStatus != AppLoadingStatus.loading &&
                                          pProfile.subscriptionPlanList.isNotEmpty) {
                                        int currId = pProfile.subscriptionPlanList[selectedIdx].id!;
                                        String currPrice =
                                        pProfile.subscriptionPlanList[selectedIdx].price!;

                                        // compare the prices to display the upgrade button
                                        if (double.parse(currPrice) < selectedPrice) {
                                          return const SizedBox();
                                        } else {
                                          // compare card Id and buy plan Id to display the cancel plan button
                                          if (pProfile.myPlanModel.planId == currId.toString()) {
                                            // this button for cancel plan
                                            return InkWell(
                                              onTap: () async {
                                                HapticFeedback.lightImpact();
                                                showGeneralDialog(
                                                  context: context,
                                                  transitionBuilder: (dContext, a1, a2, _) {
                                                    return Transform.scale(
                                                      scale: a1.value,
                                                      child: PlanCancelConfirmationDialog(
                                                        onYes: () {
                                                          HapticFeedback.lightImpact();
                                                          Navigator.pop(dContext);
                                                          var pInApp = Provider.of<InAppProvider>(
                                                            context,
                                                            listen: false,
                                                          );

                                                          pInApp.cancelPlan(
                                                            buildContext: context,
                                                            productId: pProfile
                                                                .subscriptionPlanList[selectedIdx]
                                                                .productId ??
                                                                "",
                                                            paymentMethod:
                                                            pProfile.myPlanModel.paymentMethod ??
                                                                "",
                                                          );
                                                          // pSubscription.cancelPlan(context: context);
                                                        },
                                                        onNo: () {
                                                          HapticFeedback.lightImpact();
                                                          Navigator.pop(dContext);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  pageBuilder: (context, a1, a2) => const SizedBox(),
                                                );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 18)
                                                    .copyWith(bottom: 16, top: 8),
                                                width: double.infinity,
                                                height: 50,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(24)),
                                                  color: Colors.white,
                                                ),
                                                child: pSubscription.loadingStatus ==
                                                    AppLoadingStatus.loading
                                                    ? const CircularProgressIndicator(
                                                  color: Colors.black,
                                                )
                                                    : Text(
                                                  LocalizationManager().translate('cancelPlan'),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            // this button for the buy plan
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    HapticFeedback.lightImpact();
                                                    if (token != null && token!.isNotEmpty) {
                                                      // Map<String, dynamic> postBody = {
                                                      //   "plan_id":
                                                      //       pProfile.subscriptionPlanList[selectedIdx].id,
                                                      //   "trial": "",
                                                      // };

                                                      if (pSubscription.loadingStatus !=
                                                          AppLoadingStatus.loading) {
                                                        /*pSubscription
                                    .buyPlan(context: context, postBody: postBody)
                                    .then((response) {
                                  if (response.data["status"].toString() == "200") {
                                    var pChat = Provider.of<ChatProvider>(context, listen: false);

                                    if (mounted) {
                                      pChat.userAttempt(context: context);
                                    }

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      barrierColor: Colors.black.withOpacity(.8),
                                      builder: (builder) {
                                        return const SubsciptionScuccesModal();
                                      },
                                    );
                                  }
                                });*/

                                                        var pInApp = Provider.of<InAppProvider>(context,
                                                            listen: false);
                                                        // pInApp.buyPlan('monthly_subscription');
                                                        pInApp.buyPlan(
                                                            productId: pProfile
                                                                .subscriptionPlanList[selectedIdx]
                                                                .productId ??
                                                                "",
                                                            selectedIdx: selectedIdx);
                                                        // print("sam ${pInApp.productsDetails.length}");

                                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => InAppTest(),));
                                                      }
                                                    } else {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext _) => const LoginModal(),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 18)
                                                        .copyWith(bottom: 16, top: 8),
                                                    width: double.infinity,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    decoration: const BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(24)),
                                                      color: Colors.white,
                                                    ),
                                                    child: pSubscription.loadingStatus ==
                                                        AppLoadingStatus.loading
                                                        ? const CircularProgressIndicator(
                                                      color: Colors.black,
                                                    )
                                                        : Text(
                                                      LocalizationManager()
                                                          .translate('tryFreeSubscribe'),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 14.0, right: 14.0, bottom: 22.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          launchUrl(Uri.parse(AppKey.termsCondition),
                                                              mode: LaunchMode.externalApplication);
                                                        },
                                                        child: Text(
                                                          LocalizationManager().translate('termsOfUse'),
                                                          style: const TextStyle(
                                                              color: Color(0xffe8e8e8),
                                                              fontSize: 15.5,
                                                              decoration: TextDecoration.underline),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          launchUrl(Uri.parse(AppKey.privacyPolicyUrl),
                                                              mode: LaunchMode.externalApplication);
                                                        },
                                                        child: Text(
                                                          LocalizationManager()
                                                              .translate('privacyPolicy'),
                                                          style: const TextStyle(
                                                              color: Color(0xffe8e8e8),
                                                              fontSize: 15.5,
                                                              decoration: TextDecoration.underline),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                      }
                                      return const SizedBox();
                                    },
                                  )
                                ],
                              ),
                            )
                          : const ProgressPage();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SubscriptionPriceModel {
  final String title;
  final String duration;
  final String price;

  SubscriptionPriceModel(
      {required this.title, required this.duration, required this.price});
}

class PlanCancelConfirmationDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const PlanCancelConfirmationDialog(
      {super.key, required this.onYes, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 16.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 32.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                // "dummy Cancel Plan",
                LocalizationManager().translate('warning'),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                // "Dummy text",
                LocalizationManager().translate('cancelPlanText'),
                style: const TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 40,
                // width: 150,
                child: AppSmallButton(
                  title: Text(
                    LocalizationManager().translate('continue'),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: onYes,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: onNo,
                child: Text(
                  LocalizationManager().translate("noThanks"),
                  style: const TextStyle(
                    // fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
