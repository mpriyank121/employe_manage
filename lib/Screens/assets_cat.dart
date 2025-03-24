import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:employe_manage/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../API/Services/assets_service.dart';

class Assetspage extends StatefulWidget {
  final String empId; // ✅ Pass Dynamic empId
  final String title;

  const Assetspage({Key? key,required this.empId, required this.title}) : super(key: key);

  @override
  _AssetspageState createState() => _AssetspageState();
}

class _AssetspageState extends State<Assetspage> {
  final AssetService assetService = AssetService();
  late Future<List<Map<String, dynamic>>> assetFuture;

  @override
  void initState() {
    super.initState();
    assetFuture = assetService.fetchAssets(widget.empId); // ✅ Fetch assets dynamically
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Assets",),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: assetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No assets found"));
          }

          var assets = snapshot.data!;

          return ListView.builder(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              var asset = assets[index];

              return
                CustomListTile(
                  leading: Image.network(asset['Image'], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(asset['asset_name'] ?? 'No Asset Name'),
                  subtitle: Text('Assigned By: ${asset['assigned_by'] ?? 'Unknown'}'),
                  trailing: Text('#${asset['unique_serial_no']}'),
                );

            },
          );
        },
      ),
    );
  }
}
