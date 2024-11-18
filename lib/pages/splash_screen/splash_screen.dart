import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabgh_app/helper/auth_helperr.dart';
import 'package:nabgh_app/helper/sp_helper.dart';
import 'package:nabgh_app/pages/main_screen/main_screen.dart';
import 'package:nabgh_app/pages/splash_screen/feature_showcase_papge.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/widget/auth_background.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
      // Set up the animation controller
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        // Set the duration of the animation
        vsync: this,
      );

      // Create a curved animation for a smoother effect
      _animation =
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

      // Start the animation
      _controller.forward();
      WidgetsBinding.instance.addPostFrameCallback((_) async {

        await SpHelper.saveString(
            SpKey.rateUs, "2");

      var pAuth = Provider.of<AuthenticateProvider>(context,listen: false);

      pAuth.getVersion(buildContext: context);

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Image.asset(
                        "assets/app_icon.png",
                        height: 80,
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
