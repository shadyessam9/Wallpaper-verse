import 'package:flutter/material.dart';
import '../subpages/wallpaper_preview.dart';
import '../widgets/app_bar.dart';
import '../widgets/container_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPage();
}

class _FavoritesPage extends State<FavoritesPage> {
   List<dynamic> wallpapers = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://wallpaperversaapp.000webhostapp.com/waapi/userfavorites.php?user_code=1'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          wallpapers = data;
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
      appBar:CustomAppBar(
        title: 'My Favorites', isSettingsPage: false
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        physics: AlwaysScrollableScrollPhysics(), // Use AlwaysScrollableScrollPhysics for smoother and faster scrolling
        child: Column(
          children: [
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
        )
      ),
    );
  }
}
