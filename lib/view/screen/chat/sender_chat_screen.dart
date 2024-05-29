import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scholarar/util/color_resources.dart';

class SenderChatScreen extends StatefulWidget {
  const SenderChatScreen({super.key});

  @override
  State<SenderChatScreen> createState() => _SenderChatScreenState();
}

class _SenderChatScreenState extends State<SenderChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.secondaryColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.white,
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: Image.asset('assets/images/logo_user1.jpg').image,
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Han Sohee',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Online',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
