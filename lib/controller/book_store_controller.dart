// ignore_for_file: await_only_futures, avoid_print, unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, deprecated_member_use

import 'package:get/get.dart';
import 'package:scholarar/data/repository/book_store_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookStoreController extends GetxController implements GetxService {
  final BookStoreRepository bookStoreRepository;
  final SharedPreferences sharedPreferences;
  BookStoreController({required this.bookStoreRepository, required this.sharedPreferences});
  //Todo : calculate price 
  final RxInt  quantity = 1.obs;
  final RxInt total = 0.obs;
  

  // set
  bool _isLoading = false;
  bool _isLoadMore = false;
  int _page = 1;
  Map<String, dynamic>? _bookStoreMap;
  Map<String, dynamic>? _bookDetailMap;
  List? _bookStoreList;
  List? _recommendedList;
  List? _newestList;

  // get
  bool get isLoading => _isLoading;
  bool get isLoadMore => _isLoadMore;
  int get page => _page;
  Map<String, dynamic>? get bookStoreMap => _bookStoreMap;
  Map<String, dynamic>? get bookDetailMap => _bookDetailMap;
  List? get bookStoreList => _bookStoreList;
  List? get recommendedList => _recommendedList;
  List? get newestList => _newestList;

  setLoadMore(bool more) {
    _isLoadMore = more;
    update();
  }

  setPage(int page) async {
    _page = page;
    update();
  }

  // Todo: getBookStore
  Future getBookStore() async {
    try {
      _isLoading = true;
      update();
      Response response = await bookStoreRepository.getBookStore("$_page");
      if(response.body['status'] == 200) {
        var lists = response.body['data']['lists'];
        if(_page == 1) {
          _bookStoreList = [];
          _recommendedList = [];
          _newestList = [];
        }
        lists.forEach((v) {
          _bookStoreList?.add(v);
        });
        lists.forEach((v) {
          _recommendedList = lists.where((book) => book['recommendation'] == true).toList();
        });
        lists.forEach((v) {
          _newestList = lists.where((book) => book['newest'] == true).toList();
        });
        _isLoadMore = true;
        _page = _page + 1;
        update();
      } else {
        print("Error: ${response.body['message']}");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
      _isLoading = false;
      update();
    }
  }

  // TODO: GetBookDetail
  Future getBookDetail({required int bookId}) async {
    try {
      // _isLoading = true;
      // update();
      Response response = await bookStoreRepository.getBookDetail(bookId: bookId);
      if(response.body['status'] == 200) {
        _bookDetailMap = response.body['data'];
        print("Book Detail $bookDetailMap");
      } else {
        print("Error");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print("=================================================");
      throw e.toString();
    }
  }
}
