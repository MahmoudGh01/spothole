import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../Models/Report.dart';
import '../../../ViewModels/report_provider.dart';
import '../../../ViewModels/userprovider.dart';
import '../../job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';

class JobApply extends StatefulWidget {
  final File image;
  final String address;
  final double? latitude;
  final double? longitude;

  const JobApply({
    Key? key,
    required this.image,
    required this.address,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<JobApply> createState() => _JobApplyState();
}

class _JobApplyState extends State<JobApply> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _severityController = TextEditingController();
  int _severity = 5;
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  @override
  void initState() {
    super.initState();
    _locationController.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Future<void> uploadImageAndSubmitReport() async {
      if (widget.image != null) {
        // Show loading indicator
        showDialog(
          barrierColor: Colors.transparent,
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: LottieBuilder.asset('assets/loading_animation.json'),
          ),
        );
        //LottieBuilder.asset('assets/loading_animation.json');
        try {
          // Upload file and get URL
          var reportProvider =
              Provider.of<ReportProvider>(context, listen: false);
          String? fileUrl = await reportProvider.uploadFile(widget.image);

          // Close loading indicator
          Navigator.of(context).pop();

          // Debugging logs
          print('File uploaded successfully, URL: $fileUrl');

          // Create Report object
          Report report = Report(
            caseId: '',
            description: _descriptionController.text,
            imageURL: fileUrl!,
            latitude: widget.latitude!.toDouble(),
            longitude: widget.longitude!.toDouble(),
            severity: _severity,
            userId: user.id,
            status: "submitted",
            createdDate: DateTime.now().toString(),
            lastUpdated: DateTime.now().toString(),
            address: _locationController.text,
            locationPoint: '',
          );

          // Debugging logs
          print('Report created: ${report.toJson()}');

          // Submit Report
          await reportProvider.submitReport(context, report);

          // Show success message
        } catch (e) {
          // Close loading indicator
          Navigator.of(context).pop();

          // Debugging logs
          print('Error: $e');
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Report"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Address".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              TextField(
                controller: _locationController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(
                    fontSize: 16,
                    color: JobColor.textgray,
                  ),
                  hintText: "New York, United States".tr,
                  fillColor:
                      themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.location_on,
                    size: height / 36,
                    color: JobColor.textgray,
                  ),
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
              SizedBox(height: height / 66),
              Text("Upload Images".tr,
                  style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              InkWell(
                onTap: () {},
                child: Container(
                  height: height / 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(widget.image, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: height / 33),
              Text("Extra Description".tr,
                  style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Describe your report...".tr,
                  hintStyle: urbanistRegular.copyWith(
                      fontSize: 16, color: JobColor.textgray),
                  fillColor:
                      themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: JobColor.appcolor),
                  ),
                ),
              ),
              SizedBox(height: height / 33),
              Text("Severity".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              Slider(
                value: _severity.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _severity.toString(),
                onChanged: (double value) {
                  print(value.toInt());
                  setState(() {
                    _severity = value.toInt();
                    _severityController.text = value.toString();
                  });
                },
              ),
              SizedBox(height: height / 33),
              InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  uploadImageAndSubmitReport();
                },
                child: Container(
                  height: height / 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: JobColor.appcolor,
                  ),
                  child: Center(
                    child: Text(
                      "Save Report".tr,
                      style: urbanistSemiBold.copyWith(
                        fontSize: 16,
                        color: JobColor.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
