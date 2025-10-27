import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String assetPath;

  PdfViewerPage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.getWidth(context)*0.04,
                vertical: ScreenSize.getHeight(context)*0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 32),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      Text(
                          "Resources",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenSize.getWidth(context)*0.065)
                      ),

                      SizedBox(width: ScreenSize.getWidth(context) * 0.12),
                    ],
                  ),

                  SizedBox(height: ScreenSize.getHeight(context) * 0.01),
                  // PDF Viewer
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [ // ADDED BOX SHADOW HERE
                            const BoxShadow(
                              color: Colors.black26, // A subtle dark color
                              blurRadius: 15.0, // Soften the edges
                              spreadRadius: 0.0, // Do not spread
                              offset: Offset(0, 8), // Move the shadow down
                            ),
                          ],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SfPdfViewer.asset(assetPath)
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
