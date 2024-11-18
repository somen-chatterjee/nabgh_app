import 'package:flutter/material.dart';


class SuggestionTextField extends StatelessWidget {
  final String? title;
  final String? hintText;
  final int lines;
  final TextEditingController controller;
  final bool? scanner;

  const SuggestionTextField(
      {super.key,
      this.title,
      this.hintText,
      required this.controller,
      required this.lines, this.scanner});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: const TextStyle(fontSize: 18),
          ),
        if (title != null)
          const SizedBox(
            height: 10,
          ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(.5),
              borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            maxLines: lines,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: scanner != null && scanner!
                  ? const EdgeInsets.only(top: 0.0,bottom: 80.0, left: 12.0, right: 12.0,)
              : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0,),
            ),
          ),
        ),
      ],
    );
  }
}
