import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:lottie/lottie.dart';

import '../../Services/painter.dart';
late List<CameraDescription> cameras;
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
  Isolate? _isolate;
  final ReceivePort _receivePort = ReceivePort();
  SendPort? _sendPort;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await _spawnIsolate(); // Start the isolate
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) async {
      await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/models/best_float32.tflite',
        modelVersion: "yolov8seg",
        numThreads: 2,
        useGpu: true,
      );
      setState(() {
        isLoaded = true;
        yoloResults = [];
      });
    });
  }

  Future<void> _spawnIsolate() async {
    _isolate = await Isolate.spawn(
      _isolateEntry,
      _receivePort.sendPort,
    );
    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is List<Map<String, dynamic>>) {
        setState(() {
          yoloResults = message;
        });
      }
    });
  }

  static Future<void> _isolateEntry(SendPort sendPort) async {
    final ReceivePort isolateReceivePort = ReceivePort();
    sendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((message) async {
      if (message is List) {
        final CameraImage image = message[0];
        final double iouThreshold = message[1];
        final double confThreshold = message[2];

        // Simulate heavy computation (mock detection logic)
        final List<Map<String, dynamic>> results = await _mockDetection(image, iouThreshold, confThreshold);

        // Send results back to the main isolate
        sendPort.send(results);
      }
    });
  }

  static Future<List<Map<String, dynamic>>> _mockDetection(
      CameraImage image, double iouThreshold, double confThreshold) async {
    // This function will simulate the detection logic. Replace with actual logic.
    await Future.delayed(const Duration(milliseconds: 200)); // Simulating delay

    // Dummy data
    return [
      {
        "box": [10, 20, 30, 40],
        "confidence": 0.8,
        "class": "pothole",
        "polygons": []
      }
    ];
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting && _sendPort != null) {
        _sendPort!.send([image, 0.45, 0.25]); // Send image and thresholds to isolate
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
    await controller.stopImageStream();
  }

  @override
  void dispose() {
    _disposeIsolate();
    controller.dispose();
    widget.vision.closeYoloModel();
    super.dispose();
  }

  void _disposeIsolate() {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
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
                  onPressed: stopDetection,
                  icon: const Icon(
                    Icons.stop,
                    color: Colors.red,
                  ),
                  iconSize: 50,
                )
                    : IconButton(
                  onPressed: startDetection,
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

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = (screen.height - 56.0) / (cameraImage?.width ?? 1);

    return yoloResults.map((result) {
      return Stack(
        children: [
          Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY,
            width: (result["box"][2] - result["box"][0]) * factorX,
            height: (result["box"][3] - result["box"][1]) * factorY,
            child: Text(
              "${(result['confidence'] * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
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
            ),
          ),
        ],
      );
    }).toList();
  }
}


class IsolateHelper {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

   Future<void> loadModelInIsolate(SendPort sendPort) async {
    // Ensure that the isolate is initialized to communicate with platform channels
    BackgroundIsolateBinaryMessenger.ensureInitialized(
        rootIsolateToken);

    final FlutterVision vision = FlutterVision();
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/models/best_float32.tflite',
      modelVersion: "yolov8seg",
      numThreads: 2,
      useGpu: true,
    );
    //print(vision.toString());

    // Send the loaded model back to the main isolate
    sendPort.send(vision);
  }

   Future<void> detectInIsolate(
      SendPort sendPort, FlutterVision vision, CameraImage image) async {
    // Ensure that the isolate is initialized to communicate with platform channels
    BackgroundIsolateBinaryMessenger.ensureInitialized(
        rootIsolateToken);

    final result = await vision.yoloOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.45,
      confThreshold: 0.25,
    );

    // Send the detection result back to the main isolate
    sendPort.send(result);
  }
}
