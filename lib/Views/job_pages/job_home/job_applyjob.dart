import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import '../../../Models/Report.dart';
import '../../../ViewModels/report_provider.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';

class JobApply extends StatefulWidget {
  const JobApply({Key? key}) : super(key: key);

  @override
  State<JobApply> createState() => _JobApplyState();
}

class _JobApplyState extends State<JobApply> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _severityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _currentAddress = "Fetching location...";
  double? _latitude;
  double? _longitude;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _getAddressFromLatLng(position);
    _latitude = position.latitude;
    _longitude = position.longitude;
  }
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
        _locationController.text = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Report", style: urbanistBold.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Location".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              TextField(
                controller: _locationController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(
                    fontSize: 16,
                    color: JobColor.textgray,
                  ),
                  hintText: "Location".tr,
                  fillColor: themedata.isdark
                      ? JobColor.lightblack
                      : JobColor.appgray,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: JobColor.appcolor),
                  ),
                ),
              ),
              SizedBox(height: height / 46),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add your camera screen navigation logic here
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text("Open Camera"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: JobColor.white,
                    backgroundColor: JobColor.appcolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height / 46),
              Text("Upload Images".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: width / 1,
                  height: height / 6,
                  decoration: BoxDecoration(
                    color: themedata.isdark ? JobColor.lightblack : JobColor.bggray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _pickedImage == null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(JobPngimage.uploadfile, height: height / 26),
                      SizedBox(height: height / 36),
                      Text("Browse_File".tr,
                          style: urbanistSemiBold.copyWith(
                              fontSize: 14, color: JobColor.textgray)),
                    ],
                  )
                      : Image.file(_pickedImage!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: height / 46),
              Text("Extra Description".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(
                    fontSize: 16,
                    color: JobColor.textgray,
                  ),
                  hintText: "Describe your report...".tr,
                  fillColor: themedata.isdark
                      ? JobColor.lightblack
                      : JobColor.appgray,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: JobColor.appcolor),
                  ),
                ),
              ),
              SizedBox(height: height / 46),
              Text("Severity".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              TextField(
                controller: _severityController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(
                    fontSize: 16,
                    color: JobColor.textgray,
                  ),
                  hintText: "Severity".tr,
                  fillColor: themedata.isdark
                      ? JobColor.lightblack
                      : JobColor.appgray,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: JobColor.appcolor),
                  ),
                ),
              ),
              SizedBox(height: height / 46),


            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width / 36, vertical: height / 56),
        child: InkWell(
          splashColor: JobColor.transparent,
          highlightColor: JobColor.transparent,
          onTap: () async {
            final report = Report(
              caseId: '1', // Assign a unique case ID here
              description: _descriptionController.text,
              imageURL: _pickedImage?.path ?? '',
              latitude: _latitude!.toString(),
              longitude: _longitude!.toString(),
              severity: int.parse(_severityController.text),
              userId: '1', // Replace with the actual user ID
              status: 'Pending', // Initial status
              createdDate: DateTime.now().toString(),
              lastUpdated: DateTime.now().toString(),
              address: _currentAddress,
              locationPoint: '', // Convert to the required format
            );

            Provider.of<ReportProvider>(context, listen: false).submitReport(context,report);
            // Navigate to a confirmation or another screen
          },
          child: Container(
            width: width,
            height: height / 13,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: JobColor.appcolor,
            ),
            child: Text(
              "Apply",
              style: urbanistBold.copyWith(
                  fontSize: 18, color: JobColor.white),
            ),
          ),
        ),
      ),
    );
  }
}

