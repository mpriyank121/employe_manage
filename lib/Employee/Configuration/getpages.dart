import 'package:coreHrx_employeeapp/Employee/Configuration/routes.dart';
import 'package:get/get.dart';
import 'package:coreHrx_employeeapp/Employee/Settings/settings.dart';
import 'package:coreHrx_employeeapp/Employee/Login/otp_page.dart';
import 'package:coreHrx_employeeapp/Employee/Home/welcome_page.dart';
import 'package:coreHrx_employeeapp/Employee/Assets/assets_cat.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/holiday_list.dart';
import 'package:coreHrx_employeeapp/Employee/Leave/leave_detail.dart';
import 'package:coreHrx_employeeapp/Employee/Categories/Categories.dart';
import 'package:coreHrx_employeeapp/Employee/Documents/documents.dart';
import 'package:coreHrx_employeeapp/Employee/Attendance/attendence.dart';

final List<GetPage> getPages = [
  GetPage(name: Routes.settings, page: () => settingpage(title: 'settings')),
  GetPage(
      name: Routes.otp,
      page: () => OtpPage(
            phone: 'phonenumber',
          )),
  GetPage(
      name: Routes.welcome,
      page: () => WelcomePage(
            title: 'welcome',
          )),
  GetPage(
      name: Routes.assets,
      page: () => Assetspage(
            title: 'assets',
            empId: '',
          )),
  GetPage(name: Routes.document, page: () => documentpage(title: 'document')),
  GetPage(name: Routes.holiday, page: () => HolidayPage(title: 'holiday')),
  GetPage(name: Routes.category, page: () => CategoryPage(title: 'category')),
  GetPage(name: Routes.leaveDetail, page: () => LeavePage(title: 'leave')),
  GetPage(
      name: Routes.attendence,
      page: () => AttendancePage(
            title: 'attendence',
          ))
];
