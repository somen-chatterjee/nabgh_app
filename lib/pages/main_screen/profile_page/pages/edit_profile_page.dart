import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nabgh_app/change_language/language_helper.dart';
import 'package:nabgh_app/constatns/app_constants.dart';
import 'package:nabgh_app/constatns/app_key.dart';
import 'package:nabgh_app/enum/app_loading_staus.dart';
import 'package:nabgh_app/provider/auth_provider.dart';
import 'package:nabgh_app/provider/profile_provider.dart';
import 'package:nabgh_app/widget/app_back_button.dart';
import 'package:nabgh_app/widget/app_small_button.dart';
import 'package:provider/provider.dart';

import '../../../../widget/app_textField.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = "edit-profile-page";

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker picker = ImagePicker();
  XFile? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    var data = Provider.of<AuthenticateProvider>(context, listen: false)
        .userDetail
        ?.data;
    nameController = TextEditingController(text: data?.name);
    emailController = TextEditingController(text: data?.email);
    setState(() {});
    super.initState();
  }

  buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16)
          .copyWith(top: 6, bottom: 8),
      child: Row(
        children: [
          const AppBackButton(),
          const Spacer(),
          Text(
            LocalizationManager().translate('myProfile'),
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          const SizedBox(
            width: 18,
          )
        ],
      ),
    );
  }

  buildImagePicker() {
    String? profileImage =
        context.read<AuthenticateProvider>().userDetail?.data?.profile;
    return Stack(
      children: [
        Center(
            child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(.2)),
                    color: const Color(0xff343434)),
                child: Builder(
                  builder: (BuildContext context) {
                    if (selectedImage != null) {
                      return ClipOval(
                        child: Image.memory(
                          File(selectedImage!.path).readAsBytesSync(),
                          fit: BoxFit.cover,
                          // width: 150,
                          // height: 150,
                        ),
                      );
                    }

                    if (profileImage != null) {
                      return ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: AppKey.baseUrlImg + profileImage,
                          fit: BoxFit.cover,
                        ),
                      );
                    }

                    return ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset("assets/icon/man.png"),
                      ),
                    );
                  },
                ))),
        Positioned(
            bottom: 10,
            right: MediaQuery.of(context).size.width * .28,
            child: InkWell(
              onTap: () async {
                HapticFeedback.lightImpact();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    selectedImage = image;
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.secondaryColor,
                ),
                padding: const EdgeInsets.all(7),
                child: const Icon(
                  CupertinoIcons.camera_fill,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    buildImagePicker(),
                    const SizedBox(
                      height: 40,
                    ),
                    AppTextField(
                      controller: nameController,
                      imgSrc: "assets/icon/name_input.svg",
                      title: LocalizationManager().translate('Name'),
                      // inputFormat: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppTextField(
                        controller: emailController,
                        imgSrc: "assets/icon/mail.svg",
                        title: LocalizationManager().translate('enterEmailId')),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 45,
                      child: Consumer<ProfileProvider>(
                          builder: (context, provider, _) {
                        return AppSmallButton(
                          title: provider.loadingStatus ==
                                  AppLoadingStatus.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : Text(
                                  LocalizationManager().translate("Save"),
                                  style: const TextStyle(color: Colors.black),
                                ),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            provider.editProfile(
                                context: context,
                                name: nameController.text,
                                email: emailController.text,
                                imagePath: selectedImage?.path,
                            );
                          },
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
