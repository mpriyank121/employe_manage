import 'package:flutter/material.dart';

class fontStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'Roboto',
  );

  static const TextStyle subTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Color(0xFF949494),
    fontFamily: 'Roboto',
  );
  static const TextStyle commonTextStyle = TextStyle(
    color: Color(0xFF666666),
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1,
  );
  static const TextStyle normalText = TextStyle(
    color: Color(0xFF212121),
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    height: 1.60,
  );
  static const whiteText = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );


}

//Customrow
class CustomRow extends StatelessWidget {
  final List<Widget> items;

  const CustomRow({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly distributes columns

      children: items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: item,
      )).toList(),
    );
  }
}
//LeaveCard

class AppStyles {
  static const TextStyle textStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
}
