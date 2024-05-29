// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/style.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.secondaryColor,
      // appBar: _buildAppBar,
      body: _buildBody(),
    );
  }

  // Todo: buildBody
  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: ColorResources.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: FaIcon(FontAwesomeIcons.angleLeft, size: 25),
            color: ColorResources.whiteBackgroundColor,
          ),
          title: SizedBox(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _textController,
              keyboardAppearance: Brightness.dark,
              enableSuggestions: true,
              style: textStyleLowMedium.copyWith(color: ColorResources.whiteColor,fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () => _textController.clear(),
                  icon: Icon(Icons.clear, color: Colors.white, size: 25),
                ),
                prefixIcon: IconButton(
                  onPressed: (){
                    print(_textController.text);
                  },
                  icon:Icon(Icons.search, color: Colors.white, size: 25),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  gapPadding: 2.0,
                  borderSide: BorderSide(color: ColorResources.whiteColor,width: 2),
                ),
                filled: false,
                hintText: "Search book store ...",
                hintStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          centerTitle: true,
          // toolbarHeight: 60,
        ),

      ],
    );
  }
}