// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/dimensions.dart';
import 'package:scholarar/util/style.dart';

// Todo: CustomTextFieldWidget
class CustomTextFieldWidget extends StatefulWidget {

  final TextEditingController textEditingController;
  final String? label;
  final bool isPhoneNumber;
  final bool isShowSuffix;
  final bool isClear;
  final bool isObscureText;
  final BorderSide border;
  final int maxLine;
  final Function(String value)? onChange;
  final Function(String value)? onSubmitted;
  final Function()? onPress;
  final AuthController? authController;
  bool isDone;

  CustomTextFieldWidget(
    this.textEditingController,
    {
      super.key,
      this.label,
      this.isPhoneNumber = true,
      this.isShowSuffix = false,
      this.isClear = false,
      this.isObscureText = false,
      this.border = const BorderSide(color: Colors.black),
      this.maxLine = 1,
      this.onChange,
      this.onSubmitted,
      this.onPress,
      this.authController,
      this.isDone = false, required String hintText, required IconData icon
    }
  );

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFieldWidget> {

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: widget.textEditingController,
        keyboardType: widget.isPhoneNumber ? TextInputType.phone : TextInputType.text,
        validator: ((value) {
          widget.isPhoneNumber ? CustomValidatorWidget().validateMobile(value!) : null;
          return null;
        }),
        maxLines: widget.maxLine,
        obscuringCharacter: "*",
        style: textStyleRegular.copyWith(
          fontSize: widget.isObscureText ? 14 : 16,
          letterSpacing: widget.isObscureText ? 3 : 0
        ),
        onChanged: widget.onChange,
        onFieldSubmitted: widget.onSubmitted,
        obscureText: widget.isObscureText,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          filled: widget.authController!.isTypingCompleted ? false : true,
          fillColor: ColorResources.blueGreyColor,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(fontSize: 16),
          border: InputBorder.none,
          prefix: Text("  "),
          hintText: widget.label,
          hintStyle: textStyleRegular.copyWith(letterSpacing: 0),
          suffix: Text(" "),
          suffixIcon: widget.isShowSuffix ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: Dimensions.paddingSizeDefault),
              IconButton(
                iconSize: 24,
                splashColor: Colors.transparent,
                icon: ImageIcon(AssetImage(widget.isObscureText ? "assets/icons/eye.png" : "assets/icons/eye_off.png"), color: Colors.grey),
                onPressed: widget.onPress,
              ),
            ],
          ) : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: widget.border,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
        ),
        cursorColor: Colors.black45,
      ),
    );
  }
}

// Todo: CustomValidatorWidget (for validate mobile number)
class CustomValidatorWidget {
  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return "";
  }
}

// Todo: capitalizeEachWord (for capitalize each word)
String capitalizeEachWord (String str) {
  return str.toLowerCase().split(' ').map((word) {
    String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
    return word[0].toUpperCase() + leftText;
  }).join(' ');
}