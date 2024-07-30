import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Models/Report.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';

class ReportDetail extends StatelessWidget {
  final Report report;

  const ReportDetail({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themedata = Get.put(JobThemecontroler());
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset(
            JobPngimage.logo,
            height: height / 36,
          ),
        ),
        title: Text("Report Detail".tr, style: urbanistBold.copyWith(fontSize: 22)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              JobPngimage.more,
              height: height / 36,
              color: themedata.isdark ? JobColor.white : JobColor.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: themedata.isdark ? JobColor.borderblack : JobColor.bggray),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 46),
                  child: Column(
                    children: [
                      Container(
                        height:300,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: themedata.isdark ? JobColor.borderblack : JobColor.bggray),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: report.imageURL != null && report.imageURL!.isNotEmpty
                              ? Image.network(report.imageURL!, fit: BoxFit.fill)
                              : Image.asset('assets/job_assets/job_pngimage/logo.png'),
                        ),
                      ),
                      SizedBox(height: height / 100),
                      Text(
                        report.description,
                        style: urbanistSemiBold.copyWith(fontSize: 22),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height / 100),
                      Text(
                        "Location: ${report.address}",
                        style: urbanistMedium.copyWith(fontSize: 18, color: JobColor.appcolor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height / 96),

                    ],
                  ),
                ),
              ),
              SizedBox(height: height / 26),
              Text("Report Information".tr, style: urbanistSemiBold.copyWith(fontSize: 18)),
              SizedBox(height: height / 36),
              Container(
                height: height / 15,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: JobColor.lightblue,
                ),
                child: Center(
                  child: Text(
                    "Report Status: ${report.status}".tr,
                    style: urbanistSemiBold.copyWith(fontSize: 16, color: JobColor.appcolor),
                  ),
                ),
              ),
              SizedBox(height: height / 36),

              Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: themedata.isdark ? JobColor.borderblack : JobColor.bggray),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 46),
                  child: Column(
                    children: [

                      Text(
                        "Reported by User ID: ${report.userId}",
                        style: urbanistMedium.copyWith(fontSize: 18, color: JobColor.textgray),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height / 66),
                      Text(
                        "Severity: ${report.severity}",
                        style: urbanistSemiBold.copyWith(fontSize: 18, color: JobColor.appcolor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height / 66),
                      Text(
                        "Posted on: ${report.createdDate}",
                        style: urbanistSemiBold.copyWith(fontSize: 14, color: JobColor.textgray),
                      ),
                      SizedBox(height: height / 66),

                    ],
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
