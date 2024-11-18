import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/widget/app_small_button.dart';

class SubsciptionScuccesModal extends StatelessWidget {
  const SubsciptionScuccesModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade900,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 4,
            top: 4,
            child: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              icon: SvgPicture.asset(
                "assets/icon/close.svg",
                color: Colors.white.withOpacity(.8),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/icon/success.png",
                height: 120,
              ),
              Text(
                LocalizationManager().translate('Congratulations'),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                LocalizationManager().translate('youSubscribedNow'),
                style: TextStyle(color: Colors.white.withOpacity(.7)),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 40,
                width: 150,
                child: AppSmallButton(
                    title: Text(
                      LocalizationManager().translate("OK"),
                      style: const TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
