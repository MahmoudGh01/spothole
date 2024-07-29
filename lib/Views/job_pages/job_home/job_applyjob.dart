import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';

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
  int? _severity = 5;
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Report"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
              Text("Upload Images".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              Container(
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
              SizedBox(height: height / 33),
              Text("Extra Description".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Describe your report...".tr,
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray),
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
                value: _severity!.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _severity!.toString(),
                onChanged: (double value) {
                  setState(() {
                    _severity = value.toInt();
                    _severityController.text = value.toInt().toString();
                  });
                },
              ),
              SizedBox(height: height / 33),
              InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  // Add your submit logic here
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
