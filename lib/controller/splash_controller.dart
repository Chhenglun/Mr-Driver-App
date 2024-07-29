import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  changeIndex(int index) {
    _selectedIndex = index;
    update();
  }
}