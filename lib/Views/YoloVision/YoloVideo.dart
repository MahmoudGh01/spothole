import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../job_gloabelclass/job_color.dart';
import '../job_gloabelclass/job_fontstyle.dart';
import '../job_pages/job_home/job_applyjob.dart';
import '../job_pages/job_theme/job_themecontroller.dart';
late List<CameraDescription> cameras;

class YoloVideo extends StatefulWidget {
  const YoloVideo({Key? key}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late FlutterVision vision;

  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  Position? currentPosition;
  String? currentAddress;
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    //await widget.vision.closeYoloModel();

    if (Platform.operatingSystem == 'android') {
      vision = FlutterVision();
    }
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((value) async {
      await loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
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
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          top: 40,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Potholes Detected: ${yoloResults.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 5, color: Colors.white, style: BorderStyle.solid),
                ),
                child: isDetecting
                    ? IconButton(
                        onPressed: () async {
                          stopDetection();
                        },
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.red,
                        ),
                        iconSize: 50,
                      )
                    : IconButton(
                        onPressed: () async {
                          await startDetection();
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        iconSize: 50,
                      ),
              ),
              const SizedBox(width: 20),
              Visibility(
                visible: yoloResults.isNotEmpty,
                child: InkWell(
                  splashColor: JobColor.transparent,
                  highlightColor: JobColor.transparent,
                  onTap: () async {
                    if (cameraImage != null) {
                      await _getCurrentLocation();
                      await _navigateToJobApply(cameraImage!);
                    }
                  },
                  child: Container(
                    height: height / 15,
                    width: width / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: JobColor.appcolor,
                    ),
                    child: Center(
                      child: Text("Report".tr,
                          style: urbanistSemiBold.copyWith(
                              fontSize: 16, color: JobColor.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov5s.tflite',
        modelVersion: "yolov5",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.45,
      confThreshold: 0.25,
    );
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = (screen.height - 56.0) / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: JobColor.appcolor, width: 2.0),
          ),
          /*   child: Text(
            "${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              // background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),*/
        ),
      );
    }).toList();
  }

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If not, request to enable it
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        // If the service is still not enabled, return
        return;
      }
    }

    // Check for location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if it's denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, exit the method
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle it appropriately
      return;
    }

    // If permissions are granted, get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = position;
    });

    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  Future<void> _navigateToJobApply(CameraImage cameraImage) async {
    // Convert CameraImage to File
    final imageFile = await _convertCameraImageToFile(cameraImage);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobApply(
          image: imageFile,
          address: currentAddress ?? '',
          latitude: currentPosition?.latitude,
          longitude: currentPosition?.longitude,
        ),
      ),
    );
  }

  Future<File> _convertCameraImageToFile(CameraImage cameraImage) async {
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final img.Image image = img.Image(height: height, width: width);

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        final int index = i * width + j;
        final int uvIndex = (i ~/ 2) * width + (j ~/ 2);
        final int y = cameraImage.planes[0].bytes[index];
        final int u = cameraImage.planes[1].bytes[uvIndex];
        final int v = cameraImage.planes[2].bytes[uvIndex];

        final int r = (y + (1.370705 * (v - 128))).clamp(0, 255).toInt();
        final int g = (y - (0.698001 * (v - 128)) - (0.337633 * (u - 128)))
            .clamp(0, 255)
            .toInt();
        final int b = (y + (1.732446 * (u - 128))).clamp(0, 255).toInt();

        image.setPixel(j, i, img.ColorRgb8(r, g, b));
      }
    }

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/temp_image.png';
    final File file = File(tempPath);
    file.writeAsBytesSync(img.encodePng(image));

    return file;
  }
}
