import 'package:get/get.dart';
import 'package:employe_manage/Configuration/routes.dart';
import 'package:employe_manage/Screens/settings.dart';
import 'package:employe_manage/Screens/otp_page.dart';
import 'package:employe_manage/Screens/welcome_page.dart';
import 'package:employe_manage/Screens/assets_cat.dart';
import 'package:employe_manage/Screens/holiday_list.dart';
import 'package:employe_manage/Screens/leave_detail.dart';
import 'package:employe_manage/Screens/Categories.dart';
import 'package:employe_manage/Screens/documents.dart';
import 'package:employe_manage/Screens/attendence.dart';


final List<GetPage> getPages = [
  GetPage(name: Routes.settings, page: () => settingpage(title: 'settings')),
  GetPage(name: Routes.otp, page: () => OtpPage(phone: 'phonenumber',)),
  GetPage(name: Routes.welcome, page: () => WelcomePage(title: 'welcome',)),
  GetPage(name: Routes.assets, page: () => Assetspage(title: 'assets', empId: '',)),
  GetPage(name: Routes.document, page: () => documentpage(title: 'document')),
  GetPage(name: Routes.holiday, page: () => holidaypage(title: 'holiday')),
  GetPage(name: Routes.category, page: () =>CategoryPage(title: 'category')),
  GetPage(name: Routes.leaveDetail, page: () => leavepage(title: 'leave')),
  GetPage(name: Routes.attendence, page: () => AttendancePage(title: 'attendence',))
];
