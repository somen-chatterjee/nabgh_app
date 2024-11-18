import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';

class AppLoadingIndicator extends StatelessWidget {
  String? message;

  AppLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dialog(
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey.shade900,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              const Spacer(),
              const CircularProgressIndicator(),
              const SizedBox(
                width: 32,
              ),
              Text(
                message ?? LocalizationManager().translate('loading'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
