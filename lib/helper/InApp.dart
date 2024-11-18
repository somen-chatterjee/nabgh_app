import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/pages/main_screen/subscription_page/subscription_success_modal.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:nabgh_app/provider/profile_provider.dart';
import 'package:nabgh_app/provider/subscription_provider.dart';
import 'package:nabgh_app/router.dart';
import 'package:nabgh_app/widget/app_loadig_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/app_small_button.dart';

class InAppProvider with ChangeNotifier {
  int productIndex = 0;

  final List<String> _kProductIds = <String>[
    // _kConsumableId,
    // _kUpgradeId,
    // _kSilverSubscriptionId,
    // _kGoldSubscriptionId,

    'weekly_subscription',
    'monthly_1m',
    'yearly_1y',
  ];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  List<ProductDetails> get productsDetails => _products;

  final List<ProductDetails> _queryProduct = <ProductDetails>[];

  List<ProductDetails> get queryProduct => _queryProduct;

  void initIAP() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      if (kDebugMode) {
        print('somen ${purchaseDetailsList.length}');
      }
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
      if (kDebugMode) {
        print("sdlsf");
      }
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = isAvailable;
      _products = <ProductDetails>[];
      _purchases = <PurchaseDetails>[];
      _notFoundIds = <String>[];
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (kDebugMode) {
      print(
        'productDetailsResponse ${productDetailResponse.productDetails.length}');
    }
    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _queryProductError = null;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }

    // final List<String> consumables = await ConsumableStore.load();

    _isAvailable = isAvailable;
    _products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    // _consumables = consumables;
    _purchasePending = false;
    _loading = false;
    notifyListeners();
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      log("purchaseDetails $purchaseDetails");

      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (kDebugMode) {
          print('purchaseDetails.status => ${purchaseDetails.status}');
        }
        if (purchaseDetails.status == PurchaseStatus.error ||
            purchaseDetails.status == PurchaseStatus.canceled) {
          if (kDebugMode) {
            print('handleError');
          }
          handleError();
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            // log("purchaseDetails ${jsonEncode(purchaseDetails)}");

            var data = {
              "productId": purchaseDetails.productID,
              "transactionId": purchaseDetails.purchaseID,
              "transactionDate": purchaseDetails.transactionDate,
              "status": purchaseDetails.status.name,
              "pendingCompletePurchase": purchaseDetails.pendingCompletePurchase,
              "verificationData": {
                'localVerificationData': purchaseDetails.verificationData.localVerificationData,
                'source': purchaseDetails.verificationData.source,
                'serverVerificationData': purchaseDetails.verificationData.serverVerificationData,
              }
            };

            log("purchaseDetails ${jsonEncode(data)}");
            // log("purchaseDetails ${purchaseDetails.status}");
            // log("purchaseDetails ${purchaseDetails.productID}");
            // log("purchaseDetails ${purchaseDetails.}");
            // log("purchaseDetails ${purchaseDetails.verificationData}");
            String? transactionIdentifier;

            if(Platform.isIOS) {
              final transactions = await SKPaymentQueueWrapper().transactions();
              transactions.forEach((transaction) async {
                if(transaction.originalTransaction?.transactionIdentifier != null) {
                  transactionIdentifier =
                      transaction.originalTransaction?.transactionIdentifier;
                }
              });
            }

            // unawaited(deliverProduct(purchaseDetails));
            // call the backend api
            unawaited(subscribeProduct(productIndex: productIndex, purchaseDetails: purchaseDetails, transactionIdentifier: transactionIdentifier));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          // if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          //   final InAppPurchaseAndroidPlatformAddition androidAddition =
          //   _inAppPurchase.getPlatformAddition<
          //       InAppPurchaseAndroidPlatformAddition>();
          //   await androidAddition.consumePurchase(purchaseDetails);
          // }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    // if (purchaseDetails.productID == _kConsumableId) {
    //   // await ConsumableStore.save(purchaseDetails.purchaseID!);
    //   // final List<String> consumables = await ConsumableStore.load();
    //   setState(() {
    //     _purchasePending = false;
    //     // _consumables = consumables;
    //   });
    // } else {
    //   setState(() {
    //     _purchases.add(purchaseDetails);
    //     _purchasePending = false;
    //   });
    // }
  }

  Future<void> subscribeProduct({required int productIndex, required PurchaseDetails purchaseDetails, String? transactionIdentifier}) async {
    navigatorKey.currentState!.pop();
    BuildContext buildContext = navigatorKey.currentContext!;

    var pProfile = Provider.of<ProfileProvider>(buildContext, listen: false);
    var pSubscription =
        Provider.of<SubscriptionProvider>(buildContext, listen: false);
    var pChat = Provider.of<ChatProvider>(buildContext, listen: false);

    Map<String, dynamic> postBody = {
      "plan_id": pProfile.subscriptionPlanList[productIndex].id,
      "trial": "",
      "orderId": purchaseDetails.purchaseID,
      "status": purchaseDetails.status.name,
      "transaction_date": purchaseDetails.transactionDate,
      "transition_id": purchaseDetails.purchaseID,
      "product_id": purchaseDetails.productID,
      "paymentMethod": Platform.isAndroid ? 'android' : 'ios',
      "amount": pProfile.subscriptionPlanList[productIndex].price,
      "ios_customer_id": transactionIdentifier ?? "",
      "all_responce": purchaseDetails.verificationData.localVerificationData,
      "purchase_token": Platform.isAndroid ? purchaseDetails.verificationData.serverVerificationData : ""
    };

    pSubscription
        .buyPlan(context: buildContext, postBody: postBody)
        .then((response) {
          log("Somen ${response.data}");
      if (response.data["status"].toString() == "200") {
        if (buildContext.mounted) {
          pChat.userAttempt(context: buildContext);
        }

        showDialog(
          context: buildContext,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(.8),
          builder: (builder) {
            return const SubsciptionScuccesModal();
          },
        );
      }
    });
  }

  void showPendingUI() {
    _purchasePending = true;
    notifyListeners();
  }

  void handleError() {
    _purchasePending = false;
    navigatorKey.currentState!.pop();
    notifyListeners();
  }

  Future<List<ProductDetails>> getProductList(Set<String> productId) async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(productId);
    if (response.notFoundIDs.isNotEmpty) {
      throw "product Id not found";
    }
    List<ProductDetails> products = response.productDetails;
    if (kDebugMode) {
      print('get product list :- ${products[0].title}');
    }

    _queryProduct.addAll(products);
    return products;
  }

  void buyPlan({required String productId, required int selectedIdx}) async {
    showDialog(context: navigatorKey.currentState!.context, builder: (builder) => AppLoadingIndicator());
    if (kDebugMode) {
      print("somen index $selectedIdx");
    }
    productIndex = selectedIdx;
    if (_products.isNotEmpty) {
      try {
        bool planNotFound = true;
        _products.map((productDetails) {
          if (productDetails.id == productId) {
            planNotFound = false;
            // print("somen ${productId}");
            if (kDebugMode) {
              print("somen  ${productDetails.id}");
              print("somen ${productDetails.price}");
              print("somen ${productDetails.title}");
            }
            // print("somen ${productDetails.id}");
            _inAppPurchase.buyNonConsumable(
              purchaseParam: PurchaseParam(
                productDetails: productDetails,
              ),
            );
          }
        }).toList();

        if(planNotFound){
          AppConstants.getToast(
            message:
            LocalizationManager().translate('noPlanFound'),
          );
        }
      } catch(e){
        log('error $e');
      }
    } else {
      AppConstants.getToast(
          message: LocalizationManager().translate('SomethingWentWrong'));
    }
  }

  void cancelPlan({required BuildContext buildContext, required String productId, required String paymentMethod}) async {
    if (Platform.isAndroid) {
      // cancelSubscription() async {

      if (paymentMethod.isNotEmpty &&
          paymentMethod ==
              "android") {
        String url =
            "https://play.google.com/store/account/subscriptions?sku=$productId&package=com.app.nabgh_app";
        // "https://play.google.com/store/account/subscriptions";
        try {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
              .then((value) {
            Navigator.pop(buildContext);
          });
        } catch (e) {
          AppConstants.getToast(
              message:
              LocalizationManager().translate('notOpenPlayStoreSetting'));
        }
      } else {
        showGeneralDialog(
          context: buildContext,
          transitionBuilder: (dContext, a1, a2, _) {
            return Transform.scale(
              scale: a1.value,
              child: Dialog(
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
                          // "Your subscription was made on an Android device. To cancel, you must use a Android device not an iOS device.",
                          LocalizationManager().translate('madeOnIosDevice'),
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
                            onTap: () {
                              Navigator.pop(buildContext);
                            },
                          ),
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // InkWell(
                        //   onTap: onNo,
                        //   child: Text(
                        //     LocalizationManager().translate("noThanks"),
                        //     style: const TextStyle(
                        //       // fontSize: 25,
                        //       fontWeight: FontWeight.w700,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          pageBuilder: (context, a1, a2) => const SizedBox(),
        );
      }

      // https://play.google.com/store/account/subscriptions?sku=weekly_subscription&package=com.app.nabgh_app
      // try {
      //   if(Get.find<HomeScreenCtrl>().userDetail?.planDetail?.platform == "android") {
      //
      //     if (!await launchUrl(
      //       Uri.parse(
      //           "https://play.google.com/store/account/subscriptions?sku=${Get
      //               .find<HomeScreenCtrl>()
      //               .userDetail?.planDetail?.inAppPlanAndroid ??
      //               ""}&package=com.app.one.one"),
      //       mode: LaunchMode.externalApplication,
      //     )) {
      //       throw 'Could not launch URL';
      //     }
      //     // await Get.find<HomeScreenCtrl>().cancelSubscription(context);
      //   }else{
      //     showGeneralDialog(
      //       context: context,
      //       pageBuilder: (context1, animation, secondaryAnimation) {
      //         return ShowGeneralPopup(
      //           msg: "Your subscription was made on an iOS device. To cancel, you must use a iOS device not an Android device.",
      //           actionWidget: CustomButton(
      //             text: "Confirm",
      //             onPressed: (){
      //               Navigator.pop(context1);
      //             },
      //           ),
      //         );
      //       },
      //     );
      //   }
      // } catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Failed to launch URL'),
      //     ),
      //   );
      // }
    } else {
      try {
        if (paymentMethod.isNotEmpty &&
        paymentMethod ==
            "ios") {

        String url = "https://apps.apple.com/account/subscriptions";

        try {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).then((value) {
            Navigator.pop(buildContext);
          });
        } catch (e) {
          AppConstants.getToast(
              message:
              LocalizationManager().translate('notOpenPlayStoreSetting'));
        }

        // await Get.find<HomeScreenCtrl>().cancelSubscription(context);
        } else {
          showGeneralDialog(
            context: buildContext,
            transitionBuilder: (dContext, a1, a2, _) {
              return Transform.scale(
                scale: a1.value,
                child: Dialog(
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
                            // "Your subscription was made on an Android device. To cancel, you must use a Android device not an iOS device.",
                            LocalizationManager().translate('madeOnAndroidDevice'),
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
                              onTap: () {
                                Navigator.pop(buildContext);
                              },
                            ),
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // InkWell(
                          //   onTap: onNo,
                          //   child: Text(
                          //     LocalizationManager().translate("noThanks"),
                          //     style: const TextStyle(
                          //       // fontSize: 25,
                          //       fontWeight: FontWeight.w700,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            pageBuilder: (context, a1, a2) => const SizedBox(),
          );

          // showGeneralDialog(
          //   context: context,
          //   pageBuilder: (context1, animation, secondaryAnimation) {
          //     return ShowGeneralPopup(
          //       msg:
          //       "Your subscription was made on an Android device. To cancel, you must use a Android device not an iOS device.",
          //       actionWidget: CustomButton(
          //         text: "Confirm",
          //         onPressed: () {
          //           Navigator.pop(context1);
          //         },
          //       ),
          //     );
          //   },
          // );
        }
      } catch (e) {
        if (buildContext.mounted) {
          ScaffoldMessenger.of(buildContext).showSnackBar(
            SnackBar(
              content: Text(
                  LocalizationManager().translate('notOpenAppStoreSetting')),
            ),
          );
        }
      }
    }
  }

  void onDispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();

    _queryProduct.clear();
    _products.clear();
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
