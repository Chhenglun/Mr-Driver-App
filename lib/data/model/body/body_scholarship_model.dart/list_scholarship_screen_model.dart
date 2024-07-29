class ListScholarshipScreenModel {
  final String imgUrl;
  final String title;
  final String description;
  final String date;
  final String athor;
  final String logo;
  final String name;
  final String view;
  ListScholarshipScreenModel({
    required this.imgUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.athor,
    required this.logo,
    required this.name,
    required this.view,
  });
  static List < ListScholarshipScreenModel >  listScholarshipScreen() {
    return [
      ListScholarshipScreenModel(
        imgUrl:
            'https://d31dpzy4bseog7.cloudfront.net/media/2021/11/25122655/The-Design-Coach-2022-Scholarship-Program-News-Feature-The-Local-Project-Image-05-min-scaled.jpeg',
        title: 'Scholarship For China',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
        date: '12/12/2021',
        athor: 'Admin',
        logo:
            'assets/images/logo.jpg',
        name: 'Scholarship For USA',
        view: '12',
      ),
      ListScholarshipScreenModel(
        imgUrl:
            'https://leverageedu.com/blog/wp-content/uploads/2021/06/Top-Scholarships-to-Study-Online-1.png',
        title: 'Scholarship For UK',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
        date: '12/12/2021',
        athor: 'Admin',
        logo:
            'assets/images/logo.jpg',
        name: 'Scholarship For Australia',
        view: '12',
      ),
      ListScholarshipScreenModel(
        imgUrl:
            'https://st3.depositphotos.com/20120416/32801/i/450/depositphotos_328011494-stock-photo-letters-ielts-exam-on-marble.jpg',
        title: 'IELTS Level 7.5',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
        date: '12/12/2021',
        athor: 'Admin',
        logo:
            'assets/images/logo.jpg',
        name: 'IELTS Level 8.5',
        view: '12',
      ),
    ];
  }
}
