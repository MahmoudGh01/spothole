import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';

class JobCertification extends StatefulWidget {
  const JobCertification({Key? key}) : super(key: key);

  @override
  State<JobCertification> createState() => _JobCertificationState();
}

class _JobCertificationState extends State<JobCertification> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  bool isDark = true;
  bool isChecked = true;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return JobColor.appcolor;
    }
    return JobColor.appcolor;
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Certification_and_Licenses".tr,style: urbanistBold.copyWith(fontSize: 22 )),
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
                  filled: true,
               //   fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
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
              Text("Publishing_Organization".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Publishing_Organization".tr,
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
                          Text("Date_of_Issue".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                          SizedBox(height: height/66,),
                          TextField(
                            style: urbanistSemiBold.copyWith(fontSize: 16),
                            decoration: InputDecoration(
                              hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                              hintText: "Date_of_Issue".tr,
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
                          Text("Expiration_Date".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                          SizedBox(height: height/66,),
                          TextField(
                            style: urbanistSemiBold.copyWith(fontSize: 16),
                            decoration: InputDecoration(
                              hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                              hintText: "Expiration_Date".tr,
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
                  Checkbox(
                    checkColor: JobColor.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    side: const BorderSide(
                      color: JobColor.appcolor,
                      width: 2.5,
                    ),
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(
                            () {
                          isChecked = value!;
                        },
                      );
                    },
                  ),
                  Text("This credential will not expire".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
                ],
              ),
              SizedBox(height: height/46,),
              Text("Credential_ID".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Credential_ID".tr,
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
              Text("Credential_URL".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Credential_URL".tr,
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
