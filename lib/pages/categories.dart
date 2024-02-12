import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_verse/theme/model.dart';
import 'package:wallpaper_verse/widgets/item_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_bar.dart';
import '../widgets/categories_container_widget.dart';
import '../widgets/color_container_widget.dart';
import '../widgets/container_widget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Color> colors = List.generate(100, (index) {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(
      title: 'Categories',
    ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        physics: AlwaysScrollableScrollPhysics(), // Use AlwaysScrollableScrollPhysics for smoother and faster scrolling
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                          'COLORS',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        return ColorContainerWidget(
                          color: colors[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                          'Categories',
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('All wallpapers').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(), // Use AlwaysScrollableScrollPhysics for smoother and faster scrolling
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: List.generate(snapshot.data!.docs.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: CategoriesContainerWidget(
                                  imageUrl: snapshot.data!.docs[index]['imageUrl'],
                                ),
                              );
                            }),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
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
}
