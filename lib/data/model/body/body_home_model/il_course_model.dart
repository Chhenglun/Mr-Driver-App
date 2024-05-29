class IELTSCourseModel {
  String imgUrl;
  String title;
  IELTSCourseModel({required this.imgUrl, required this.title});

  static List<IELTSCourseModel> iEltsCourse = [
    IELTSCourseModel(
      //imgUrl: 'assets/images/scholarship.png',
      imgUrl:
          'https://st3.depositphotos.com/20120416/32801/i/450/depositphotos_328011494-stock-photo-letters-ielts-exam-on-marble.jpg',
      title: 'IELTS Level 7.5',
    ),
    IELTSCourseModel(
      imgUrl:
          'https://mir-s3-cdn-cf.behance.net/project_modules/disp/637abf161213829.63c14ca671d4f.png',
      title: 'IELTS Level 8.5',
    ),
    IELTSCourseModel(
      imgUrl:
          'https://i.pinimg.com/736x/6b/39/d6/6b39d64a547e18ba8e87f1484c252842.jpg',
      title: 'IELTS Level 9',
    ),
    IELTSCourseModel(
      imgUrl:
          'https://studysmart.co.in/wp-content/uploads/2022/08/WhatsApp-Image-2022-08-09-at-1.17.10-PM.jpeg',
      title: 'IELTS Test',
    ),
  ];
}
