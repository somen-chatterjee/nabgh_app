import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class CheckInternet extends ChangeNotifier {
  bool status = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _streamSubscription;

  Future<bool> checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.mobile) {
      status = true;
      notifyListeners();
    } else if (connectionResult == ConnectivityResult.wifi) {
      status = true;
      notifyListeners();
    } else {
      print("connectionResult $connectionResult");

      status = false;
      notifyListeners();
    }

    return status;
  }





  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isOnline = true; // Initially assuming internet is available

  CheckInternet() {
    // Subscribe to the connectivity changes
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    });

    // Check the initial connectivity state
    _checkConnectivity();
  }

  bool get isOnline => _isOnline;

  // Check connectivity status
  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _isOnline = connectivityResult != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the connectivity subscription when the provider is disposed
    super.dispose();
  }
}