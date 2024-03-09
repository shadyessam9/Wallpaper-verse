import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/app_bar.dart';
import '../widgets/container_widget.dart';
import 'wallpaper_preview.dart'; // Assuming this import is correct

class CategoryList extends StatefulWidget {
  final String category_code;
  final String category_name;
  const CategoryList({Key? key, required this.category_code , required this.category_name}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList> {
  List<dynamic> wallpapers = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/categorylist.php?category_code=${widget.category_code}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          wallpapers = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
      title: '${widget.category_name}', isSettingsPage: false
    ),
    backgroundColor: Colors.black,
    body: Center(
      child: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (wallpapers.isEmpty)
                    Text(
                      'No Wallpapers Added Yet',
                      style: TextStyle(color: Colors.white),
                    )
                  else
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
                      ),
                    )
                ],
              ),
            ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        fetchData();
      },
      child: Icon(Icons.refresh),
    ),
  );
}
}