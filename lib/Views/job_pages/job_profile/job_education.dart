import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';

class JobEducation extends StatefulWidget {
  const JobEducation({Key? key}) : super(key: key);

  @override
  State<JobEducation> createState() => _JobEducationState();
}

class _JobEducationState extends State<JobEducation> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  bool isDark = true;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Education".tr,style: urbanistBold.copyWith(fontSize: 22 )),
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
              Text("Educational_Attainment".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Completed Master’s Degree".tr,
                  fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                    suffixIcon:Icon(Icons.arrow_drop_down_sharp,size: height/36,color: JobColor.textgray,),
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
              Text("Course".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Computer Science".tr,
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
              Text("School".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "school".tr,
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
              Row(
                children: [
                  SizedBox(
                    width: width/2.2,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("From".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                          SizedBox(height: height/66,),
                          TextField(
                            style: urbanistSemiBold.copyWith(fontSize: 16),
                            decoration: InputDecoration(
                              hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                              hintText: "select".tr,
                              fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                              filled: true,
                              suffixIcon: Icon(Icons.arrow_drop_down_sharp,size: height/36,),
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
                      )),
                  const Spacer(),
                  SizedBox(
                      width: width/2.2,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("To".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                          SizedBox(height: height/66,),
                          TextField(
                            style: urbanistSemiBold.copyWith(fontSize: 16),
                            decoration: InputDecoration(
                              hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                              hintText: "select".tr,
                              fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                              filled: true,
                              suffixIcon: Icon(Icons.arrow_drop_down_sharp,size: height/36,),
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
                      )),
                ],
              ),
              SizedBox(height: height/46,),
              Row(
                children: [
                  Text("Graduated".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                  SizedBox(width: width/26,),
                  SizedBox(
                    height: height / 36,
                    child: Switch(
                        activeColor: JobColor.appcolor,
                        onChanged: (state) {
                          setState(() {
                            isDark = state;
                          });
                        },
                        value: isDark),
                  ),
                ],
              ),
              SizedBox(height: height/66,),
              Row(
                children: [
                  SizedBox(
                      width: width/2.2,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("GPA".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                          SizedBox(height: height/66,),
                          TextField(
                            style: urbanistSemiBold.copyWith(fontSize: 16),
                            decoration: InputDecoration(
                              hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                              hintText: "GPA".tr,
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
                      )),
                  const Spacer(),
                  SizedBox(
                      width: width/2.2,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Scale".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                          SizedBox(height: height/66,),
                          TextField(
                            style: urbanistSemiBold.copyWith(fontSize: 16),
                            decoration: InputDecoration(
                              hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                              hintText: "select".tr,
                              fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                              filled: true,
                              suffixIcon: Icon(Icons.arrow_drop_down_sharp,size: height/36,),
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
                      )),
                ],
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
              SizedBox(height: height/46,),
              Text("Add_Media".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
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
