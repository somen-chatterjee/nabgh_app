import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nabgh_app/change_language/language_helper.dart';

class AppConstants {
  static const Color primaryColor = Color(0xffDEFA8E);
  static const Color secondaryColor = Color(0xff06CFF1);
  // static const Color tutorialBgColor = Color(0x334d4dff);
  static const Color tutorialBgColor = Color(0x4d4dff);
  static LinearGradient gradient = const LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      primaryColor,
      secondaryColor,
    ],
  );

  static getToast({required String message}) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  static String getFormattedDate(inputDateString) {
    var lanCode = LocalizationManager().locale.languageCode;

    if (lanCode == 'ar') {
      Intl.defaultLocale = 'ar'; // Set the default locale to Arabic

      String inputDateString = "2024-01-11T10:00:43.000000Z";
      DateTime dateTime = DateTime.parse(inputDateString);

      // No need to specify the locale here, as the default locale is already set to Arabic
      String formattedDate = DateFormat('d-MMM-yyyy, h:mm a').format(dateTime);

      // print(formattedDate); // Output: 11-يناير-2024, 10:00 صباحًا
      return formattedDate;
    } else {
      DateTime dateTime = DateTime.parse(inputDateString);
      String formattedDate = DateFormat('d-MMM-yyyy, h:mm a').format(dateTime);

      // print(formattedDate); // Output: 11-Jan-2024, 10:00 AM
      return formattedDate;
    }
  }


  static String getUniqueId(){
    DateTime dateTime = DateTime.now(); // Replace this with your specific DateTime

    // Format the date and time
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    // Remove separators to get the desired format
    String result = formattedDateTime.replaceAll(RegExp(r'[- :]', multiLine: true), '');

    // print(result); // Output: 20240118175728
    return result;
  }
}
