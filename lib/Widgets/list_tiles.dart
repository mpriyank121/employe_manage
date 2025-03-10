import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Configuration/config_file.dart';

class DocumentListTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const DocumentListTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: const Color(0x193CAB88),
        child: SvgPicture.asset(
          item['icon'],
          width: 30,
          height: 30,
        ),
      ),
      title: Text(item['title'], style: TileConfig.headingStyle),
      trailing: IconButton(
        icon: SvgPicture.asset(
          "assets/images/solar_download-linear.svg",
          width: MediaQuery.of(context).size.width * 0.08,  // 8% of screen width
          height: MediaQuery.of(context).size.height * 0.04,  // 4% of screen height
        ),
        onPressed: () {
          print("Download ${item['title']}");
        },
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(item['subtitle'], style: TileConfig.subTextStyle),
      ),
    );
  }
}
