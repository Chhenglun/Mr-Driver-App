class AvartarBodyChatModel {
  final String? name;
  final String? img;
  final String? time;
  final String? message;
  final bool isOnline;
  final bool isRead;

  AvartarBodyChatModel({
    this.name,
    this.img,
    this.time,
    this.message,
    required this.isOnline,
    required this.isRead,
  });
  static List<AvartarBodyChatModel> getAvartarBodyChatModel() {
    return <AvartarBodyChatModel>[
      AvartarBodyChatModel(
        name: 'Han Sohee',
        img: 'assets/images/logo_user1.jpg',
        time: '10:00 AM',
        message: 'Hello, How are you?',
        isOnline: true,
        isRead: true,
      ),
      AvartarBodyChatModel(
        name: 'IU',
        img: 'assets/images/logo_user2.jpg',
        time: '10:00 AM',
        message: 'Hello, How are you?',
        isOnline: true,
        isRead: true,
      ),
      AvartarBodyChatModel(
        name: 'Goyojeong',
        img: 'assets/images/logo_user3.jpg',
        time: '10:00 AM',
        message: 'Hello, How are you?',
        isOnline: true,
        isRead: true,
      ),
      AvartarBodyChatModel(
        name: 'John Doe',
        img: 'assets/images/logo_user4.jpg',
        time: '10:00 AM',
        message: 'Hello, How are you?',
        isOnline: true,
        isRead: true,
      ),
      AvartarBodyChatModel(
        name: 'Kim hanbin',
        img: 'assets/images/logo_user5.jpg',
        time: '10:00 AM',
        message: 'Hello, How are you?',
        isOnline: true,
        isRead: true,
      ),  
      AvartarBodyChatModel(
        name: 'John Doe',
        img: 'assets/images/logo_user6.jpg',
        time: '10:00 AM',
        message: 'Hello, How are you?',
        isOnline: true,
        isRead: true,
      ),
      
    ];
  }
}