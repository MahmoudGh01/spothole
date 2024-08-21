import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:lottie/lottie.dart';

import '../job_gloabelclass/job_fontstyle.dart';
import '../job_pages/job_home/job_applyjob.dart';

class YoloImageV8 extends StatefulWidget {
  const YoloImageV8({Key? key}) : super(key: key);

  @override
  State<YoloImageV8> createState() => _YoloImageV8State();
}

class _YoloImageV8State extends State<YoloImageV8> {
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;
  late FlutterVision vision;
  Position? currentPosition;
  String? currentAddress;
  double height = 0.00;
  double width = 0.00;
  dynamic size ;

  @override
  void initState() {
    super.initState();
  init();
  }
  Future<void> init() async {
    if (Platform.operatingSystem == 'android') {
      vision = FlutterVision();
    }
    await loadYoloModel().then((value) {
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
        if (yoloResults.isNotEmpty)
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await _getCurrentLocation();
                    await _navigateToJobApply();
                  },
                  child: Container(
                    height: 50,
                    width: size.width / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: JobColor.appcolor,
                    ),
                    child: const Center(
                      child: Text(
                        "Report",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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
    try {
      await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov5s.tflite',
        modelVersion: "yolov5",
        quantization: false,
        numThreads: 2,
        useGpu: true,
      );
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  yoloOnImage() async {
    yoloResults.clear();
    print(imageFile!.path);
    Uint8List byte = await imageFile!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;
    final result = await vision.yoloOnImage(
      bytesList: byte,
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.45,
      confThreshold: 0.25,
      //classThreshold: 0.5,
    );
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

    double pady = (screen.height - newHeight) / 2;

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY + pady,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            " ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              backgroundColor: Colors.green,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

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

  Future<void> _navigateToJobApply() async {
    if (imageFile != null && currentPosition != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobApply(
            image: imageFile!,
            address: currentAddress ?? '',
            latitude: currentPosition!.latitude,
            longitude: currentPosition!.longitude,
          ),
        ),
      );
    } else {
      // You can add a message or snackbar here for feedback
      print("Error: No image or location data available.");
    }
  }


}
