// ignore_for_file: prefer_const_constructors, must_be_immutable, unnecessary_statements, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/util/color_resources.dart';

enum SelectCheckDocumentTypeEnum {
  check1,
  check2,
  check3,
}

enum SelectCheckGenderTypeEnum {
  other,
  male,
  female,
}

class ButtonSheetContentScreen extends StatefulWidget {

  final String titleName;
  final String text1;
  final String text2;
  late bool isCheckTrueFalse;
  late SelectCheckDocumentTypeEnum selectCheckDocumentTypeEnum;
  late SelectCheckGenderTypeEnum selectCheckGenderTypeEnum;
  final VoidCallback onText1;
  final VoidCallback onText2;
  final VoidCallback onCancel;

  ButtonSheetContentScreen({super.key,
    required this.titleName,
    required this.text1,
    required this.text2,
    required this.isCheckTrueFalse,
    this.selectCheckDocumentTypeEnum = SelectCheckDocumentTypeEnum.check1,
    this.selectCheckGenderTypeEnum = SelectCheckGenderTypeEnum.other,
    required this.onText1,
    required this.onText2,
    required this.onCancel,
  });

  @override
  _ButtonSheetContentScreenState createState() => _ButtonSheetContentScreenState();
}

class _ButtonSheetContentScreenState extends State<ButtonSheetContentScreen> {

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: widget.onCancel,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.check, color: Colors.transparent, size: 40)
              ),
            ),
            Text(widget.titleName.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            GestureDetector(
              onTap: widget.onCancel,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset("assets/icons/close.png", fit: BoxFit.fill, width: 40, height: 40),
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            setState(() {
              if(widget.isCheckTrueFalse = true){
                widget.selectCheckDocumentTypeEnum = SelectCheckDocumentTypeEnum.check2;
              }else {
                widget.selectCheckGenderTypeEnum = SelectCheckGenderTypeEnum.male;
              }
            });
            widget.onText1();
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: widget.isCheckTrueFalse == true ? BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.selectCheckDocumentTypeEnum == SelectCheckDocumentTypeEnum.check2 ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent,
            ) : BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.selectCheckGenderTypeEnum == SelectCheckGenderTypeEnum.male ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent,
            ),
            child: Text(widget.text1.tr),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if(widget.isCheckTrueFalse = true){
                widget.selectCheckDocumentTypeEnum = SelectCheckDocumentTypeEnum.check3;
              }else {
                widget.selectCheckGenderTypeEnum = SelectCheckGenderTypeEnum.female;
              }
            });
            widget.onText2();
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: widget.isCheckTrueFalse == true ? BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.selectCheckDocumentTypeEnum == SelectCheckDocumentTypeEnum.check3 ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent,
            ) : BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.selectCheckGenderTypeEnum == SelectCheckGenderTypeEnum.female ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent,
            ),
            child: Text(widget.text2.tr),
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}

void buildButtonSheetCustom({
  required BuildContext context,
  required String titleName,
  required String text1,
  required String text2,
  required bool isCheckTrueFalse,
  SelectCheckDocumentTypeEnum selectCheckDocumentTypeEnum = SelectCheckDocumentTypeEnum.check1,
  SelectCheckGenderTypeEnum selectCheckGenderTypeEnum = SelectCheckGenderTypeEnum.other,
  required VoidCallback onText1,
  required VoidCallback onText2,
  required VoidCallback onCancel,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    builder: (BuildContext context) {
      return ButtonSheetContentScreen(
        titleName: titleName,
        text1: text1,
        text2: text2,
        isCheckTrueFalse: isCheckTrueFalse,
        selectCheckDocumentTypeEnum: selectCheckDocumentTypeEnum,
        onText1: onText1,
        onText2: onText2,
        onCancel: onCancel,
      );
    },
  );
}

// Todo: SelectInformationType
enum SelectInformationType {
  other,
  documentType,
  gender,
  expired,
  contactUS,
  currency,
  mobileOperator
}

