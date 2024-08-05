import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/Utils/constants.dart';
import '../../../ViewModels/userprovider.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';


class JobEditprofile extends StatefulWidget {
  const JobEditprofile({Key? key}) : super(key: key);

  @override
  State<JobEditprofile> createState() => _JobEditprofileState();
}

class _JobEditprofileState extends State<JobEditprofile> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile".tr, style: urbanistBold.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(JobPngimage.profile),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: height / 26,
                          height: height / 26,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: JobColor.appcolor
                          ),
                          child: const Icon(Icons.edit_sharp, size: 22, color: JobColor.white,),
                        ))
                  ],
                ),
              ),
              SizedBox(height: height / 30,),
              Text("Full_name".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66,),
              TextField(
                controller: fullNameController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray,),
                  hintText: "Full_name".tr,
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
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
              SizedBox(height: height / 46,),
              Text("Middle_Name".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66,),
              TextField(
                controller: middleNameController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray,),
                  hintText: "Middle_Name".tr,
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
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
              SizedBox(height: height / 46,),
              Text("Last_Name".tr, style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(height: height / 66,),
              TextField(
                controller: lastNameController,
                style: urbanistSemiBold.copyWith(fontSize: 16,),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray,),
                  hintText: "Last_Name".tr,
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
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
              SizedBox(height: height / 46,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 56),
        child: InkWell(
          splashColor: JobColor.transparent,
          highlightColor: JobColor.transparent,
          onTap: () async {
            await userProvider.editUser(
              userId: userProvider.user.id,
              name: fullNameController.text,
              email: userProvider.user.email,
              lastname: lastNameController.text,
              phone: userProvider.user.phone,
              birthdate: userProvider.user.birthdate,
            );
            Navigator.pop(context); // Navigate back after saving
          },
          child: Container(
            height: height / 15,
            width: width / 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: JobColor.appcolor,
            ),
            child: Center(
              child: Text("Save".tr, style: urbanistSemiBold.copyWith(fontSize: 16, color: JobColor.white)),
            ),
          ),
        ),
      ),
    );
  }
}
