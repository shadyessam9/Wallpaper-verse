import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_bar.dart';
import '../widgets/container_widget.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(
        title: 'Category',
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        physics: AlwaysScrollableScrollPhysics(), // Use AlwaysScrollableScrollPhysics for smoother and faster scrolling
        child: Column(
          children: [
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
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height * 0.7),
                      children: List.generate(snapshot.data!.docs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ContainerWidget(
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
            )
          ],
        )
      ),
    );
  }
}
