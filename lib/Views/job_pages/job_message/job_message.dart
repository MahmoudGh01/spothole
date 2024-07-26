import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_pages/job_message/job_chatting.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';

class JobMessage extends StatefulWidget {
  const JobMessage({Key? key}) : super(key: key);

  @override
  State<JobMessage> createState() => _JobMessageState();
}

class _JobMessageState extends State<JobMessage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  List<String> reports = ["Pothole on Main St", "Pothole on Elm St", "Pothole on Oak St"];
  List<String> statuses = ["In Progress", "Resolved", "Reported"];
  List<String> times = ["14:00", "12:30", "09:00"];
  List<String> reportImages = [
    JobPngimage.homefill,  // Placeholder for the actual image
    JobPngimage.homefill,  // Placeholder for the actual image
    JobPngimage.homefill,  // Placeholder for the actual image
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(JobPngimage.logo, height: height / 36),
          ),
          title: Text("Pothole Reports".tr, style: urbanistBold.copyWith(fontSize: 22)),
          actions: [
            Row(
              children: [
                Image.asset(JobPngimage.search, height: height / 36, color: themedata.isdark ? JobColor.white : JobColor.black),
                SizedBox(width: width / 36),
                Image.asset(JobPngimage.more, height: height / 30, color: themedata.isdark ? JobColor.white : JobColor.black),
                const SizedBox(width: 15)
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: JobColor.appcolor,
            dividerColor: JobColor.bggray,
            labelColor: JobColor.appcolor,
            labelPadding: EdgeInsets.only(bottom: height / 96),
            indicatorPadding: EdgeInsets.symmetric(horizontal: width / 26),
            unselectedLabelColor: JobColor.textgray,
            unselectedLabelStyle: urbanistSemiBold.copyWith(fontSize: 18),
            labelStyle: urbanistSemiBold.copyWith(fontSize: 18),
            tabs: [
              Text("Reports".tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: JobColor.transparent,
                      highlightColor: JobColor.transparent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const JobChatting();
                        }));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: JobColor.transparent,
                            backgroundImage: AssetImage(reportImages[index].toString()),
                          ),
                          SizedBox(width: width / 26),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reports[index].toString(), style: urbanistBold.copyWith(fontSize: 18)),
                              SizedBox(height: height / 96),
                              Text(statuses[index].toString(), style: urbanistMedium.copyWith(fontSize: 14, color: JobColor.textgray)),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (statuses[index] == "In Progress" || statuses[index] == "Reported") ...[
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: JobColor.appcolor,
                                  child: Text("!", style: urbanistRegular.copyWith(fontSize: 10, color: JobColor.white)),
                                ),
                              ],
                              SizedBox(height: height / 96),
                              Text(times[index].toString(), style: urbanistMedium.copyWith(fontSize: 14, color: JobColor.textgray)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height / 36);
                  },
                  itemCount: reportImages.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
