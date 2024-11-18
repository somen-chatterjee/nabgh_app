import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../constatns/app_constants.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String imgSrc;
  final bool? showHideBtn;
  final int? maxLine;
  final List<TextInputFormatter>? inputFormat;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  const AppTextField(
      {super.key,
      required this.controller,
      required this.title,
      required this.imgSrc,
      this.showHideBtn,
      this.maxLine,
      this.inputFormat,
        this.validator,
        this.textInputAction,
      });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.showHideBtn != null ? 1 : widget.maxLine,
      controller: widget.controller,
      obscureText: widget.showHideBtn != null && isHidden,
      validator: widget.validator,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Container(
            width: 22,
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 12),
            child: SvgPicture.asset(
              widget.imgSrc,
              fit: BoxFit.fill,
            ),
          ),
          hintText: widget.title,
          errorMaxLines: 10,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.secondaryColor.withOpacity(.18)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.secondaryColor.withOpacity(.18)),
          ),
          hintStyle: const TextStyle(fontWeight: FontWeight.w300),
          suffixIcon: widget.showHideBtn != null ? IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  isHidden = !isHidden;
                });
              },
              icon: isHidden
                  ? const Icon(Icons.visibility, color: Colors.white,)
                  : const Icon(Icons.visibility_off, color: Colors.white,))
              : null
      ),
      inputFormatters: widget.inputFormat ?? [],
    );
  }
}

/*
*
*   @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   width: 22,
            //   height: 34,
            //   padding: const EdgeInsets.only(top: 12),
            //   child: SvgPicture.asset(
            //     widget.imgSrc,
            //     fit: BoxFit.fill,
            //   ),
            // ),
            // const SizedBox(
            //   width: 8,
            // ),
            Expanded(
              child: TextFormField(
                maxLines: widget.showHideBtn != null ? 1 : widget.maxLine,
                controller: widget.controller,
                obscureText: widget.showHideBtn != null && isHidden,
                validator: widget.validator,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    width: 22,
                    height: 34,
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(
                      widget.imgSrc,
                      fit: BoxFit.fill,
                    ),
                  ),
                  hintText: widget.title,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                ),
                inputFormatters: widget.inputFormat ?? [],
              ),
            ),
            if (widget.showHideBtn != null)
              const SizedBox(
                width: 8,
              ),
            if (widget.showHideBtn != null)
              IconButton(
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  icon: isHidden
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off))
          ],
        ),
        Container(
          height: .8,
          color: AppConstants.secondaryColor.withOpacity(.18),
        )
      ],
    );
  }
* */