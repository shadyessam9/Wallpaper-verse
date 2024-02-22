import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../subpages/upload_wallpaper.dart';
import '../widgets/app_bar.dart';
import '../widgets/container_widget.dart'; // Import the ImageUploadPage

class StudioPage extends StatefulWidget {
  const StudioPage({Key? key}) : super(key: key);

  @override
  State<StudioPage> createState() => _StudioPage();
}

class _StudioPage extends State<StudioPage> {
  final picker = ImagePicker();

  Future<File?> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('All wallpapers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height * 0.7),
                      children: List.generate(snapshot.data!.docs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ContainerWidget(
                            imageUrl: snapshot.data!.docs[index]['imageUrl'],
                          ),
                        );
                      }),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
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
