import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../subpages/upload_wallpaper.dart';
import 'dart:io';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function(String)? onAccountSelected;
  final bool isSettingsPage;

  CustomAppBar({
    Key? key,
    required this.title,
    this.onAccountSelected,
    required this.isSettingsPage,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String name = '';
  late String email = '';
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

Future<void> fetchUserData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');

    final url = 'https://wallpaperversaapp.000webhostapp.com/waapi/userprofile.php?user_id=${id}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        name = responseData['user_data']['user_name'];
        email = responseData['user_data']['user_email'];
      });
    } else {
      // Handle error
      print('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}

Future<void> deleteAllPreferences() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  } catch (e) {
    print('Error deleting preferences: $e');
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
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color.fromRGBO(33, 33, 33, 1),
      actions: widget.isSettingsPage ? [] : _buildActions(context),
    );
  }

List<Widget> _buildActions(BuildContext context) {
  return [
    PopupMenuButton<String>(
      offset: Offset(0, 40),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            enabled: false,
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('$name', style: TextStyle(color: Colors.white)),
            ),
          ),
          PopupMenuItem(
            enabled: false,
            child: ListTile(
              leading: Icon(Icons.email, color: Colors.white),
              title: Text('$email', style: TextStyle(color: Colors.white)),
            ),
          ),
          PopupMenuItem(
            enabled: false,
            child: ListTile(
              title: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          PopupMenuItem(
            enabled: false,
            child: ListTile(
              title: ElevatedButton(
              onPressed: () {
                    deleteAllPreferences();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // Close the app
                  },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          PopupMenuItem(
            enabled: false,
            child: ListTile(
              title: Column(
                children: [
                  Text('X wallpaper auto ®', style: TextStyle(fontSize: 10, color: Colors.white)),
                  Text('Version 1.0', style: TextStyle(fontSize: 10, color: Colors.white))
                ],
              ),
            ),
          ),
        ];
      },
      icon: Icon(Icons.account_circle, color: Colors.white),
      color: Colors.grey[900],
      onSelected: widget.onAccountSelected,
    ),
  ];
}
}

