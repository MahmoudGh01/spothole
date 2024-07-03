import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/job/job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';

class JobResume extends StatefulWidget {
  const JobResume({Key? key}) : super(key: key);

  @override
  State<JobResume> createState() => _JobResumeState();
}

class _JobResumeState extends State<JobResume> {
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
      appBar: AppBar(
        title: Text("CV_Resume".tr,style: urbanistBold.copyWith(fontSize: 22 )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload CV/Resume".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              Container(
                width: width/1,
                height: height/6,
                decoration: BoxDecoration(
                    color: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(JobPngimage.uploadfile,height: height/26,),
                    SizedBox(height: height/36,),
                    Text("Browse_File".tr,style: urbanistSemiBold.copyWith(fontSize: 14,color: JobColor.textgray)),
                  ],
                ),
              ),
              SizedBox(height: height/36,),
              Container(
                width: width/1,
                decoration: BoxDecoration(
                    color: const Color(0x1AF75555),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/66),
                  child: Row(
                    children: [
                      Image.asset(JobPngimage.pdf,height: height/15,fit: BoxFit.fitHeight,),
                      SizedBox(width: width/36,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("CV - Achref Chaabani.pdf".tr,style: urbanistSemiBold.copyWith(fontSize: 16,)),
                          Text("825 Kb".tr,style: urbanistMedium.copyWith(fontSize: 12,color: JobColor.textgray)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.close,size: 20,color: JobColor.red)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/56),
        child: InkWell(
          splashColor:JobColor.transparent,
          highlightColor:JobColor.transparent,
          onTap: () {
          },
          child: Container(
            height: height/15,
            width: width/1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color:JobColor.appcolor,
            ),
            child: Center(
              child: Text("Save".tr,style: urbanistSemiBold.copyWith(fontSize: 16,color:JobColor.white)),
            ),
          ),
        ),
      ),
    );
  }
}
