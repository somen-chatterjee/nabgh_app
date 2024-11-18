import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/pages/auth_page/reset_password_page.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../constatns/app_constants.dart';
import '../../enum/app_loading_staus.dart';
import '../../widget/app_small_button.dart';
import '../../widget/auth_background.dart';

class RegisterPinInputPage extends StatefulWidget {
  static const routeName = "register-pin-input-page";

  const RegisterPinInputPage({Key? key}) : super(key: key);

  @override
  State<RegisterPinInputPage> createState() => _ForgotPinInputPage();

  @override
  String toStringShort() => 'Rounded With Cursor';
}

class _ForgotPinInputPage extends State<RegisterPinInputPage> {
  int _timerSeconds = 30;
  late Timer _timer;
  bool _isTimerActive = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel();
          _isTimerActive = false;
        }
      });
    });
  }

  void _resendText() {
    if (!_isTimerActive) {
      // Start the timer when the "Resend" button is pressed
      _timerSeconds = 30;
      _startTimer();
      _isTimerActive = true;
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    _resendText();
    super.initState();
  }

  TextEditingController pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String resendText = "Resend";

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final focusedBorderColor = Colors.white.withOpacity(.7);
    const fillColor = Colors.transparent;
    final borderColor = Colors.white.withOpacity(.2);

    final defaultPinTheme = PinTheme(
      width: 100,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const AuthBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * .08),
                          child: SvgPicture.asset("assets/icon/brain.svg",
                              height: height * .08, width: width * .8),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    Text(
                      LocalizationManager().translate('OTP'),
                      style: const TextStyle(fontSize: 32),
                    ),
                    SizedBox(
                      height: height * .005,
                    ),
                    Text(
                      LocalizationManager().translate('OTPTxt'),
                      style: TextStyle(color: Colors.white.withOpacity(.6)),
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        length: 4,
                        controller: pinController,
                        focusNode: focusNode,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        listenForMultipleSmsOnAndroid: true,
                        defaultPinTheme: defaultPinTheme,
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          pinController = TextEditingController();

                          await context
                              .read<AuthenticateProvider>()
                              .verifyEmailOtp(context: context, otp: pin.toString())
                              .then((value) {
                            if (value.data["status"].toString() != "200") {
                              pinController.clear();
                            }
                          });
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 22,
                              height: 1,
                              color: focusedBorderColor,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    Consumer<AuthenticateProvider>(
                        builder: (context, provider, _) {
                      return SizedBox(
                        height: 45,
                        child: AppSmallButton(
                          title:
                              provider.loadingStatus == AppLoadingStatus.loading
                                  ? CircularProgressIndicator(
                                      color: Colors.black.withOpacity(.8),
                                    )
                                  : Text(
                                      LocalizationManager().translate('verify'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pushNamed(
                                context, PasswordResetPage.routeName);
                          },
                        ),
                      );
                    }),
                    SizedBox(
                      height: height * .32,
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 18.0, color: Colors.white),
                          children: [
                            TextSpan(
                              text: LocalizationManager()
                                  .translate('DidntReceiveTheOTP'),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(.6)),
                            ),
                            WidgetSpan(
                              child: InkWell(
                                onTap: () async {
                                  if (!_isTimerActive) {
                                    HapticFeedback.lightImpact();
                                    await context
                                        .read<AuthenticateProvider>()
                                        .signUp(
                                      context: context,
                                      social: false,
                                      map: {},
                                    );
                                    _resendText();
                                  }
                                },
                                child: Text(
                                  !_isTimerActive
                                      ? LocalizationManager()
                                          .translate('Resend')
                                      : "${LocalizationManager().translate('resendIn')}${_formatTime(_timerSeconds)}",
                                  style: const TextStyle(
                                    color: AppConstants.secondaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
