import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import '../widgets/app_bar.dart';

class ImageUploadPage extends StatefulWidget {
  final List<File>? imageFiles; // Change to List<File> type

  ImageUploadPage({Key? key, required this.imageFiles}) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Category 1';
  List<Map<String, dynamic>> _categories = [];

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(
          Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/getcategories.php'));

      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = json.decode(response.body);
        setState(() {
          _categories = categoriesJson.map((category) => {
            'code': category['category_code'],
            'name': category['category_name']
          }).toList();
          if (_categories.isNotEmpty) {
            _selectedCategory = _categories[0]['name'];
          }
        });
      } else {
        print('Failed to fetch categories');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> _uploadImage(File imageFile) async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String categoryCode = _categories
        .firstWhere((category) => category['name'] == _selectedCategory)['code']
        .toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(
        "https://wallpaperversaapp.000webhostapp.com/waapi/uploadwallpaper.php");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category'] = categoryCode;
    request.fields['authorcode'] = id!;

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
      return true; // Return true indicating success
    } else {
      print("Upload Failed");
      return false; // Return false indicating failure
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Single color for the page
      appBar: CustomAppBar(
        title: 'Upload Wallpaper',
        isSettingsPage: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.imageFiles != null) // Check for nullability
              Container(
                width: 300,
                height: 250,
                child: Image.file(
                  widget.imageFiles!.first, // Display the first image if available
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 50),
            TextFormField(
              controller: _titleController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Title', // Label text for the title text field
                labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white), // Set initial border color to white
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white), // Set focused border color to white
                ),
                suffixIcon: Icon(
                  Icons.title,
                  color: Colors.white, // Set icon color to white
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Description', // Label text for the description text field
                labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white), // Set initial border color to white
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white), // Set focused border color to white
                ),
                suffixIcon: Icon(
                  Icons.description,
                  color: Colors.white, // Set icon color to white
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['name'],
                  child: Text(category['name']),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(33, 33, 33, 1),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ),
              style: TextStyle(color: Colors.white),
              dropdownColor: Color.fromRGBO(33, 33, 33, 1),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(33, 33, 33, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
              ),
              onPressed: () async {
                if (widget.imageFiles != null && widget.imageFiles!.isNotEmpty) {
                  bool success = await _uploadImage(widget.imageFiles!.first); // Pass the first image for upload
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    // Handle failure if needed
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please select an image'),
                  ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
