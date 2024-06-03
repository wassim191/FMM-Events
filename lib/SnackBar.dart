import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CustomSnackbar {
  static void showCustomSnackbar(BuildContext context, String title,
      String message, ContentType contentType,
      {Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0, // No shadow
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.fixed,
        content: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.transparent, // Semi-transparent grey background
              width: double.infinity,
              height: 140, // Reduce height to make the snackbar smaller
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AwesomeSnackbarContent(
                    title: title,
                    message: message,
                    contentType: contentType,
                    // Reduce font size for the message
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: duration, // Set the duration for the snackbar
      ),
    );
  }
}
