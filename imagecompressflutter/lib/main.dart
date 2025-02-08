import 'package:flutter/material.dart';
import 'package:imagecompressflutter/pages/imageCompressFlutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image Compress',

      home:  ImageCompressionPage(),
    );
  }
}
