import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:employe_manage/Configuration/style.dart';
import 'package:get/get.dart';
import '../Widgets/Assets_List.dart'; // Import the asset list file
import '../Widgets/CustomListTile.dart';
import '/Widgets/App_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const Assetspage(title: 'Assets'),
    );
  }
}

class Assetspage extends StatefulWidget {
  const Assetspage({super.key, required this.title});

  final String title;

  @override
  State<Assetspage> createState() => _AssetspageState();
}

class _AssetspageState extends State<Assetspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Assets'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: assetsList.length,
          itemBuilder: (context, index) {
            final asset = assetsList[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: SvgPicture.asset(
                  asset["icon"],
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  asset["title"],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset["subtitle"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(asset["sub2"], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(asset["size"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
