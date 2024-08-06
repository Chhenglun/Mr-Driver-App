import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/color_resources.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<String> notifications = [
    "ក្នុងឱកាសបុណ្យភ្ជុំបិណ្យខាងមុងនេះនឹងមានការបញ្ចុះតម្លៃ50%ទៅលេីការកក់អ្នកបេីកបរ",
    "ចំពោះអតិថិជនថ្មីនឹងមានការបញ្ចុះតម្លៃ20%ទៅលេីការកក់ដំបូង",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back_ios,color: ColorResources.whiteColor,),),
        title: Text('ការជូនដំណឹង', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: ColorResources.primaryColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        notifications[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
