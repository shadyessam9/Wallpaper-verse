import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallpaper_verse/subpages/category_list.dart';
import '../subpages/wallpaper_preview.dart';
import '../widgets/app_bar.dart';
import '../widgets/categories_container_widget.dart';
import '../widgets/container_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  List<dynamic> categories = [];
  List<dynamic> wallpapers = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/homepage.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> fetchedCategories = data['categories'];
        final List<dynamic> fetchedWallpapers = data['images'];

        setState(() {
          categories = fetchedCategories;
          wallpapers = fetchedWallpapers;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
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
        title: 'Home',
        isSettingsPage: false,
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories Section
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Text(
                            'CATEGORIES',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // 5 columns
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: categories.length,
                            physics: NeverScrollableScrollPhysics(), // Disable scrolling
                            shrinkWrap: true, // Allow the container to size itself
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryList(
                                        category_code: categories[index]['category_code'].toString(),
                                        category_name: categories[index]['category_name'],
                                      ),
                                    ),
                                  );
                                },
                                child: CategoriesContainerWidget(
                                  title: categories[index]['category_name'],
                                  imageUrl: categories[index]['category_cover_src'],
                                ),
                              );
                            },
                          ),
                  ),
                  ],
                ),
              ),
              // Discover Wallpapers Section
              Container(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Text(
                            'DISCOVER WALLPAPERS',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: isLoading
                        ? Padding(
                            padding: EdgeInsets.all(150),
                            child: CircularProgressIndicator(),
                          ) // Center the loading indicator
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height * 0.7),
                            ),
//                            itemCount: wallpapers.length + (wallpapers.length ~/ 2), // Adjusted item count
                              itemCount: wallpapers.length,
                            itemBuilder: (context, index) {
/*                              if ((index + 1) % 3 == 0 && index != 0) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: ContainerWidget(
                                    imageUrl: "https://wallpaperversaapp.000webhostapp.com/warehouse/images/ad.gif",
                                  ),
                                );
                              } else {*/
                                // Display wallpaper container
 //                               final wallpaperIndex = index - (index ~/ 3);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImagePreviewer(
                                            wallpaper_code: wallpapers[index]['wallpaper_code'].toString(),
                                          //  wallpaper_code: wallpapers[wallpaperIndex]['wallpaper_code'].toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ContainerWidget(
                                     imageUrl: wallpapers[index]['wallpaper_src'],
                                    ),
                                  ),
                                );
 //                           }
                            },
                          ),
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}