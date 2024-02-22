import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class ImageUploadPage extends StatefulWidget {
  final File? imageFile;

  ImageUploadPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  static const List<String> _list1 = ['Favorites', 'Random'];
  File? _imageFile;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Category 1';

  @override
  void initState() {
    super.initState();
    _imageFile = widget.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text(
          'Upload Image',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null)
              Column(
                children: [
                  Container(
                    width: 300, // Set your desired width
                    height: 250, // Set your desired height
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover, // Make the image fit within the container
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _titleController,
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
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(color: Colors.white),
                    maxLines: 5,
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
                    ),
                  ),
                  SizedBox(height: 16.0),
                  CustomDropdown<String>(
                    items: _list1,
                    hintText: 'Select Category',
                    closedHeaderPadding: const EdgeInsets.all(15),
                    maxlines: 2,
                    listItemBuilder: (context, item, isSelected, onItemSelect) {
                      return Text(
                        item.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      );
                    },
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Color.fromRGBO(33, 33, 33, 1),
                      expandedFillColor: Color.fromRGBO(33, 33, 33, 1),
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      headerStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      noResultFoundStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      closedSuffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      expandedSuffixIcon: const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                      ),
                    ),
                    onChanged: (String) {},
                  ),
                  SizedBox(height: 16.0),
                 Row(
                   children: [
                     ElevatedButton(
                         onPressed: () {
                           // Handle image upload here
                           if (_imageFile != null) {
                             // Encode the image to base64 if needed
                             String base64Image = base64Encode(_imageFile!.readAsBytesSync());

                             // Perform the upload operation with the image data and other details
                             // Upload logic goes here
                           } else {
                             // Show an error message if no image is selected
                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Text('Error'),
                                   content: Text('Please select an image.'),
                                   actions: [
                                     TextButton(
                                       onPressed: () {
                                         Navigator.of(context).pop();
                                       },
                                       child: Text('OK'),
                                     ),
                                   ],
                                 );
                               },
                             );
                           }
                         },style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.green,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       elevation: 10,
                     ),
                         child: Padding(
                           padding: const EdgeInsets.all(10),
                           child: Text(
                             'Update',
                             style: TextStyle(fontSize: 16,color: Colors.white),
                           ),
                         )
                     ), ElevatedButton(
                         onPressed: () {
                           // Handle image upload here
                           if (_imageFile != null) {
                             // Encode the image to base64 if needed
                             String base64Image = base64Encode(_imageFile!.readAsBytesSync());

                             // Perform the upload operation with the image data and other details
                             // Upload logic goes here
                           } else {
                             // Show an error message if no image is selected
                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Text('Error'),
                                   content: Text('Please select an image.'),
                                   actions: [
                                     TextButton(
                                       onPressed: () {
                                         Navigator.of(context).pop();
                                       },
                                       child: Text('OK'),
                                     ),
                                   ],
                                 );
                               },
                             );
                           }
                         },style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.red,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       elevation: 10,
                     ),
                         child: Padding(
                           padding: const EdgeInsets.all(10),
                           child: Text(
                             'Delete',
                             style: TextStyle(fontSize: 16,color: Colors.white),
                           ),
                         )
                     ),
                   ]
                 )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
