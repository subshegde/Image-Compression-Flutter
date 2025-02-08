import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageCompressionPage extends StatefulWidget {
  @override
  _ImageCompressionPageState createState() => _ImageCompressionPageState();
}

class _ImageCompressionPageState extends State<ImageCompressionPage> {
  File? _imageFile;
  String _compressedImagePath = '';
  String _originalImageSize = '';
  String _compressedImageSize = '';

  // Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _originalImageSize = _bytesToMB(_imageFile!.lengthSync()) + " MB";
      });

      await _compressImage(_imageFile!);
    }
  }

  // Convert bytes to MB
  String _bytesToMB(int bytes) {
    double mb = bytes / (1024 * 1024); // bytes to MB
    return mb.toStringAsFixed(2); // 2 decimal places
  }

  // Compress image
  Future<void> _compressImage(File image) async {
    final result = await FlutterImageCompress.compressWithFile(
      image.path,
      minWidth: 500,
      minHeight: 500,
      quality: 88,
    );

    if (result != null) {
      final compressedImageFile = File('${image.path}_compressed.jpg');
      compressedImageFile.writeAsBytesSync(result);
      
      setState(() {
        _compressedImagePath = compressedImageFile.path;
        _compressedImageSize = _bytesToMB(compressedImageFile.lengthSync()) + " MB";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Image Compression Demo', style: TextStyle(color: Colors.white, fontSize: 19)),
        backgroundColor: Colors.grey[850],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  const SizedBox(height: 100),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_imageFile != null) ...[
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _imageFile!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Original Image Size:\n$_originalImageSize',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 10,),
                      const Divider(),
                      const SizedBox(height: 10,),
                      if (_compressedImagePath.isNotEmpty) ...[
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_compressedImagePath),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Compressed Image Size:\n$_compressedImageSize',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
