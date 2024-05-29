// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/data/model/response/country_model.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/view/custom/custom_textfield_widget.dart';

enum SelectCountryEnum {
  country,
  location,
  signIn,
  signUp,
  verify
}

class CustomButtonSheetCountry extends StatefulWidget {

  final String titleName;
  late String countryName;
  String selected;
  late bool isHaveCountry;
  final TextEditingController searchCtrl;
  final TextEditingController? areaCtrl;
  final TextEditingController? countryCodeCtrl;
  SelectCountryEnum selectCountryEnum;
  String countryIOS;

  CustomButtonSheetCountry({
    super.key,
    required this.titleName,
    required this.countryName,
    this.selected = "",
    this.isHaveCountry = true,
    required this.searchCtrl,
    this.areaCtrl,
    this.countryCodeCtrl,
    this.selectCountryEnum = SelectCountryEnum.country,
    this.countryIOS = "KH"
  });

  @override
  State<CustomButtonSheetCountry> createState() => _CustomButtonSheetCountryState();
}

class _CustomButtonSheetCountryState extends State<CustomButtonSheetCountry> {

  List<AllListCountry> filteredCountryList = [];
  String searchQuery = '';
  int selectedIdx = -1;

  @override
  void initState() {
    super.initState();
    filteredCountryList = countryList;
  }

  void _filterCountries(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredCountryList = countryList;
        selectedIdx = -1;
      } else {
        filteredCountryList = countryList.where((country) => country.countryName.toLowerCase().contains(query.toLowerCase())).toList();
        if(selectedIdx >= filteredCountryList.length){
          selectedIdx = -1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("cancel".tr, style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                ),
                Text(
                  widget.titleName.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      switch(widget.selectCountryEnum){
                        case SelectCountryEnum.country:
                          widget.areaCtrl?.text = widget.countryName;
                          widget.countryCodeCtrl?.text = "+${widget.countryName}";
                          widget.countryIOS = widget.countryIOS;
                          widget.searchCtrl.text = "";
                          break;
                        case SelectCountryEnum.location:
                          widget.areaCtrl?.text = widget.countryName;
                          widget.countryCodeCtrl?.text = "+${widget.countryName}";
                          widget.countryIOS = widget.countryIOS;
                          widget.searchCtrl.text = "";
                          break;
                        case SelectCountryEnum.signIn:
                          widget.areaCtrl?.text = widget.countryName;
                          widget.countryCodeCtrl?.text = "+${widget.countryName}";
                          widget.searchCtrl.text = "";
                          break;
                        case SelectCountryEnum.signUp:
                          widget.areaCtrl?.text = widget.countryName;
                          widget.countryCodeCtrl?.text = "+${widget.countryName}";
                          widget.searchCtrl.text = "";
                          break;
                        case SelectCountryEnum.verify:
                          widget.areaCtrl?.text = widget.countryName;
                          widget.countryCodeCtrl?.text = "+${widget.countryName}";
                          widget.searchCtrl.text = "";
                          break;
                      }
                      Get.back();
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("save".tr, style: TextStyle(color: ColorResources.blueColor, fontSize: 16)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 44,
                  child: CustomTextFieldWidget(
                    widget.searchCtrl,
                    isPhoneNumber: false,
                    label: "search".tr,
                    onChange: _filterCountries,
                    onSubmitted: _filterCountries,
                    hintText: "search".tr,
                    icon: Icons.abc,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 24),
                  child: Image.asset("assets/icons/search.png", width: 20, height: 20),
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: filteredCountryList.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountryList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIdx = index;
                            if (widget.isHaveCountry) {
                              widget.countryName = country.countryCode;
                            } else {
                              widget.countryName = country.countryName;
                            }
                            widget.countryIOS = country.countryIOS;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Show letter header
                            if (index == 0 || country.countryName[0] != filteredCountryList[index - 1].countryName[0])
                              GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: Container(
                                  color: ColorResources.blueGreyColor,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    country.countryName[0],
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)
                                  ),
                                ),
                              ),
                            Container(
                              height: 44,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.8,
                                    child: Text(
                                      widget.isHaveCountry ? capitalizeEachWord("${country.countryName} +${country.countryCode}") : capitalizeEachWord(country.countryName),
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  selectedIdx == index ? Icon(Icons.check, color: ColorResources.blueColor) : SizedBox()
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(height: 1, color: Colors.grey.shade300)
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Column(
                    children: [
                      SizedBox(height: 120),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: List.generate(26, (index) {
                              final letter = String.fromCharCode(65 + index);
                              return Text(
                                letter,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                              );
                            }),
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void buildButtonSheetCountryLocalCustom({
  required BuildContext context,
  required String titleName,
  required String countryName,
  required String selected,
  bool isHaveCountry = true,
  required TextEditingController searchCtrl,
  TextEditingController? areaCtrl,
  TextEditingController? countryCodeCtrl,
  SelectCountryEnum selectCountryEnum = SelectCountryEnum.country,
  String countryIOS = "KH"
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return CustomButtonSheetCountry(
            titleName: titleName,
            countryName: countryName,
            selected: selected,
            isHaveCountry: isHaveCountry,
            searchCtrl: searchCtrl,
            areaCtrl: areaCtrl,
            countryCodeCtrl: countryCodeCtrl,
            selectCountryEnum: selectCountryEnum,
            countryIOS: countryIOS,
          );
        },
      );
    },
  );
}