import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';


class JobProfessionalExams extends StatefulWidget {
  const JobProfessionalExams({Key? key}) : super(key: key);

  @override
  State<JobProfessionalExams> createState() => _JobProfessionalExamsState();
}

class _JobProfessionalExamsState extends State<JobProfessionalExams> {
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
        title: Text("Professional_Exams".tr,style: urbanistBold.copyWith(fontSize: 22 )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(13),
            child: Image.asset(JobPngimage.delete,height: height/36,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Title".tr,
                  fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/46,),
              Text("Score".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Score".tr,
                  fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/46,),
              Text("Date_Taken".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Date_Taken".tr,
                  fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  suffixIcon:Icon(Icons.arrow_drop_down_sharp,size: height/36,color: JobColor.textgray,),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/46,),
              Text("Description".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                maxLines: 6,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Description".tr,
                  fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,

                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),

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
