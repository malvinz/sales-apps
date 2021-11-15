import 'dart:io';
import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  static const routeName = '\CameraScreen';
  final List<File> images;
  GalleryScreen(this.images);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: images.map((image) => Image.file(image, fit: BoxFit.cover)).toList(),
      ),
    );
  }
}