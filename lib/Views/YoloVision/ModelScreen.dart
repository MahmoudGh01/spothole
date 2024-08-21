import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';

import 'YoloImage.dart';
import 'YoloImageSeg.dart';
import 'YoloVideo.dart';
// Import your YoloImageV8 widget

class ModelScreen extends StatefulWidget {
  const ModelScreen({Key? key}) : super(key: key);

  @override
  _ModelScreenState createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.video_camera_back), text: 'YOLO Video'),
              Tab(icon: Icon(Icons.image), text: 'YOLO Image'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            YoloVideo(), // Your YoloVideo Widget
            YoloImageV8(), // Your YoloImageV8 Widget
          ],
        ),
      ),
    );
  }
}
