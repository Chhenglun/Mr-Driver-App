import 'package:scholarar/data/model/body/body_chat_model/user_body_chat_model.dart';

class Message {
  final User sender;
  final String time;
  final String text;
  final bool unread;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.unread,
  });
  List<Message> messages = [
    Message(
      sender: currentUser,
      time: '5:30 PM',
      text: 'Hello, How are you?',
      unread: true,
    ),
    Message(
      sender: user2,
      time: '5:30 PM',
      text: 'Hello, How are you?',
      unread: true,
    ),
    Message(
      sender: user3,
      time: '5:30 PM',
      text: 'Hello, How are you?',
      unread: false,
    ),
    Message(
      sender: user4,
      time: '5:30 PM',
      text: 'Hello, How are you?',
      unread: true,
    ),
    Message(
      sender: user5,
      time: '5:30 PM',
      text: 'Hello, How are you?',
      unread: false,
    ),
    Message(
      sender: user6,
      time: '5:30 PM',
      text: 'Hello, How are you?',
      unread: true,
    ),
  ];
}
