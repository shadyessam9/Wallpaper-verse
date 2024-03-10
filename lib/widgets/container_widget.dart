import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContainerWidget extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;

  const ContainerWidget({
    Key? key,
    this.imageUrl,
    this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: SizedBox(
        height: 150,
        width: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 200,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade400,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 200,
                      color: Colors.lightBlue,
                      alignment: Alignment.center,
                      child: Icon(Icons.error),
                    );
                  },
                )
              : imageFile != null
                  ? Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey, // Placeholder color if no image is provided
                    ),
        ),
      ),
    );
  }
}
