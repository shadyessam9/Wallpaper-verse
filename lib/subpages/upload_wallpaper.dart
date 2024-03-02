import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";
import 'package:path/path.dart';

import '../widgets/app_bar.dart';

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

    // ignore: deprecated_member_use
            var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
            var length= await imageFile.length();
            var uri = Uri.parse("https://wallpaperversaapp.000webhostapp.com/waapi/uploadwallpaper.php");

            var request = new http.MultipartRequest("POST", uri);

            var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));

            request.files.add(multipartFile);
            request.fields['title'] = "a";
            request.fields['description'] = "b";
            request.fields['category'] = "1";
            request.fields['authorcode'] = "1";

            var respond = await request.send();
            if(respond.statusCode==200){
              print("Image Uploaded");
            }else{
              print("Upload Failed");
            }

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
