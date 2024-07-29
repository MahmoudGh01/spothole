import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:geolocator/geolocator.dart';

import '../job_gloabelclass/job_color.dart';
import '../job_gloabelclass/job_fontstyle.dart';
import '../job_pages/job_home/job_applyjob.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  late ModelObjectDetection _objectModel;
  File? _image;
  ImagePicker _picker = ImagePicker();
  bool firststate = false;
  bool message = true;
  List<ResultObjectDetection?> objDetect = [];
  Position? _currentPosition;
  String _currentAddress = "Fetching location...";

  @override
  void initState() {
    super.initState();
    loadModel();
    runObjectDetection();
  }

  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          pathObjectDetectionModel,
          1,
          640,
          640,
          labelPath: "assets/labels/labels.txt");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  void handleTimeout() {
    setState(() {
      firststate = true;
    });
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  Future runObjectDetection() async {
    setState(() {
      firststate = false;
      message = false;
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    objDetect = await _objectModel.getImagePrediction(
        await File(image.path).readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.3);

    if (objDetect.isNotEmpty) {
      await _getCurrentLocation();

      setState(() {
        _image = File(image.path);
        firststate = true;
        message = false;
      });
    } else {
      setState(() {
        firststate = true;
        message = true;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  void _navigateToJobApply() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobApply(
          image: _image!,
          address: _currentAddress,
          latitude: _currentPosition?.latitude,
          longitude: _currentPosition?.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: Text("Detection Complete!".tr,style: urbanistBold.copyWith(fontSize: 22 , color: JobColor.appcolor)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!firststate)
                if (!message)
                  CircularProgressIndicator()
                else
                  Text(
                    "Select the Camera to Begin Detections",
                    style: urbanistRegular.copyWith(color: JobColor.textgray),
                    textAlign: TextAlign.center,
                  ),
              if (_image != null && objDetect.isNotEmpty)
                Column(
                  children: [
                    Container(
                      height: 445,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(color: JobColor.lightblue),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child:
                        _objectModel.renderBoxesOnImage(_image!, objDetect),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Location: $_currentAddress",
                      style: urbanistRegular.copyWith(color: JobColor.textgray),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              if (firststate && message)
                Text(
                  "No objects detected. Try again.",
                  style: urbanistRegular.copyWith(color: JobColor.red),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 56),
        child: InkWell(
          splashColor: JobColor.transparent,
          highlightColor: JobColor.transparent,
          onTap: _navigateToJobApply,
          child: Container(
            height: height / 15,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: JobColor.appcolor,
            ),
            child: Center(
              child: Text(
                "Report",
                style: urbanistSemiBold.copyWith(
                    fontSize: 16, color: JobColor.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
