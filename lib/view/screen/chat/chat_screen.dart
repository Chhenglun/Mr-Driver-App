import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scholarar/data/model/body/body_chat_model/avartar_body_chat_model.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/screen/chat/sender_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with AutomaticKeepAliveClientMixin {

  final getAvatarBodyChat = AvartarBodyChatModel.getAvartarBodyChatModel();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ColorResources.secondaryColor,
      body: _buildBody,
    );
  }

  // Todo: buildBody
  Widget get _buildBody {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const FaIcon(FontAwesomeIcons.angleLeft),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10),
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Message",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 35),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Online",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 35),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Group",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 35),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "More",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
            height: 200,
            decoration: BoxDecoration(
              color: ColorResources.primaryColor,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Favorite Contact",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 95,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: getAvatarBodyChat.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: Image.asset('${getAvatarBodyChat[index].img}').image,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${getAvatarBodyChat[index].name}",
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 300,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                left: 20,
                right: 20,
              ),
              child: ListView.builder(
                itemCount: getAvatarBodyChat.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      nextScreen(context, const SenderChatScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: Image.asset('${getAvatarBodyChat[index].img}',).image,
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: getAvatarBodyChat[index].isRead ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${getAvatarBodyChat[index].name}",
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${getAvatarBodyChat[index].message}",
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "${getAvatarBodyChat[index].time}",
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  CircleAvatar(
                                    radius: 7,
                                    backgroundColor: getAvatarBodyChat[index].isOnline ? Colors.green : Colors.grey,
                                    child: const Text(
                                      "2",
                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
