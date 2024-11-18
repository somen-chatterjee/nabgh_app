import 'package:flutter/material.dart';
import 'package:nabgh_app/change_language/language_helper.dart';

class ErrorPage extends StatefulWidget {
  final VoidCallback onTap;

  const ErrorPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),
            Text(
              LocalizationManager().translate('somethingWentWrong'),
              style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: Text(
                LocalizationManager().translate('retry'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
