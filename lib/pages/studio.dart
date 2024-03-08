import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../subpages/upload_wallpaper.dart';
import '../subpages/wallpaper_preview.dart';
import '../widgets/app_bar.dart';
import '../widgets/container_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudioPage extends StatefulWidget {
  const StudioPage({Key? key}) : super(key: key);

  @override
  State<StudioPage> createState() => _StudioPage();
}

class _StudioPage extends State<StudioPage> {
  final picker = ImagePicker();
  List<dynamic> wallpapers = [];

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');

    try {
      final response = await http.get(Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/userstudio.php?author_code=${id}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          wallpapers = data;
        });
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<File>?> _getImages() async {
    List<File>? selectedImages = [];
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5, // Maximum number of images to pick
        enableCamera: true, // Enable camera option
        selectedAssets: [], // Initially selected assets (empty in this case)
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: "#FFC107", // Customize selection fill color for iOS
          selectionTextColor: "#000000", // Customize selection text color for iOS
          selectionCharacter: "✓", // Customize selection character for iOS
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#FFC107", // Customize action bar color for Android
          actionBarTitle: "Select Images", // Customize action bar title for Android
          allViewTitle: "All Images", // Customize all view title for Android
          useDetailsView: false, // Show/hide details view for Android
          selectCircleStrokeColor: "#000000", // Customize select circle stroke color for Android
        ),
      );

      for (var asset in resultList) {
        final byteData = await asset.getByteData();
        final buffer = byteData!.buffer;
        final tempFile = await File('${(await getTemporaryDirectory()).path}/${asset.name}').writeAsBytes(buffer.asUint8List());
        selectedImages.add(tempFile);
      }
    } catch (e) {
      print('Error selecting images: $e');
    }

    return selectedImages.isNotEmpty ? selectedImages : null;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Studio',
        isSettingsPage: false,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height * 0.7),
                children: List.generate(wallpapers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePreviewer(
                              wallpaper_code: wallpapers[index]['wallpaper_code'].toString(),
                            ),
                          ),
                        );
                      },
                      child: ContainerWidget(
                        imageUrl: wallpapers[index]['wallpaper_src'],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () async {
            List<File>? selectedImages = await _getImages();
            if (selectedImages != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageUploadPage(imageFiles: selectedImages),
                ),
              );
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
