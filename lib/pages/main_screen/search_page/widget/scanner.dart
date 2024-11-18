import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/provider/scan_data_provider.dart';
import 'package:nabgh_app/router.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../change_language/language_helper.dart';
import '../../../../widget/app_back_button.dart';
import '../../chat_page/search_chat_screen.dart';

class Scanner extends StatefulWidget {
  static const routeName = "scanner-page";

  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  String argument = "";

  bool _isPermissionGranted = false;

  ValueNotifier<bool> processing = ValueNotifier(false);

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16)
          .copyWith(top: 4, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          const SizedBox(
            width: 12,
          ),
          Text(
            LocalizationManager().translate('scanner'),
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          const SizedBox(
            width: 32,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      if (state == AppLifecycleState.resumed) {
        _checkCameraPermission();
        if(Platform.isAndroid && _cameraController != null &&
            _cameraController!.value.isInitialized){
          _startCamera();
        }
      }
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    argument = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildAppBar(),
            if (_isPermissionGranted)
              Container(
                height: height/1.6,
                margin: const EdgeInsets.symmetric(
                    horizontal: 0.0, vertical: 20.0,
                ),
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    return FutureBuilder<List<CameraDescription>>(
                      future: availableCameras(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _initCameraController(snapshot.data!);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 00.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: CameraPreview(_cameraController!),
                              ),
                            ),
                          );
                        } else {
                          return const LinearProgressIndicator();
                        }
                      },
                    );
                  },
                ),
              ),
            _isPermissionGranted
                ? Expanded(
                  child: Container(
              // color: Colors.white,
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: processing,
                          builder: (context, value, child) {
                            return value
                                ? const CircularProgressIndicator(
                                    color: Colors.blue,
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      _scanImage(
                                          context: context, argument: argument);
                                    },
                                    child: const Text('Scan text'),
                                  );
                          },
                        ),
                      ),
                    ),
                )
                : Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocalizationManager().translate('cameraPermissionDenied'),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            IntrinsicWidth(
                              child: AppSmallButton(
                                title: Text(
                                  LocalizationManager().translate('openSettings'),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () async{
                                  HapticFeedback.lightImpact();
                                  await openAppSettings();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
    setState(() {});
  }

  Future<void> _checkCameraPermission() async {
    availableCameras();
    final status = await Permission.camera.isGranted;
    _isPermissionGranted = status;
    setState(() {});
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage(
      {required BuildContext context, required String argument}) async {
    processing.value = true;
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      if (recognizedText.text.isNotEmpty) {
        if (argument.isNotEmpty && argument == "search") {
          // await navigator.push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) =>
          //         Result(text: recognizedText.text),
          //   ),
          // );
          // navigatorKey.currentState!.pushNamed(ChatPage.routeName);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return SearchChatPage(
                  title: LocalizationManager().translate('Search'),
                  value: recognizedText.text.trim().toString(),
                  scanned: true,
                );
              },
            ),
          );
        } else {
          if (context.mounted) {
            var provider =
                Provider.of<ScanDataProvider>(context, listen: false);
            provider.setScanData(recognizedText.text);
            navigatorKey.currentState!.pop();
          }
        }
      } else {
        AppConstants.getToast(
            message: LocalizationManager().translate('properText'));
        // navigatorKey.currentState!.pop();
      }

      processing.value = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocalizationManager().translate('errorOccurred')),
        ),
      );
      processing.value = false;
    }
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Text(text),
      ),
    );
  }
}
