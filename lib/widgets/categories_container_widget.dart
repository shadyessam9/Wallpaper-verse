import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesContainerWidget extends StatelessWidget {
  final String imageUrl;

  const CategoriesContainerWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        height: 150, // Increased height for better content visibility
        width: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Circular border radius to create pill shape
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.lightBlue,
                    alignment: Alignment.center,
                    child: Text(
                      'Error',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade400,
                child: Container(color: Colors.white),
              ),
              Center(
                child: Text(
                  'Your Text Here',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
