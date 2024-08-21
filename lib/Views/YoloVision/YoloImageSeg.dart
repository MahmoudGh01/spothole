import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../Services/painter.dart';
import '../job_gloabelclass/job_color.dart';
import '../job_gloabelclass/job_fontstyle.dart';
import '../job_pages/job_theme/job_themecontroller.dart';
class YoloImageV8Seg extends StatefulWidget {
  const YoloImageV8Seg({Key? key}) : super(key: key);

  @override
  State<YoloImageV8Seg> createState() => _YoloImageV8SegState();
}

class _YoloImageV8SegState extends State<YoloImageV8Seg> {
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  late FlutterVision vision;

  @override
  void initState() {
    super.initState();
    if (Platform.operatingSystem == 'android') {
      vision = FlutterVision();
    }
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() async {
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    if (!isLoaded) {
      return Scaffold(
        body: Center(
          child: LottieBuilder.asset('assets/loading_animation.json'),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        imageFile != null ? Image.file(imageFile!) : const SizedBox(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 36, vertical: height / 56),
            child: Row(
              children: [
                InkWell(
                  splashColor: JobColor.transparent,
                  highlightColor: JobColor.transparent,
                  onTap: () {
                    pickImage();

                  },
                  child: Container(
                    height: height / 15,
                    width: width / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: JobColor.lightblue,
                    ),
                    child: Center(
                      child: Text("Pick Image".tr,
                          style: urbanistSemiBold.copyWith(
                              fontSize: 16, color: JobColor.appcolor)),
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  splashColor: JobColor.transparent,
                  highlightColor: JobColor.transparent,
                  onTap: () async {
                    yoloOnImage();
                  },
                  child: Container(
                    height: height / 15,
                    width: width / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: JobColor.appcolor,
                    ),
                    child: Center(
                      child: Text("Detect".tr,
                          style: urbanistSemiBold.copyWith(
                              fontSize: 16, color: JobColor.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/models/best_float32.tflite',
        modelVersion: "yolov8seg",
        quantization: false,
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  yoloOnImage() async {
    yoloResults.clear();
    Uint8List byte = await imageFile!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;
    final result = await vision.yoloOnImage(
        bytesList: byte,
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.8,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (imageWidth);
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imageHeight);

    double pady = ((screen.height - 56.0) - newHeight) / 2;

    //Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    Color colorPick = Colors.transparent;
    return yoloResults.map((result) {
      return Stack(children: [
        Positioned(
          left: result["box"][0] * factorX,
          top: result["box"][1] * factorY + pady,
          width: (result["box"][2] - result["box"][0]) * factorX,
          height: (result["box"][3] - result["box"][1]) * factorY,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Colors.transparent, width: 2.0),
            ),
            child: Text(
              "${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()..color = colorPick,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY + pady,
            width: (result["box"][2] - result["box"][0]) * factorX,
            height: (result["box"][3] - result["box"][1]) * factorY,
            child: CustomPaint(
              painter: PolygonPainter(
                  points: (result["polygons"] as List<dynamic>).map((e) {
                    Map<String, double> xy = Map<String, double>.from(e);
                    xy['x'] = (xy['x'] as double) * factorX;
                    xy['y'] = (xy['y'] as double) * factorY;
                    return xy;
                  }).toList()),
            )),
      ]);
    }).toList();
  }
}
