import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

import '../Views/job_gloabelclass/job_color.dart';
import '../Views/job_gloabelclass/job_fontstyle.dart';
import '../Views/job_pages/job_home/job_applyjob.dart';
import '../Views/job_pages/job_theme/job_themecontroller.dart';

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

late List<CameraDescription> cameras;

class ModelScreen extends StatefulWidget {
  const ModelScreen({Key? key}) : super(key: key);

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  late FlutterVision vision;
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    if (Platform.operatingSystem == 'android') {
      vision = FlutterVision();
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    switch (Platform.operatingSystem) {
      case 'ios':
        return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 100,),
                LottieBuilder.asset('assets/animassets/not_supported.json'),
                const SizedBox(),
                 Text("IOS is not supported",style: urbanistBold.copyWith(fontSize: 25 , color: const Color(0xff2B3499) ),)
              ],
            ));
      case 'android':
        return Scaffold(
          body: task(option),
          floatingActionButton: SpeedDial(
            icon: Icons.menu,
            activeIcon: Icons.close,
            backgroundColor: Colors.black12,
            foregroundColor: Colors.white,
            activeBackgroundColor: Colors.deepPurpleAccent,
            activeForegroundColor: Colors.white,
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            buttonSize: const Size(56.0, 56.0),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.video_call),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Yolo on Frame',
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () {
                  setState(() {
                    option = Options.frame;
                  });
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.camera),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'YoloV8seg on Image',
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () {
                  setState(() {
                    option = Options.imagev8seg;
                  });
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.camera),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'YoloV8seg on Video',
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () {
                  setState(() {
                    option = Options.imagev8;
                  });
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.camera),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'YoloV5 on Image',
                labelStyle: const TextStyle(fontSize: 18.0),
                onTap: () {
                  setState(() {
                    option = Options.imagev5;
                  });
                },
              ),
            ],
          ),
        );

      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  Widget task(Options option) {
    if (option == Options.frame) {
      return YoloVideo(vision: vision);
    }
    if (option == Options.imagev5) {
      return YoloImageV5(vision: vision);
    }
    if (option == Options.imagev8) {
      return YoloVideoV8Seg(vision: vision);
    }
    if (option == Options.imagev8seg) {
      return YoloImageV8Seg(vision: vision);
    }

    return YoloVideo(vision: vision);
  }
}

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;
  const YoloVideo({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
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
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
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
                child: /*ElevatedButton(
                  onPressed: () async {
                    if (cameraImage != null) {
                      await _getCurrentLocation();
                      await _navigateToJobApply(cameraImage!);
                    }
                  },
                  child: const Text("Report"),
                ),*/
                    InkWell(
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
                      child: Text("Detect".tr,
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
    await widget.vision.loadYoloModel(
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
    final result = await widget.vision.yoloOnFrame(
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
          child: Text(
            "${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              // background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _getCurrentLocation() async {
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

class YoloImageV5 extends StatefulWidget {
  final FlutterVision vision;
  const YoloImageV5({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloImageV5> createState() => _YoloImageV5State();
}

class _YoloImageV5State extends State<YoloImageV5> {
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: pickImage,
                child: const Text("Pick image"),
              ),
              ElevatedButton(
                onPressed: yoloOnImage,
                child: const Text("Detect"),
              )
            ],
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov5s.tflite',
        modelVersion: "yolov5",
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
    final result = await widget.vision.yoloOnImage(
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

    double pady = (screen.height - newHeight) / 2;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
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
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class YoloImageV8 extends StatefulWidget {
  final FlutterVision vision;
  const YoloImageV8({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloImageV8> createState() => _YoloImageV8State();
}

class _YoloImageV8State extends State<YoloImageV8> {
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: pickImage,
                child: const Text("Pick an image"),
              ),
              ElevatedButton(
                onPressed: yoloOnImage,
                child: const Text("Detect"),
              )
            ],
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov8n.tflite',
        modelVersion: "yolov8",
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
    final result = await widget.vision.yoloOnImage(
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

    double pady = (screen.height - newHeight) / 2;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
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
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class YoloImageV8Seg extends StatefulWidget {
  final FlutterVision vision;
  const YoloImageV8Seg({Key? key, required this.vision}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() async {
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
                    /* Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const JobSelectexpertise();
                },));*/
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
    await widget.vision.loadYoloModel(
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
    final result = await widget.vision.yoloOnImage(
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

class PolygonPainter extends CustomPainter {
  final List<Map<String, double>> points;

  PolygonPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(129, 255, 2, 124)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]['x']!, points[0]['y']!);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i]['x']!, points[i]['y']!);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class YoloVideoV8Seg extends StatefulWidget {
  final FlutterVision vision;
  const YoloVideoV8Seg({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideoV8Seg> createState() => _YoloVideoV8SegState();
}

class _YoloVideoV8SegState extends State<YoloVideoV8Seg> {
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double height = 0.00;
  double width = 0.00;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          child: CameraPreview(controller),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          bottom: 75,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: Colors.white,
                    style: BorderStyle.solid,
                  ),
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
            ],
          ),
        ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/models/best_float32.tflite',
      modelVersion: "yolov8seg",
      numThreads: 2,
      useGpu: true,
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await widget.vision.yoloOnFrame(
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
      return Stack(children: [
        Positioned(
          left: result["box"][0] * factorX,
          top: result["box"][1] * factorY,
          width: (result["box"][2] - result["box"][0]) * factorX,
          height: (result["box"][3] - result["box"][1]) * factorY,
          child: Text(
            "${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              // background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
        Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY,
            width: (result["box"][2] - result["box"][0]) * factorX,
            height: (result["box"][3] - result["box"][1]) * factorY,
            child: CustomPaint(
              painter: PolygonPainter(
                points: (result["polygons"] as List<dynamic>).map((e) {
                  Map<String, double> xy = Map<String, double>.from(e);
                  xy['x'] = (xy['x'] as double) * factorX;
                  xy['y'] = (xy['y'] as double) * factorY;
                  return xy;
                }).toList(),
              ),
            )),
      ]);
    }).toList();
  }
}
