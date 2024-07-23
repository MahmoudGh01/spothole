import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/ViewModels/report_provider.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:provider/provider.dart';
import '../../../ViewModels/authority_provider.dart';
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

  List color = [
    const Color(0x1A246BFD),
    const Color(0x1A246BFD),
    const Color(0x1AFF9800),
    const Color(0x1AF75555),
    const Color(0x1A4CAF50),
  ];

  List textcolor = [
    const Color(0xff246BFD),
    const Color(0xff246BFD),
    const Color(0xffFACC15),
    const Color(0xffF75555),
    const Color(0xff07BD74),
  ];

  //List reports = ["Pothole on Main St.", "Pothole on Elm St.", "Pothole on Pine St.", "Pothole on Maple St."];
  //List locations = ["Main Street", "Elm Street", "Pine Street", "Maple Street"];
 // List applicationsicon = [
   // JobPngimage.p6,
   // JobPngimage.p6,
   // JobPngimage.p6,
    //JobPngimage.p6,
 // ];

  List status = ["Report Pending", "Report Pending", "Report Rejected", "Report Resolved"];

  @override
  void initState() {
    super.initState();
    Provider.of<AuthorityProvider>(context, listen: false).fetchAllReports();
  }
  @override
  Widget build(BuildContext context) {
    final postMdl = Provider.of<AuthorityProvider>(context);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset(JobPngimage.logo,height: height/36,),
        ),
        title: Text("Pothole Reports".tr,style: urbanistBold.copyWith(fontSize: 22 )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(JobPngimage.more,height: height/36,color: themedata.isdark?JobColor.white:JobColor.black,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            children: [
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16,),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Search".tr,
                 fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  prefixIcon:Icon(Icons.search_rounded,size: height/36,color: JobColor.textgray,),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(JobPngimage.filter,height: height/36,),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/36,),
              ListView.separated(
                itemCount: postMdl.reports.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: JobColor.transparent,
                    highlightColor: JobColor.transparent,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const JobApplicationStages();
                      },));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: height/13,
                              width: height/13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(JobPngimage.p6,height: height/36,),
                              ),
                            ),
                            SizedBox(width: width/26,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width: width/1.8,
                                        child: Text(postMdl.reports[index].description,style: urbanistSemiBold.copyWith(fontSize: 19 ),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                                SizedBox(height: height/80,),
                                Text(postMdl.reports[index].longitude,style: urbanistMedium.copyWith(fontSize: 16 ,color: JobColor.textgray),maxLines: 1,overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                            const Spacer(),
                            Icon(Icons.arrow_forward_ios,size: height/46,)
                          ],
                        ),
                        SizedBox(height: height/80,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height/20,
                              width: height/13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: JobColor.transparent)
                              ),
                            ),
                            SizedBox(width: width/26,),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: color[index]
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/110),
                                child: Text(postMdl.reports[index].status,style: urbanistSemiBold.copyWith(fontSize: 10,color: textcolor[index])),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      const Divider(),
                      SizedBox(height: height/80,),
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
