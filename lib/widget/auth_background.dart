import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .5,
      child: SvgPicture.asset(
        "assets/app_background.svg",
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