int otherNumber = -1;
int documentTypeNumber = -1;
int genderNumber = -1;
int expiredNumber = -1;
int contactUSNumber = -1;
int currencyNumber = -1;
int mobileOperatorNumber = -1;

// Todo: CustomButtonSheetContentScreen
class CustomButtonSheetContentScreen extends StatefulWidget {

  final String titleName;
  late SelectInformationType selectInformationType;
  late List<dynamic> allItem;
  final VoidCallback onText;

  CustomButtonSheetContentScreen({
    super.key,
    required this.titleName,
    required this.selectInformationType,
    required this.allItem,
    required this.onText,
  });

  @override
  _CustomButtonSheetContentScreenState createState() => _CustomButtonSheetContentScreenState();
}

class _CustomButtonSheetContentScreenState extends State<CustomButtonSheetContentScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.check, color: Colors.transparent, size: 40),
            ),
            Text(widget.titleName.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset("assets/icons/close.png", fit: BoxFit.fill, width: 40, height: 40),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        ListView.builder(
          itemCount: widget.selectInformationType == SelectInformationType.mobileOperator ? widget.allItem.length > 3 ? 3 : 0 : widget.allItem.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  switch (widget.selectInformationType) {
                    case SelectInformationType.other:
                      otherNumber = index;
                      break;
                    case SelectInformationType.documentType:
                      documentTypeNumber = index;
                      break;
                    case SelectInformationType.gender:
                      genderNumber = index;
                      break;
                    case SelectInformationType.expired:
                      expiredNumber = index;
                      break;
                    case SelectInformationType.contactUS:
                      contactUSNumber = index;
                      break;
                    case SelectInformationType.currency:
                      currencyNumber = index;
                      break;
                    case SelectInformationType.mobileOperator:
                      mobileOperatorNumber = index;
                      break;
                  }
                });
                widget.onText();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: getCustomBackgroundColorForSelectType(widget.selectInformationType, index),
                ),
                child: Text(
                  widget.selectInformationType == SelectInformationType.currency ?
                  "${widget.allItem[index]['name']}" : widget.allItem[index].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: getCustomForegroundColorForSelectType(widget.selectInformationType, index)
                  )
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

// Todo: customColorForSelectType
Color getCustomBackgroundColorForSelectType(SelectInformationType selectInformationType, int index) {
  switch (selectInformationType) {
    case SelectInformationType.documentType:
      return (index == documentTypeNumber) ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent;
    case SelectInformationType.gender:
      return (index == genderNumber) ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent;
    case SelectInformationType.expired:
      return (index == expiredNumber) ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent;
    case SelectInformationType.currency:
      return (index == currencyNumber) ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent;
    default:
      return (index == otherNumber) ? ColorResources.blueColor.withOpacity(0.3) : Colors.transparent;
  }
}

// Todo: getCustomForeColorForSelectType
Color getCustomForegroundColorForSelectType(SelectInformationType selectInformationType, int index) {
  switch (selectInformationType) {
    case SelectInformationType.documentType:
      return (index == documentTypeNumber) ? ColorResources.blueColor : Colors.black;
    case SelectInformationType.gender:
      return (index == genderNumber) ? ColorResources.blueColor : Colors.black;
    case SelectInformationType.expired:
      return (index == expiredNumber) ? ColorResources.blueColor : Colors.black;
    case SelectInformationType.currency:
      return (index == currencyNumber) ? ColorResources.blueColor : Colors.black;
    default:
      return (index == otherNumber) ? ColorResources.blueColor : Colors.black;
  }
}

// Todo: customBuildButtonSheetCustom
void customBuildButtonSheetCustom({
  required BuildContext context,
  required String titleName,
  String? text,
  SelectInformationType selectInformationType = SelectInformationType.other,
  required List allItem,
  required VoidCallback onText,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    builder: (BuildContext context) {
      return CustomButtonSheetContentScreen(
        titleName: titleName,
        selectInformationType: selectInformationType,
        allItem: allItem,
        onText: onText,
      );
    },
  );
}