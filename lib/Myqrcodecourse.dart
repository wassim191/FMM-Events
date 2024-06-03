import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui; // Add this import for ui.Image
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Myqrcodecourse extends StatefulWidget {
  final String qr;

  const Myqrcodecourse({super.key, required this.qr});

  @override
  State<Myqrcodecourse> createState() => _MyqrcodecourseState();
}

class _MyqrcodecourseState extends State<Myqrcodecourse> {
  double? _progress;

  // GlobalKey to access the RenderRepaintBoundary
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Qr Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: widget.qr.startsWith('data:image/png;base64,')
                      ? Image.memory(
                          base64Decode(widget.qr
                              .substring('data:image/png;base64,'.length)),
                          fit: BoxFit.fill,
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: _progress != null
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          // Call the _saveLocalImage or _saveNetworkImage method here
                          // For example:
                          _saveLocalImage();
                          //_saveNetworkImage();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          backgroundColor: const Color(0xFF8B1111),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Download Qr Code",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to save the image locally
// Method to save the image locally
  Future<void> _saveLocalImage() async {
    // Find the RenderRepaintBoundary associated with the global key
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the image as a ui.Image
    ui.Image image = await boundary.toImage();

    // Convert the image to ByteData (in PNG format)
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      // Convert ByteData to Uint8List and save the image
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result); // Print the result (path of the saved image)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Image Saved succesfully!'),
      ));
    }
  }

  Future<void> _saveNetworkImage() async {
    var response = await Dio()
        .get(widget.qr, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);
  }
}
