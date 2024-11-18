import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nabgh_app/helper/sp_helper.dart';
import 'package:nabgh_app/provider/chat_provider.dart';
import 'package:provider/provider.dart';

import 'auth_helperr.dart';

class AdHelper {

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  int maxFailedLoadAttempts = 3;

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  // create a banner ad

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            // ? 'ca-app-pub-3940256099942544/1033173712' //test key android
            // : 'ca-app-pub-3940256099942544/4411468910', //test key ios
        ? 'ca-app-pub-8833658061362905/9950796610'
        : 'ca-app-pub-8833658061362905/4686027493',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            if (kDebugMode) {
              print('$ad loaded');
            }
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) {
              print('InterstitialAd failed to load: $error.');
            }
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      if (kDebugMode) {
        print('Warning: attempt to show interstitial before loaded.');
      }
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        if (kDebugMode) {
          print('print $ad onAdShowedFullScreenContent.');
        }
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        if (kDebugMode) {
          print('print $ad onAdDismissedFullScreenContent.');
        }
        ad.dispose();
        // _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (kDebugMode) {
          print('print $ad onAdFailedToShowFullScreenContent: $error');
        }
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // dispose the ad
  void adDispose() {
    _interstitialAd?.dispose();
  }

  void showAd({required BuildContext context}) async{

    var pChat = Provider.of<ChatProvider>(context,listen: false);

    await pChat.checkUserAttemptForAd(context: context);

    String? token = await AuthHelper.getToken();

    bool? tutorialShowed = await SpHelper.loadBool(SpKey.tutorialShowed);

    if(tutorialShowed != null && tutorialShowed) {
      if (token == null) {
        _createInterstitialAd();
      } else {
        if (token.isNotEmpty && pChat.adAttemptModel != null) {
          if (pChat.adAttemptModel!.plan != 1) {
            _createInterstitialAd();
          }
        }
      }
    }

  }

}
