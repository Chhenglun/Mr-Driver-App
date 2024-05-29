class ListScholarshipModel {
  String imgUrl;
  String title;
  ListScholarshipModel({required this.imgUrl, required this.title});

  static List<ListScholarshipModel> scholarshipCourse = [
    ListScholarshipModel(
      //imgUrl: 'assets/images/scholarship.png',
      imgUrl:
          'https://d31dpzy4bseog7.cloudfront.net/media/2021/11/25122655/The-Design-Coach-2022-Scholarship-Program-News-Feature-The-Local-Project-Image-05-min-scaled.jpeg',
      title: 'Scholarship For China',
    ),
    ListScholarshipModel(
      imgUrl:
          'https://www.bitdegree.org/courses/storage/course-image/python-image-recognition.jpg',
      title: 'SCholarship For USA',
    ),
    ListScholarshipModel(
      imgUrl:
          'https://leverageedu.com/blog/wp-content/uploads/2021/06/Top-Scholarships-to-Study-Online-1.png',
      title: 'Scholarship For UK',
    ),
    ListScholarshipModel(
      imgUrl:
          'https://res.cloudinary.com/dhsjpmqz9/images/f_auto,q_auto,w_700,h_460,c_fill,g_auto/infobwana_9_p0kzni/unicaf-scholarships-zambia-clqvtce2g000008l8ex6l0zgy.jpg',
      title: 'Scholarship For Australia',
    ),
  ];
}
