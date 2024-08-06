import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatelessWidget {
  final List<Member> members = [
    Member(name: 'Choub Chhenglun', role: 'Software Engineering', imageUrl: 'assets/images/chhenglun.jpg'),
    Member(name: 'Bou Taihor', role: 'Software Engineering', imageUrl: 'assets/images/taihor.jpg'),
    Member(name: 'Leang Menghang', role: 'Software Engineering', imageUrl: 'assets/images/menghang.jpg'),
    Member(name: 'Sot Sopheaktra', role: 'Software Engineering', imageUrl: 'assets/images/sopheaktra.jpg'),
    Member(name: 'Rim Kunvath', role: 'Software Engineering', imageUrl: 'assets/images/kunvath.jpg'),
    Member(name: 'Phin Dara', role: 'Software Engineering', imageUrl: 'assets/images/dara.jpg'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back_ios,color: ColorResources.whiteColor,),),
        title: Text('អំពីយេីង', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: ColorResources.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 4,vertical: 84),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return MemberCard(member: members[index]);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class Member {
  final String name;
  final String role;
  final String imageUrl;

  Member({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class MemberCard extends StatefulWidget {
  final Member member;

  MemberCard({required this.member});

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {

  void _showMemberDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage(widget.member.imageUrl),
              ),
              SizedBox(height: 20),
              Text(
                widget.member.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.primaryColor,
              ),
                onPressed: (){
                  Navigator.pop(context);},
                child: Text('បិទ',style: TextStyle(color: ColorResources.whiteColor,fontSize: 16),)
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () {
          _showMemberDetails(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(widget.member.imageUrl),
            ),
            SizedBox(height: 10),
            Text(
              widget.member.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(widget.member.role, style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
