import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../subpages/user_image_preview.dart';
import '../widgets/app_bar.dart';
import '../widgets/container_widget.dart';
import '../subpages/upload_wallpaper.dart';
import '../subpages/wallpaper_preview.dart';

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
      final response = await http.get(Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/usergallery.php?user_code=${id}'));

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
    final picker = ImagePicker();

    try {
      final pickedFiles = await picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      for (final pickedFile in pickedFiles) {
        final File file = File(pickedFile.path);
        selectedImages.add(file);
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
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
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
                            builder: (context) => UserImagePreviewer(
                              wallpaper_src: wallpapers[index]['wallpaper_src'].toString(),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
             heroTag: 'unique_tag_1', // Set a unique hero tag for each FloatingActionButton
            onPressed: () async {
              List<File>? selectedImages = await _getImages();
              if (selectedImages != null) {
                try {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? id = prefs.getString('id');

                  var request = http.MultipartRequest(
                    'POST',
                    Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/usergalleryupload.php'),
                  );

                  for (var image in selectedImages) {
                    request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
                  }
                  request.fields['usercode'] = id!;

                  var response = await request.send();

                  if (response.statusCode == 200) {

                  } else {
                    print('Failed to upload images. Status code: ${response.statusCode}');
                  }
                } catch (e) {
                  print('Error uploading images: $e');
                }
              }
            },
            child: Icon(Icons.add)
          ),
          SizedBox(height: 15),
          FloatingActionButton(
             heroTag: 'unique_tag_2', // Set a unique hero tag for each FloatingActionButton
            onPressed: fetchData,
            child: Icon(Icons.refresh)
          ),
        ],
      ),
    );
  }
}
