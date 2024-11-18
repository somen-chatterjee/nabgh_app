import 'package:flutter/cupertino.dart';

class ScanDataProvider extends ChangeNotifier{
  String? _scanText;

  String? get scanText => _scanText;

  setScanData(String scanData){
    _scanText = null;

    _scanText = scanData;
    notifyListeners();
  }

  clearData(){
    _scanText = null;
  }

}