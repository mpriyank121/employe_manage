// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../Employee/Configuration/ui_styles.dart';
// import 'bottom_sheet_helper.dart';

// class DatePickerDropdown extends StatefulWidget {
//   final Function(DateTime, String, String, String?, String?, String?, String?) onDateSelected;

//   const DatePickerDropdown({Key? key, required this.onDateSelected}) : super(key: key);

//   @override
//   _DatePickerDropdownState createState() => _DatePickerDropdownState();
// }

// class _DatePickerDropdownState extends State<DatePickerDropdown> {
//   DateTime selectedDate = DateTime.now();
//   String selectedFirstIn = "N/A";
//   String selectedLastOut = "N/A";
//   String? checkInImage;
//   String? checkOutImage;
//   String? checkInLocation;
//   String? checkOutLocation;
//   String? selectedCheckInLocation;
//   String? selectedCheckOutLocation;

//   void _updateDate(
//       DateTime newDate,
//       String firstInTime,
//       String lastOutTime,
//       String? checkinImage,
//       String? checkoutImage,
//       String? checkInLocation,
//       String? checkOutLocation,
//       ) {
//     print('======================>$checkinImage');
//     if (newDate == null) return; // ✅ Prevent updating with null values.

//     setState(() {
//       selectedDate = newDate;
//       selectedFirstIn = firstInTime.isNotEmpty ? firstInTime : "N/A";
//       selectedLastOut = lastOutTime.isNotEmpty ? lastOutTime : "N/A";
//       checkInImage = checkinImage ?? "";
//       checkOutImage = checkoutImage ?? "";
//       selectedCheckInLocation = checkInLocation ?? "";
//       selectedCheckOutLocation = checkOutLocation ?? "";

//     });

//     print('updTE Dte');
//     /// ✅ Pass updated values to parent
//     widget.onDateSelected(selectedDate, selectedFirstIn, selectedLastOut, checkInImage, checkOutImage,
//         selectedCheckInLocation,
//         selectedCheckOutLocation
//        );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell( // ✅ Better tap effect
//       borderRadius: BorderRadius.circular(8),
//       onTap: () => showDatePickerBottomSheet(context, _updateDate),
//       child: AnimatedContainer(
//         duration: UIStyles.animationDuration,
//         curve: UIStyles.animationCurve,
//         padding: UIStyles.dropdownPadding,
//         decoration: UIStyles.dropdownDecoration,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.calendar_today, color: Colors.grey[700]),
//             SizedBox(width: 5),
//             Text(
//               DateFormat('dd - MMM - yyyy').format(selectedDate),
//               style: UIStyles.dateTextStyle,
//             ),
//             SizedBox(width: 5),
//             Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Employee/Configuration/ui_styles.dart';
import 'bottom_sheet_helper.dart';

class DatePickerDropdown extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedFirstIn;
  final String selectedLastOut;
  final String? checkInImage;
  final String? checkOutImage;
  final String? checkInLocation;
  final String? checkOutLocation;

  final Function(
    DateTime,
    String,
    String,
    String?,
    String?,
    String?,
    String?,
  ) onDateSelected;

  const DatePickerDropdown({
    Key? key,
    required this.selectedDate,
    required this.selectedFirstIn,
    required this.selectedLastOut,
    required this.checkInImage,
    required this.checkOutImage,
    required this.checkInLocation,
    required this.checkOutLocation,
    required this.onDateSelected,
  }) : super(key: key);

  void _handleDatePicked(BuildContext context) {
    showDatePickerBottomSheet(context, (
      DateTime newDate,
      String firstInTime,
      String lastOutTime,
      String? checkinImage,
      String? checkoutImage,
      String? inLocation,
      String? outLocation,
    ) {
      onDateSelected(
        newDate,
        firstInTime.isNotEmpty ? firstInTime : "N/A",
        lastOutTime.isNotEmpty ? lastOutTime : "N/A",
        checkinImage ?? "",
        checkoutImage ?? "",
        inLocation ?? "",
        outLocation ?? "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _handleDatePicked(context),
      child: AnimatedContainer(
        duration: UIStyles.animationDuration,
        curve: UIStyles.animationCurve,
        padding: UIStyles.dropdownPadding,
        decoration: UIStyles.dropdownDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[700]),
            SizedBox(width: 5),
            Text(
              DateFormat('dd - MMM - yyyy').format(selectedDate),
              style: UIStyles.dateTextStyle,
            ),
            SizedBox(width: 5),
            Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }
}

