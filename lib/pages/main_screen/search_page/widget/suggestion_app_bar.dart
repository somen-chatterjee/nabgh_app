import 'package:flutter/cupertino.dart';

import '../../../../widget/app_back_button.dart';

class SuggestionAppBar extends StatelessWidget {
  final String title;
  const SuggestionAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            width: 22,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
