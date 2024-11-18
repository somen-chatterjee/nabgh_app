import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nabgh_app/helper/sp_helper.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

String fcmToken = '';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<void> getFcmToken() async {
  try {
    fcmToken = await FirebaseMessaging.instance.getToken() ?? "FcmToken";
    // print('FireBase FCM token=> $fcmToken -----------------\n\n\n\n\n\n');
  } catch (e) {
    if (kDebugMode) {
      print("FireBase FCM toke exception====> $e");
    }
  }

  await SpHelper.saveString(SpKey.FCMtoken, fcmToken);
}

void initMessaging() async {
  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@drawable/ic_launcher_notification');
  var initializationSettingIos = const DarwinInitializationSettings(
    requestBadgePermission:true,
    requestSoundPermission:  true,

  );

  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid,
      iOS:  initializationSettingIos
  );


  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await _firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
    String notificationTitle = remoteMessage.notification!.title.toString();
    String notificationBody = remoteMessage.notification!.body.toString();

    showNotification(notificationTitle, notificationBody);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // FlutterAppBadger.removeBadge();
    // if (spUtil?.getString(Preferences.user_token) != "") {
    //   apiHandler?.userProfile();
    // }
    //  if (message.notification != null) {

    //  }
    if (kDebugMode) {
      print("A new onMessageOpenedApp event was published!");
    }
    // Map<String,dynamic> notificationData = message.data;
    // final notificationType = json.decode(message.data["notification_type"]);
    final data = json.decode(message.data["data"]);

    sleep(const Duration(milliseconds: 500));
    // eventBus?.fire([notificationType, data]);
    if (kDebugMode) {
      print(data);
    }
    // handleClick(notificationData);
  });
  return null;
}

void showNotification(String title, String body) async {
  var androidChannel = const AndroidNotificationChannel(
    'pushnotificationapp',
    'pushnotificationapp',
    description: 'Channel Description',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  var notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      androidChannel.id,
      androidChannel.name,
      channelDescription: androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
    payload: 'payload',
  );
}

// handleClick(Map<String,dynamic> data) async {
//
//   String token = getValue(LocalStorage.TOKEN);
//   if(token == ""){
//
//     Get.offAll(()=> LoginScreen());
//     return;
//   }
//
//   if (data["type"] == "chat") {
//     Get.offAllNamed(AppRoutes.bottomNavbar);
//     Future.delayed(Duration(seconds: 1),(){
//       Get.find<BottomBarController>().selectedIndex = 2;
//       Get.find<BottomBarController>().update();
//     });
//   }else if (data['type'] == 'shipment') {
//     Get.find<RequestController>().tabController.index = 1;
//     Get.find<RequestController>().update();
//     Get.to(ShipmentRequestRecvice());
//     // pushAndRemoveUntil(Get.context, screen: const AllActivityScreen(index: 1,));
//   }else if (data['type'] == 'trip') {
//     Get.find<RequestController>().tabController.index = 1;
//     Get.find<RequestController>().update();
//     // log('Get.put(RequestController()).selectedTabIndex:::${Get.put(RequestController()).selectedTabIndex}');
//     Get.to(TripRequest());
//     // pushAndRemoveUntil(Get.context, screen: const AllActivityScreen(index: 0,));
//   }
//   // else if (data['type'] == 'giftReceivedMozaik' || data['type'] ==  "convertTicket") {
//   //   // pushAndRemoveUntil(Get.context, screen: const CashOutTransactionsScreen(index: 1,));
//   // }else if (data['type'] == 'competeUpload') {
//   //   // pushAndRemoveUntil(Get.context, screen: const VMBottomBar());
//   // }
//   // else{
//   //   Get.off
//   //   // pushAndRemoveUntil(Get.context, screen: const AllActivityScreen());
//   // }
//
// }



























// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:get/get_connect/http/src/utils/utils.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// void initMessaging() async {
//   var initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/launcher_icon');
//   var initialzationSettingIos = DarwinInitializationSettings(
//     requestBadgePermission:true,
//     requestSoundPermission:  true,

//   );

//   var initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid,
//       iOS:  initialzationSettingIos
//       );


//   flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
//     String notificationTitle = remoteMessage.notification!.title.toString();
//     String notificationBody = remoteMessage.notification!.body.toString();

//     showNotification(notificationTitle, notificationBody);
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     // FlutterAppBadger.removeBadge();
//     // if (spUtil?.getString(Preferences.user_token) != "") {
//     //   apiHandler?.userProfile();
//     // }
//     print("A new onMessageOpenedApp event was published!");
//     final notificationType = json.decode(message.data["notification_type"]);
//     final data = json.decode(message.data["data"]);
//     sleep(Duration(milliseconds: 500));
//     // eventBus?.fire([notificationType, data]);
//     print(data);
//   });
//   return null;
// }

// void showNotification(String title, String body) async {
//   var androidChannel = AndroidNotificationChannel(
//     'firebase-push-notification',
//     'firebase-push-notification-channel',
//     description: 'Channel Description',
//     importance: Importance.high,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(androidChannel);

//   var notificationDetails = NotificationDetails(
//     android: AndroidNotificationDetails(
//       androidChannel.id,
//       androidChannel.name,
//       channelDescription: androidChannel.description,
//       importance: Importance.high,
//       priority: Priority.high,
//     ),
//   );

//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     body,
//     notificationDetails,
//     payload: 'payload',
//   );
// }
