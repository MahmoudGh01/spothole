import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_fontstyle.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:provider/provider.dart';
import '../../../Models/user.dart';
import '../../../ViewModels/authority_provider.dart';
import '../../../ViewModels/userprovider.dart';
import '../job_application/job_applicationstages.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_details.dart';
class JobHome extends StatefulWidget {
  const JobHome({Key? key}) : super(key: key);

  @override
  State<JobHome> createState() => _JobHomeState();
}

class _JobHomeState extends State<JobHome> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final authorityProvider = Provider.of<AuthorityProvider>(context, listen: false);
    await authorityProvider.fetchAllReports();
  }

  @override
  Widget build(BuildContext context) {
    final _reports = Provider.of<AuthorityProvider>(context).reports;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: width / 1,
        toolbarHeight: height / 10,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: user.profilePicturePath.isNotEmpty
                    ? NetworkImage(user.profilePicturePath)
                    :  AssetImage(JobPngimage.profile) as ImageProvider,

              ),
              SizedBox(width: width/26,),
              SizedBox(width: width / 26),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height/120,),
                  Text("Good Morning 👋".tr,style: urbanistRegular.copyWith(fontSize: 10)),
                  SizedBox(height: height/120,),
                  Text(user.name,style: urbanistBold.copyWith(fontSize: 19 )),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
          child: Column(
            children: [
              TextField(
                onTap: () {
                  // Handle search action
                },
                style: urbanistSemiBold.copyWith(fontSize: 16),
                readOnly: true,
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray),
                  hintText: "Search for a report".tr,
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
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: height/45,),
              Text("Report Potholes around you".tr,style: urbanistBold.copyWith(fontSize: 25 , color: Color(0xff2B3499) ),),
              Text("for a better city".tr,style: urbanistBold.copyWith(fontSize: 29 , color: Color(0xff2B3499) ),),

              SizedBox(height: height/26,),
              Image.asset(JobPngimage.homebanner,width: width/1,fit: BoxFit.fitWidth,),

              SizedBox(height: height/30,),



              Row(
                children: [
                  Text("NearBy Reports".tr,style: urbanistBold.copyWith(fontSize: 20 )),
                  const Spacer(),
                  InkWell(
                      splashColor: JobColor.transparent,
                      highlightColor: JobColor.transparent,
                      onTap: () {

                      },
                      child: Text("See_All".tr,style: urbanistBold.copyWith(fontSize: 16,color: JobColor.appcolor))),
                ],
              ),
              SizedBox(height: height/36,),
              ListView.separated(
                itemCount: _reports.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  final userProvider = Provider.of<UserProvider>(context);
                  final reportUser = userProvider.getReportUser(report.userId);

                  if (reportUser == null) {
                    // If user is not yet available, fetch it
                    userProvider.fetchUserById(report.userId);

                    return const CircularProgressIndicator(); // Show loading indicator while fetching
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ReportDetail(report: report);
                        },
                      ));
                    },
                    child: Container(
                      width: width / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: themedata.isdark ? JobColor.borderblack : JobColor.bggray),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 46),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: height / 12,
                                  width: height / 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
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
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width / 1.8,
                                          child: Text(
                                            report.address,
                                            style: urbanistSemiBold.copyWith(fontSize: 20),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: width / 56),

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundImage: reportUser.profilePicturePath.isNotEmpty
                                              ? NetworkImage(reportUser.profilePicturePath)
                                              : AssetImage(JobPngimage.profile) as ImageProvider,
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
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height / 96),
                            Divider(color: themedata.isdark ? JobColor.borderblack : JobColor.bggray),
                            SizedBox(height: height / 96),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Severity : ", style: urbanistBold.copyWith(fontSize: 19, color: JobColor.appcolor)),
                                Text(report.severity.toString(), style: urbanistMedium.copyWith(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(height: height / 46);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
