import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/main_screen/subscription_page/subscription_page.dart';
import 'package:nabgh_app/widget/app_small_button.dart';

class NewScreenModal extends StatelessWidget {
  final VoidCallback function;
  const NewScreenModal({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 32.0,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocalizationManager().translate('switchModel'),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              LocalizationManager().translate('thisActionWill'),
              style: const TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 40,
              // width: 150,
              child: AppSmallButton(
                  title: Text(
                    LocalizationManager().translate('startNewChat'),
                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600,),
                  ),
                  onTap: function,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                LocalizationManager().translate("Cancel"),
                style: const TextStyle(
                  // fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
