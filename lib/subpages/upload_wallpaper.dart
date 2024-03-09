import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/app_bar.dart';

class ImageUploadPage extends StatefulWidget {
  final List<File>? imageFiles;

  ImageUploadPage({Key? key, required this.imageFiles}) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  List<TextEditingController> _titleControllers = [];
  List<TextEditingController> _descriptionControllers = [];
  List<String?> _selectedCategories = [];
  List<List<Map<String, dynamic>>> _categories = [];
  bool _isLoading = true; // Add a boolean to track loading state

  Future<void> _fetchCategories() async {
    // Set loading state to true when starting to fetch categories
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/getcategories.php'));

      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = json.decode(response.body);
        setState(() {
          _categories = List.generate(widget.imageFiles!.length, (index) {
            return categoriesJson.map((category) => {
              'code': category['category_code'],
              'name': category['category_name']
            }).toList();
          });
          _selectedCategories = List.generate(widget.imageFiles!.length, (index) {
            return _categories[index].isNotEmpty ? _categories[index][0]['name'] : null;
          });
        });
      } else {
        print('Failed to fetch categories');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      // Set loading state to false when fetching is done
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _titleControllers = List.generate(widget.imageFiles!.length, (index) => TextEditingController());
    _descriptionControllers = List.generate(widget.imageFiles!.length, (index) => TextEditingController());
  }

  Future<bool> _uploadImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');

    try {
      for (int i = 0; i < widget.imageFiles!.length; i++) {
        File imageFile = widget.imageFiles![i];
        String title = _titleControllers[i].text;
        String description = _descriptionControllers[i].text;
        String categoryCode = _categories[i]
            .firstWhere((category) => category['name'] == _selectedCategories[i])['code']
            .toString();

        var uri = Uri.parse("https://wallpaperversaapp.000webhostapp.com/waapi/uploadwallpaper.php");

        var request = http.MultipartRequest("POST", uri);

        // Set necessary headers
        request.headers['Content-Type'] = 'multipart/form-data';

        // Add image file to the request
        request.files.add(http.MultipartFile(
          'images[]',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: basename(imageFile.path),
        ));

        // Add other fields to the request
        request.fields['titles[]'] = title;
        request.fields['descriptions[]'] = description;
        request.fields['categories[]'] = categoryCode;
        request.fields['authorcode'] = id!;

        var response = await request.send();
        if (response.statusCode != 200) {
          print("Upload Failed");
          // Read response body to get the reason for failure
          String responseBody = await response.stream.bytesToString();
          print("Reason: $responseBody");
          return false; // Return false indicating failure
        }
      }

      print("All Images Uploaded");
      return true; // Return true indicating success
    } catch (e) {
      print("Error uploading images: $e");
      return false; // Return false indicating failure
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Display a loading indicator while fetching categories
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Build your widget when categories are fetched
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBar(
          title: 'Upload Wallpaper',
          isSettingsPage: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(widget.imageFiles!.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.imageFiles != null && widget.imageFiles!.isNotEmpty)
                      Container(
                        width: 300,
                        height: 250,
                        child: Image.file(
                          widget.imageFiles![index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(height: 50),
                    TextFormField(
                      controller: _titleControllers[index],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIcon: Icon(
                          Icons.title,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionControllers[index],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIcon: Icon(
                          Icons.description,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedCategories[index],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategories[index] = newValue!;
                        });
                      },
                      items: _categories[index].map<DropdownMenuItem<String>>((category) {
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
                    SizedBox(height: 50),
                  ],
                );
              }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ProgressDialog(); // Show loading indicator dialog
              },
            );

            bool success = await _uploadImages();

            Navigator.pop(context); // Dismiss loading indicator dialog

            if (success) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(33, 33, 33, 1),
                    title: Text('Success', style: TextStyle(color: Colors.white)),
                    content: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'Operation completed successfully.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: Text('OK', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(33, 33, 33, 1),
                    title: Text('Failed', style: TextStyle(color: Colors.white)),
                    content: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'Failed to upload images, Please try Again',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            }
          },
          label: Text('Upload'),
          icon: Icon(Icons.upload),
        ),
      );
    }
  }
}

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(33, 33, 33, 1),
      content: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Uploading Images...", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
