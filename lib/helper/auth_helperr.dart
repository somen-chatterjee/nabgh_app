import 'package:nabgh_app/helper/sp_helper.dart';

class AuthHelper {
  static Future<bool> isUserExist() async {
    String? token = await SpHelper.loadString(SpKey.authToken);
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> getToken() async {
    String? token = await SpHelper.loadString(SpKey.authToken);
    return token;
  }


 static bool isEmailValid({required String email}) {
    final bool emailValid = RegExp(
        r'\S+@\S+\.\S+')
        .hasMatch(email);

    return emailValid;
  }

  static bool isPasswordValid({required String password}) {

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }
}
