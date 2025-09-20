import 'package:get/get_navigation/get_navigation.dart';
import 'package:mediact_app/module/authication/view/login.dart';
import 'package:mediact_app/module/schedule/view/home.dart';

class AppPages {
  List<GetPage> pages = [
    GetPage(name: '/login', page: () => Login()),
    GetPage(name: '/home', page: () => Home()),
  ];
}
