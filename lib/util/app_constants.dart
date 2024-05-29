import 'package:scholarar/data/model/response/language_model.dart';

//location
  late double latCur;
  late double longCur;
  late double latDir;
  late double longDir;

class AppConstants {
  static const String theme = "authenticator_theme";
  static const String appName = "Authenticator";
  static const String baseURL = "https://scholarar-dev.seksa.today";
  static const String getBookStore = "/api/books";
  static const String testVideoAPI = "/api/categories";
  static const String register = "/api/v1/register";
  static const String login = "/api/v1/login";

  static const String token = "token";
  static const String logo = "assets/images/logo.jpg";
  static const String languageCode = "language_code";
  static const String countryCode = "country_code";
  static const String isSelectNumber = "isSelectNumber";
  static const String testAPI = "https://fakestoreapi.com/products";
  static const String testAPI2 = "https://randomuser.me/api?results=50";
  static const String testNewAPI = "https://newsapi.org/v2/everything?q=tesla&from=2024-02-15&sortBy=publishedAt&apiKey=fe89ee9dd855471b96e307ad189b48d2";
  static const String testCourseAPI = "/api/courses";
  static const String getScholarship = "/api/scholarships";
  static const String getScholarshipList = "/api/scholarships?degree_id=";
  static const String getDegrees =  "/api/degrees";
  static const String getHomeData = "/api/v1";
  static const String getSubscription = "api/subscription";

  // auth
  static const String phoneSignIn = "";
  static const String sendVerificationSMS = "";
  static const String verificationCode = "";
  static const String phoneSignUP = "";
  static const String signOut = "";
  static const String getUserInfo= "/api/v1/user/profile";
  static const String changeUserName = "";
  static const String changeAvatar = "";
  static const String resetPassword = "";
  static const String changePassword = "";
  static const String forgetPassword = "";
  static const String deviceInfo = "";
  static const String changePhoneNumber = "";

  // course
  static const String getCourse = "/api/courses";
  static const String getCategory = "/api/categories";

  // qr code
  static const String getQRCode = "";
  static const String findQRCode = "";

  // country
  static const String getCountry = "/api/countries";

  

  // Setting
  static const String checkVersionApp = "";
  static const String uploadFile = "";

  // translate
  static List<LanguageModel> languages = [
    LanguageModel(
      imageUrl: "assets/images/logo_english.png",
      languageName: "English",
      countryCode: "US",
      languageCode: "en"
    ),
    LanguageModel(
      imageUrl: "assets/images/logo_english.png",
      languageName: "Khmer",
      countryCode: "KH",
      languageCode: "km"
    ),
    LanguageModel(
      imageUrl: "assets/images/logo_china.png",
      languageName: "简体中文",
      countryCode: "CN",
      languageCode: "zh"
    )
  ];
}