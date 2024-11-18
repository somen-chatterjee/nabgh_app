import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constatns/app_constants.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      child: const CircleAvatar(
        backgroundColor: AppConstants.secondaryColor,
        child: Icon(
          CupertinoIcons.back,
          color: Colors.white,
        ),
      ),
    );
  }
}

//SvgPicture.asset("assets/icon/back.svg")
