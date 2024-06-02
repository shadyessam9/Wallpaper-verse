import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class ImagePreviewer extends StatefulWidget {
  final String wallpaper_code;

  const ImagePreviewer({
    Key? key,
    required this.wallpaper_code,
  }) : super(key: key);

  @override
  State<ImagePreviewer> createState() => _ImagePreviewerState();
}

class _ImagePreviewerState extends State<ImagePreviewer> {
  late Map<String, dynamic> imageData;
  bool isWallpaperSaved = false;
  bool isFavorite = false;
  int downloadCounter = 0; // Counter for download button presses

  @override
  void initState() {
    super.initState();
    imageData = {};
    checkFavoriteLocally();
    //  loadDownloadCounter();
  }

  Future<Map<String, dynamic>> fetchImageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');

    try {
      final response = await http.get(Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/wallpaperpreview.php?wallpaper_code=${widget.wallpaper_code}&&user_code=${id}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load image data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image data: $e');
      rethrow; // Rethrow the exception to notify FutureBuilder
    }
  }

  Future<void> checkFavoriteLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isFavorite = prefs.getBool(widget.wallpaper_code) ?? false;
      });
    } catch (e) {
      print('Error checking favorite locally: $e');
    }
  }

  Future<void> setWallpaper(int location) async {
    try {
      String url = imageData['wallpaper_src'] ?? '';
      var response = await http.get(Uri.parse(url));
      Uint8List bytes = response.bodyBytes;

      // Save the image bytes to a file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/wallpaper.jpg';
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Set wallpaper from the saved file
      final bool result = await WallpaperManager.setWallpaperFromFile(filePath, location);
      if (result) {
        Fluttertoast.showToast(msg: 'Wallpaper set successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to set wallpaper');
      }
    } catch (e) {
      print('Error setting wallpaper: $e');
      Fluttertoast.showToast(msg: 'Failed to set wallpaper');
    }
  }

  void toggleFavorite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('id');

      if (isFavorite) {
        // If already marked as favorite, remove from favorites
        final response = await http.get(Uri.parse(
            'https://wallpaperversaapp.000webhostapp.com/waapi/removefavorite.php?wallpaper_code=${widget.wallpaper_code}&user_code=${id}'));

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: 'removed from favorites');
          setState(() {
            isFavorite = false;
          });
          // Update local storage
          prefs.setBool(widget.wallpaper_code, false);
        } else {
          Fluttertoast.showToast(msg: 'Failed to remove from favorites.');
        }
      } else {
        // If not marked as favorite, add to favorites
        final response = await http.get(Uri.parse(
            'https://wallpaperversaapp.000webhostapp.com/waapi/addfavorite.php?wallpaper_code=${widget.wallpaper_code}&user_code=${id}'));

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: 'added to favorites successfully.');
          setState(() {
            isFavorite = true;
          });
          // Update local storage
          prefs.setBool(widget.wallpaper_code, true);
        } else {
          Fluttertoast.showToast(msg: 'Failed to add image to favorites.');
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

 /* void loadDownloadCounter() async {
    // Load download counter from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      downloadCounter = prefs.getInt('downloadCounter') ?? 0;
    });
  }*/

/*
  void saveDownloadCounter(int count) async {
    // Save download counter to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('downloadCounter', count);
  }
*/

 /* Future<void> showAdPopup() async {
    // Show a pop-up window with a text ad
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ad Title"),
          content: Text("Ad Content"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }*/

  void handleDownloadButtonPressed() async {
 /*   downloadCounter++;
    if (downloadCounter % 5 == 0) {
      // Show the ad pop-up window
      await showAdPopup();
    }
    saveDownloadCounter(downloadCounter);*/

    try {
      final response = await http.get(Uri.parse(imageData['wallpaper_src'] ?? ''));
      final bytes = response.bodyBytes;

      // Save image to gallery
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
      if (result['isSuccess']) {
        Fluttertoast.showToast(msg: 'Image saved to gallery');
      } else {
        Fluttertoast.showToast(msg: 'Failed to save image to gallery');
      }
    } catch (e) {
      print('Error downloading image: $e');
      Fluttertoast.showToast(msg: 'Failed to download image');
    }
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchImageData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          imageData = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_circle_left,size: 40),
                            color: Colors.white,
                          ),
                          // You can add more widgets here as needed
                        ]
                    )
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(imageData['wallpaper_src'] ?? ''),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          imageData['title'] ?? 'Title',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          imageData['description'] ?? 'Description',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: toggleFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Show pop-up menu
                            showMenu(
                              context: context,
                              color: Color.fromRGBO(33, 33, 33, 1),
                              position: RelativeRect.fromLTRB(100, 100, 0, 0), // Adjust position as needed
                              items: <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: Text("Set as Home Screen",style: TextStyle(color: Colors.white)),
                                  value: WallpaperManager.HOME_SCREEN,
                                ),
                                PopupMenuItem(
                                  child: Text("Set as Lock Screen",style: TextStyle(color: Colors.white)),
                                  value: WallpaperManager.LOCK_SCREEN,
                                ),
                                PopupMenuItem(
                                  child: Text("Set as Both",style: TextStyle(color: Colors.white)),
                                  value: WallpaperManager.BOTH_SCREEN,
                                ),
                                PopupMenuItem(
                                  child: Text("Dialpad",style: TextStyle(color: Colors.white)),
                                  onTap: () async {
                                       try {
                                          final response = await http.get(Uri.parse(imageData['wallpaper_src'] ?? ''));
                                          final bytes = response.bodyBytes;

                                          // Save the image bytes to a temporary file
                                          final directory = await getTemporaryDirectory();
                                          final filePath = '${directory.path}/wallpaper.jpg';
                                          File imageFile = File(filePath);
                                          await imageFile.writeAsBytes(bytes);

                                          // Save the image path to SharedPreferences
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          await prefs.setString('backgroundImagePath', filePath);

                                        } catch (e) {
                                          print('Error downloading image: $e');
                                          Fluttertoast.showToast(msg: 'Failed to download image');
                                        }

                                  },
                                ),
                              ],
                            ).then((selectedValue) {
                              // Handle selected value
                              if (selectedValue != null) {
                                // Set wallpaper based on selected value
                                setWallpaper(selectedValue);
                              }
                            });
                          },
                          icon: Icon(Icons.send_to_mobile_rounded),
                          color: Colors.white,
                        ),
                        GestureDetector(
                          onTap: handleDownloadButtonPressed,
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Download',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
