import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';

class JobSkills extends StatefulWidget {
  const JobSkills({Key? key}) : super(key: key);

  @override
  State<JobSkills> createState() => _JobSkillsState();
}

class _JobSkillsState extends State<JobSkills> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  List skills = ["Design Thinking","UI & UX Design","Graphic Design","Web Design","Figma"];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Skills".tr,style: urbanistBold.copyWith(fontSize: 22 )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Skills".tr,style: urbanistMedium.copyWith(fontSize: 16 )),
              SizedBox(height: height/66,),
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Type here".tr,
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: skills.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                    childAspectRatio: (height / 1.4) / (width / 2.5)),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: JobColor.transparent,
                    highlightColor: JobColor.transparent,
                    onTap: () {},
                    child: Container(
                      height: height / 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: JobColor.appcolor),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 36),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width/3.5,
                              child: Center(
                                child: Text(skills[index],
                                    style: urbanistSemiBold.copyWith(
                                        fontSize: 15, color: JobColor.appcolor),maxLines: 1,overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            SizedBox(width: width/36,),
                            const Icon(Icons.close,size: 22,color: JobColor.appcolor),
                          ],
                        ),
                      ),
                    ),
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

