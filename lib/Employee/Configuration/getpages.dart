import 'package:employe_manage/Employee/Configuration/routes.dart';
import 'package:get/get.dart';
import 'package:employe_manage/Employee/Settings/settings.dart';
import 'package:employe_manage/Employee/Login/otp_page.dart';
import 'package:employe_manage/Employee/Home/welcome_page.dart';
import 'package:employe_manage/Employee/Assets/assets_cat.dart';
import 'package:employe_manage/Employee/Holidays/holiday_list.dart';
import 'package:employe_manage/Employee/Leave/leave_detail.dart';
import 'package:employe_manage/Employee/Categories/Categories.dart';
import 'package:employe_manage/Employee/Documents/documents.dart';
import 'package:employe_manage/Employee/Attendance/attendence.dart';


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
