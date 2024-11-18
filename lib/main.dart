// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/helper/InApp.dart';
import 'package:nabgh_app/helper/firebase_service.dart';
import 'package:nabgh_app/pages/splash_screen/rate_us_modal.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nabgh_app/pages/splash_screen/splash_screen.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/provider/chat_history_provider.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:nabgh_app/provider/discover_provider.dart';
import 'package:nabgh_app/provider/profile_provider.dart';
import 'package:nabgh_app/provider/scan_data_provider.dart';
import 'package:nabgh_app/provider/search_provider.dart';
import 'package:nabgh_app/provider/subscription_provider.dart';
import 'package:nabgh_app/provider/tutorial_target_provider.dart';
import 'package:nabgh_app/router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'change_language/language_helper.dart';
import 'helper/check_network.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyB9JpVdXwXBMN0_Q74B0hSnBYn0AjM7rpQ',
            appId: "1:27033124726:android:046bd918b0089a1e098457",
            messagingSenderId: "27033124726",
            projectId: "nabgh-12e3f")
    );
  }else {
    await Firebase.initializeApp();
  }
  getFcmToken();
  initMessaging();

  // Show tracking authorization dialog and ask for permission
  // final status = await AppTrackingTransparency.requestTrackingAuthorization();
  //  MobileAds.instance.initialize();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CheckInternet>(create: (_) => CheckInternet()),
        ChangeNotifierProvider<AuthenticateProvider>(
            create: (_) => AuthenticateProvider()),
        ChangeNotifierProvider<DiscoverProvider>(
            create: (_) => DiscoverProvider()),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ChangeNotifierProvider<ChatHistoryProvider>(
            create: (_) => ChatHistoryProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
        ChangeNotifierProvider<LocalizationManager>(
            create: (_) => LocalizationManager()),
        ChangeNotifierProvider<ScanDataProvider>(
            create: (_) => ScanDataProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
        ChangeNotifierProvider<SubscriptionProvider>(
            create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider<TutorialTargetProvider>(
            create: (_) => TutorialTargetProvider()),
        ChangeNotifierProvider<InAppProvider>(
            create: (_) => InAppProvider()),
      ],
      child: const MyApp(),
    ),
  );
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }

  await Permission.notification.isDenied.then(
        (bool value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus!.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Consumer<LocalizationManager>(
        builder:
            (BuildContext context, LocalizationManager value, Widget? child) {
          return MaterialApp(
            // title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xff111111),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              splashColor: Colors.transparent,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!,
              );
            },
            onGenerateRoute: generateRoute,
            navigatorKey: navigatorKey,
            home: const SplashScreen(),
            localizationsDelegates: const <LocalizationsDelegate<Object>>[
              // ... app-specific localization delegate(s) here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            locale: value.locale,
            supportedLocales: const <Locale>[
              Locale('en', 'US'), // English
              Locale('ar', '') // Arabic
              // ... other locales the app supports
            ],
          );
        },
      ),
    );
  }
}
