import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomListTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const CustomListTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE6E6E6)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ListTile(
        leading: SvgPicture.asset(item['icon'],width: MediaQuery.of(context).size.width * 0.08,  // 8% of screen width
          height: MediaQuery.of(context).size.height * 0.04,),
        title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(item['subtitle'], style: const TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
