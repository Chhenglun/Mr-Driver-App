

class User {
  final String name;
  final String img;
  final String time;
  final String message; 
  final bool isOnline;
  final bool isRead;
  User({
    required this.name,
    required this.img,
     required this.time,
     required this.message,
     required this.isOnline,
    required this.isRead,
  });
  
}
final User currentUser = User(
    name: 'Han sohee',
    img: 'assets/images/logo_user1.jpg',
    time: '10:00 AM',
    message: 'Hello, How are you?',
    isOnline: true,
    isRead: true,
  );
  final User user2 = User(
    name: 'IU',
    img: 'assets/images/logo_user2.jpg',
    time: '10:00 AM',
    message: 'Hello, How are you?',
    isOnline: true,
    isRead: true,
  );
  final User user3 = User(
    name: 'Goyojeong',
    img: 'assets/images/logo_user3.jpg',
    time: '10:00 AM',
    message: 'Hello, How are you?',
    isOnline: true,
    isRead: true,
  );
  final  User user4 = User(
    name: 'John Doe',
    img: 'assets/images/logo_user4.jpg',
    time: '10:00 AM',
    message: 'Hello, How are you?',
    isOnline: true,
    isRead: true,
  );
  final User user5 = User(
    name: 'Kim hanbin',
    img: 'assets/images/logo_user5.jpg',
    time: '10:00 AM',
    message: 'Hello, How are you?',
    isOnline: true,
    isRead: true,
  );
  final User user6 = User(
    name: 'John Doe',
    img: 'assets/images/logo_user6.jpg',
    time: '10:00 AM',
    message: 'Hello, How are you?',
    isOnline: true,
    isRead: true,
  );