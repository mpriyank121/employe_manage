import 'package:get/get.dart';
import 'package:employe_manage/Configuration/routes.dart';
import 'package:employe_manage/Screens/settings.dart';
import 'package:employe_manage/Screens/otp_page.dart';
import 'package:employe_manage/Screens/welcom_page.dart';
import 'package:employe_manage/Screens/assets_cat.dart';
import 'package:employe_manage/Screens/holiday_list.dart';
import 'package:employe_manage/Screens/leave_detail.dart';
import 'package:employe_manage/Screens/Categories.dart';
import 'package:employe_manage/Screens/documents.dart';


final List<GetPage> getPages = [
  GetPage(name: Routes.settings, page: () => settingpage(title: 'settings')),
  GetPage(name: Routes.otp, page: () => OtpPage()),
  GetPage(name: Routes.welcome, page: () => welcomepage(title: 'welcome')),
  GetPage(name: Routes.assets, page: () => Assetspage(title: 'assets')),
  GetPage(name: Routes.document, page: () => documentpage(title: 'document')),
  GetPage(name: Routes.holiday, page: () => holidaypage(title: 'holiday')),
  GetPage(name: Routes.category, page: () =>CategoryPage(title: 'category')),
  GetPage(name: Routes.leaveDetail, page: () => leavepage(title: 'leave')),
];
