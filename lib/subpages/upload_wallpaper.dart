import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageUploadPage extends StatefulWidget {
  final File? imageFile;

  ImageUploadPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Category 1';

  Future<void> _uploadImage(File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());

    Map<String, String> requestBody = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'category': "1",
      'image': base64Image,
      'authorcode': "1"
    };

    Uri apiUrl = Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/uploadwallpaper.php');
    try {
      final response = await http.post(
        apiUrl,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.imageFile != null)
              Container(
                width: 300,
                height: 250,
                child: Image.file(
                  widget.imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>['Category 1', 'Category 2', 'Category 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.imageFile != null) {
                  _uploadImage(widget.imageFile!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please select an image'),
                  ));
                }
              },
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
