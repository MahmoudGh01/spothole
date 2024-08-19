import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_pages/job_profile/job_setting/job_setting.dart';
import 'package:provider/provider.dart';
import '../../../ViewModels/userprovider.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_application/job_application.dart';
import '../job_theme/job_themecontroller.dart';

import 'job_contactinfo.dart';
import 'job_editprofile.dart';


import 'job_resume.dart';




class JobProfile extends StatefulWidget {
  const JobProfile({Key? key}) : super(key: key);

  @override
  State<JobProfile> createState() => _JobProfileState();
}

class _JobProfileState extends State<JobProfile> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset(JobPngimage.logo,height: height/36,),
        ),
        title: Text("Profile".tr,style: urbanistBold.copyWith(fontSize: 22 )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const JobSetting();
                  },));
                },
                child: Image.asset(JobPngimage.setting,height: height/36,color: themedata.isdark? JobColor.white:JobColor.black,)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: user.profilePicturePath.isNotEmpty
                        ? NetworkImage(user.profilePicturePath)
                        :  AssetImage(JobPngimage.profile) as ImageProvider,
                  ),
                  SizedBox(width: width/26,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height/120,),
                      Text(user.name,style: urbanistBold.copyWith(fontSize: 22 )),
                      SizedBox(height: height/120,),
                     Text(user.phone,style: urbanistMedium.copyWith(fontSize: 15,color: JobColor.textgray)),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    splashColor: JobColor.transparent,
                    highlightColor: JobColor.transparent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const JobEditprofile();
                        },));
                      },
                      child: Image.asset(JobPngimage.editicon,height: height/30,color: JobColor.appcolor))
                ],
              ),
              SizedBox(height: height/56,),
              const Divider(),
              SizedBox(height: height/56,),
              InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const JobContactInfo();
                  },));
                },
                child: Container(
                  width: width/1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/30,vertical: height/56),
                    child: Row(
                      children: [
                        Image.asset(JobPngimage.profileicon,height: height/36,color: JobColor.appcolor,),
                        SizedBox(width: width/36,),
                        Text("Contact_Information".tr,style: urbanistBold.copyWith(fontSize: 18 )),
                        const Spacer(),
                        Image.asset(JobPngimage.plus,height: height/30,color: JobColor.appcolor),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height/46,),

              InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return  JobApplication();
                  },));
                },
                child: Container(
                  width: width/1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/30,vertical: height/56),
                    child: Row(
                      children: [
                        Image.asset(JobPngimage.graph,height: height/36,color: JobColor.appcolor,),
                        SizedBox(width: width/36,),
                        Text("My Reports".tr,style: urbanistBold.copyWith(fontSize: 18 )),
                        const Spacer(),
                        Image.asset(JobPngimage.plus,height: height/30,color: JobColor.appcolor),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height/46,),

              InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const JobResume();
                  },));
                },
                child: Container(
                  width: width/1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/30,vertical: height/56),
                    child: Row(
                      children: [
                        Image.asset(JobPngimage.paper,height: height/36,color: JobColor.appcolor,),
                        SizedBox(width: width/36,),
                        Text("Reported images".tr,style: urbanistBold.copyWith(fontSize: 18 )),
                        const Spacer(),
                        Image.asset(JobPngimage.plus,height: height/30,color: JobColor.appcolor),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height/30,),
              Text("Add_Custom_Section".tr,style: urbanistBold.copyWith(fontSize: 16,color: JobColor.appcolor)),
            ],
          ),
        ),
      ),
    );
  }
}
