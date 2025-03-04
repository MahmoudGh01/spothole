import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/ViewModels/report_provider.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:provider/provider.dart';
import '../../../ViewModels/authority_provider.dart';
import '../../../ViewModels/userprovider.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_applicationstages.dart';

class JobApplication extends StatefulWidget {
  const JobApplication({Key? key}) : super(key: key);

  @override
  State<JobApplication> createState() => _JobApplicationState();
}

class _JobApplicationState extends State<JobApplication> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  @override
  void initState() {
    super.initState();
    Provider.of<AuthorityProvider>(context, listen: false).fetchAllReports();
  }

  @override
  Widget build(BuildContext context) {
    final authorityProvider = Provider.of<AuthorityProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset(
            JobPngimage.logo,
            height: height / 36,
          ),
        ),
        title: Text("Pothole Reports".tr, style: urbanistBold.copyWith(fontSize: 22)),
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
            children: [
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray),
                  hintText: "Search".tr,
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  prefixIcon: Icon(Icons.search_rounded, size: height / 36, color: JobColor.textgray),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(JobPngimage.filter, height: height / 36),
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
              SizedBox(height: height / 36),
              ListView.separated(
                itemCount: authorityProvider.reports.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final report = authorityProvider.reports[index];
                  final reportUser = userProvider.getReportUser(report.userId);

                  if (reportUser == null) {
                    // If user is not yet available, fetch it
                    userProvider.fetchUserById(report.userId);
                    return const CircularProgressIndicator(); // Show loading indicator while fetching
                  }

                  return InkWell(
                    splashColor: JobColor.transparent,
                    highlightColor: JobColor.transparent,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ReportDetail(report: report);
                        },
                      ));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: height / 10,
                              width: height / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: themedata.isdark ? JobColor.borderblack : JobColor.bggray),
                              ),
                              child: report.imageURL.isNotEmpty
                                  ? Image.network(report.imageURL, fit: BoxFit.fill)
                                  : Image.asset('assets/job_assets/job_pngimage/logo.png'),
                            ),
                            SizedBox(width: width / 26),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width / 1.8,
                                  child: Text(
                                    report.address,
                                    style: urbanistSemiBold.copyWith(fontSize: 19),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: height / 80),
                            /*    Text(
                                  report.longitude.toString(),
                                  style: urbanistMedium.copyWith(fontSize: 16, color: JobColor.textgray),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),*/
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: reportUser.profilePicturePath.isNotEmpty
                                          ? NetworkImage(reportUser.profilePicturePath)
                                          : const AssetImage('assets/job_assets/job_pngimage/logo.png') as ImageProvider,
                                    ),
                                    SizedBox(width: width / 36),
                                    Text(
                                      reportUser.name,
                                      style: urbanistSemiBold.copyWith(
                                        fontSize: 15,
                                        color: themedata.isdark ? Colors.white60 : Colors.black54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                SizedBox(height: height / 80),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color(0x1A246BFD),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 110),
                                    child: Text(
                                      report.status,
                                      style: urbanistSemiBold.copyWith(fontSize: 10, color: const Color(0xff246BFD)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(Icons.arrow_forward_ios, size: height / 46),
                          ],
                        ),
                        SizedBox(height: height / 80),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      const Divider(),
                      SizedBox(height: height / 80),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
