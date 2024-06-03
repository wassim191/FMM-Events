import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/rendering.dart';

import 'dart:typed_data';
import 'dart:ui' as ui; // Add this import for ui.Image
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Skippayement extends StatefulWidget {
  final String qr;
  const Skippayement({super.key, required this.qr});

  @override
  State<Skippayement> createState() => _SkippayementState();
}

class _SkippayementState extends State<Skippayement> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("This is your Qr Code ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(
                height: 15,
              ),
              const Center(
                child: Text(
                  "Please Take Screen Shot or Download the Qrcode To Show it to the admin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              RepaintBoundary(
                key: _globalKey,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: widget.qr.startsWith('data:image/png;base64,')
                      ? Image.memory(
                          base64Decode(widget.qr
                              .substring('data:image/png;base64,'.length)),
                          fit: BoxFit.fill,
                        )
                      : const CircularProgressIndicator(), // Show a loader while image is loading
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveLocalImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Image Saved succesfully!'),
      ));
    }
  }
}
