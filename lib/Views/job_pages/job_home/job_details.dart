import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_applyjob.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({Key? key}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  int isselected = 0;
  List type = ["Report Description"];
  List perks = [
    "Medical / Health Insurance",
    "Medical, Prescription, or Vision Plans",
    "Performance Bonus",
    "Paid Sick Leave",
    "Paid Vacation Leave",
    "Transportation Allowances"
  ];
  List icon = [
    JobPngimage.g1,
    JobPngimage.p2,
    JobPngimage.p3,
    JobPngimage.p4,
    JobPngimage.p5,
    JobPngimage.p6,
  ];

  List skills = [
    "Creative Thinking",
    "UI/UX Design",
    "Figma",
    "Graphic Design",
    "Web Design",
    "Layout"
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  JobPngimage.save,
                  height: height / 36,
                  color: themedata.isdark ? JobColor.white : JobColor.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  JobPngimage.send,
                  height: height / 30,
                  color: themedata.isdark ? JobColor.white : JobColor.black,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width / 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                        color: themedata.isdark
                            ? JobColor.borderblack
                            : JobColor.bggray)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 36, vertical: height / 46),
                  child: Column(
                    children: [
                      Container(
                        height: height / 10,
                        width: height / 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: themedata.isdark
                                    ? JobColor.borderblack
                                    : JobColor.bggray)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            JobPngimage.google,
                            height: height / 36,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 36,
                      ),
                      Text(
                        "Report Example".tr,
                        style: urbanistSemiBold.copyWith(fontSize: 22),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: height / 80,
                      ),
                      Text(
                        "City Hall : Ariana".tr,
                        style: urbanistMedium.copyWith(
                            fontSize: 18, color: JobColor.appcolor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: height / 96,
                      ),
                      const Divider(
                        color: JobColor.bggray,
                      ),
                      SizedBox(
                        height: height / 96,
                      ),
                      Text(
                        "Ariana Soghra , ".tr,
                        style: urbanistMedium.copyWith(
                            fontSize: 18, color: JobColor.textgray),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: height / 66,
                      ),
                      SizedBox(
                        height: height / 66,
                      ),
                      Text("Posted 10 days ago, ends in 31 Dec.".tr,
                          style: urbanistSemiBold.copyWith(
                              fontSize: 14, color: JobColor.textgray)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height / 36,
              ),
              SizedBox(
                height: height / 15,
                child: Center(
                  child: ListView.separated(
                    itemCount: type.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: JobColor.transparent,
                        highlightColor: JobColor.transparent,
                        onTap: () {
                          setState(() {
                            isselected = index;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              type[index],
                              style: urbanistSemiBold.copyWith(
                                  fontSize: 18,
                                  color: isselected == index
                                      ? JobColor.appcolor
                                      : JobColor.textgray),
                            ),
                            SizedBox(
                              height: height / 96,
                            ),
                            Container(
                              color: isselected == index
                                  ? JobColor.appcolor
                                  : JobColor.transparent,
                              height: height / 300,
                              width: width / 3.5,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        width: width / 20,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: height / 66,
              ),
              if (isselected == 0) ...[
                Text(
                  "Report Description".tr,
                  style: urbanistBold.copyWith(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: height / 40,
                ),
                Text(
                  "- Pothole located at the intersection of Main St and 3rd Ave."
                      .tr,
                  style: urbanistMedium.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: height / 120,
                ),
                Text(
                  "- Approximately 3 feet wide and 2 feet deep.".tr,
                  style: urbanistMedium.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: height / 120,
                ),
                Text(
                  "- Pothole is causing significant traffic disruption.".tr,
                  style: urbanistMedium.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: height / 120,
                ),
                Text("- Needs urgent repair to prevent accidents.".tr,
                    style: urbanistMedium.copyWith(
                      fontSize: 16,
                    ))
              ]
            ],
          ),
        ),
      ),


    );
  }

  _showapplybottomsheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
             // color: JobColor.appcolor,
                height: height / 4.8,
                decoration: const BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 36, vertical: height / 56),
                  child: Column(
                    children: [
                      Text(
                        "Apply_Job".tr,
                        style: urbanistBold.copyWith(
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: height / 56,
                      ),
                      const Divider(),
                      SizedBox(
                        height: height / 56,
                      ),
                      Row(
                        children: [

                          const Spacer(),
                          InkWell(
                            splashColor: JobColor.transparent,
                            highlightColor: JobColor.transparent,
                            onTap: () {

                            },
                            child: Container(
                              height: height / 15,
                              width: width / 2.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: JobColor.appcolor,
                              ),
                              child: Center(
                                child: Text("Apply_with_Profile".tr,
                                    style: urbanistSemiBold.copyWith(
                                        fontSize: 16, color: JobColor.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          });
        });
  }
}
