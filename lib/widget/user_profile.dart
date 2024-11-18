import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/helper/auth_helperr.dart';
import 'package:nabgh_app/pages/auth_page/login_page.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';
import '../constatns/app_key.dart';
import '../pages/main_screen/profile_page/profile_page.dart';
import '../provider/auth_provider.dart';
import '../provider/chat_provider.dart';

class UserProfile extends StatelessWidget {

  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<AuthenticateProvider>();
    var pChat = context.read<ChatProvider>();
    return FutureBuilder(
        future: AuthHelper.isUserExist(),
        builder: (context, snapShot) {
          if (snapShot.data == null || snapShot.data == false) {
            return AppSmallButton(
              title: Text(
                LocalizationManager().translate('Login/Signup'),
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
              },
            );
          }
          return Consumer<AuthenticateProvider>(
            builder: (context,pAuth,_) {
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushNamed(ProfilePage.routeName).then((value) => pChat.userAttempt(context: context));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  //  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xff147758)),
                  ),
                  child: pAuth.userDetail?.data?.profile != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: AppKey.baseUrlImg +
                                provider.userDetail!.data!.profile!,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                          ),
                        )
                      : Image.asset("assets/icon/man.png"),
                ),
              );
            }
          );
        },
    );
  }
}
