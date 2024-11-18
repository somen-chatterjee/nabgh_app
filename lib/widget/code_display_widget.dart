import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_highlighting/themes/github-dark.dart';

import '../constatns/app_constants.dart';

class CodeDisplayWidget extends StatelessWidget {
  final String code;

  const CodeDisplayWidget({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 38,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: AppConstants.gradient,
              color: Colors.white70,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18), topLeft: Radius.circular(18))),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              const Text(
                "C++",
                style: TextStyle(color: Colors.black),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Code copied")));
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.copy_sharp,
                      color: Colors.black,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Copy code",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        ),
        HighlightView(
          code,

          languageId: 'cpp',
          // Specify the code language for proper highlighting
          theme: githubDarkTheme,
          // You can choose a different theme here
          padding: const EdgeInsets.all(12),

          textStyle: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
