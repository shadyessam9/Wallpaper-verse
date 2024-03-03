import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../subpages/upload_wallpaper.dart';
import '../subpages/wallpaper_preview.dart';
import '../widgets/app_bar.dart';
import '../widgets/container_widget.dart'; // Import the ImageUploadPage
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<File?> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }


     @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(
          title: 'My Syudio', isSettingsPage: false
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
              )
            ),
          ],
        ),
      ),
      floatingActionButton:Padding(
        padding: EdgeInsets.all(16.0), // Adjust the padding as needed
        child: FloatingActionButton(
          onPressed: () async {
            File? selectedImage = await _getImage();
            if (selectedImage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageUploadPage(imageFile: selectedImage),
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
