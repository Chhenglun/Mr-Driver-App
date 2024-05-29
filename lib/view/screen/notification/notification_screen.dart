// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/style.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  // Todo: buildAppBar
  AppBar get _buildAppBar {
    return AppBar(
      backgroundColor: ColorResources.primaryColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: FaIcon(
          FontAwesomeIcons.angleLeft,
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      title: Text(
        "Notification",
        style: textStyleMedium.copyWith(color: ColorResources.whiteColor,fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
    );
  }

  // Todo: buildBody
  Widget get _buildBody {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: ColorResources.whiteBackgroundColor,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          itemCount: 10,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: ColorResources.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorResources.greyColor.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: Image.asset('assets/images/logo.jpg').image,
                          ),
                          SizedBox(width: 16,),
                          SizedBox(
                            height: 100,
                            width: Get.width * 0.68,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      text: '',
                                      style: textStyleMedium.copyWith(color: ColorResources.blackColor,fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "We're have found 50 scholarship Worth 1000\$ for you",
                                          style: textStyleLowMedium.copyWith(color: ColorResources.blackColor,fontWeight: FontWeight.bold,fontSize: 12.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: '',
                                            style: textStyleMedium.copyWith(color: ColorResources.blackColor,fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "We're have found 50 scholarship Worth 1000\$ for you",
                                                style: textStyleLowMedium.copyWith(color: ColorResources.greyColor,fontWeight: FontWeight.bold,fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      GestureDetector(
                                        onTap: (){
                                          print("OnTap");
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                            color: ColorResources.primaryColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 16.0),
                                            child: Text("View Detail",style: textStyleLowMedium.copyWith(color: ColorResources.whiteColor,fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
