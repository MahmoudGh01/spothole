import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/Views/job_pages/job_home/job_dashboard.dart';
import 'package:provider/provider.dart';
import '../../../../Services/Auth.dart';
import '../../../../ViewModels/userprovider.dart';
import '../../../job_gloabelclass/job_fontstyle.dart';
import '../../job_theme/job_themecontroller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'job_createnewpin.dart';
import 'job_setfacerecognition.dart';
class JobFillProfile extends StatefulWidget {
  const JobFillProfile({Key? key}) : super(key: key);

  @override
  State<JobFillProfile> createState() => _JobFillProfileState();
}

class _JobFillProfileState extends State<JobFillProfile> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  final AuthService authService = Get.find<AuthService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Fill_Your_Profile".tr, style: urbanistBold.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
          child: Column(
            children: [
              Stack(
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
              SizedBox(height: height / 30,),
              TextField(
                controller: nameController,
                style: urbanistSemiBold.copyWith(fontSize: 16,),
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
              TextField(
                controller: dobController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray,),
                  hintText: "DOB".tr,
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  suffixIcon: Icon(Icons.calendar_month_rounded, size: height / 36, color: JobColor.textgray,),
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
              TextField(
                controller: emailController,
                style: urbanistSemiBold.copyWith(fontSize: 16,),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray,),
                  hintText: userProvider.user.email,
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  suffixIcon: Icon(Icons.email_outlined, size: height / 36, color: JobColor.textgray,),
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
              IntlPhoneField(
                controller: phoneController,
                flagsButtonPadding: const EdgeInsets.all(8),
                dropdownIconPosition: IconPosition.trailing,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                keyboardType: TextInputType.number,
                disableLengthCheck: true,
                dropdownTextStyle: urbanistSemiBold.copyWith(fontSize: 16, color: themedata.isdark ? JobColor.white : JobColor.textgray,),
                decoration: InputDecoration(
                  hintText: "00000000000",
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  hintStyle: urbanistRegular,
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: JobColor.appcolor)
                  ),
                ),
                initialCountryCode: 'TN',
                onChanged: (phone) {},
              ),
              SizedBox(height: height / 46,),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 56),
        child: Row(
          children: [
            InkWell(
              splashColor: JobColor.transparent,
              highlightColor: JobColor.transparent,
              onTap: () {
                /* Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const JobSelectexpertise();
                },));*/
              },
              child: Container(
                height: height / 15,
                width: width / 2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: JobColor.lightblue,
                ),
                child: Center(
                  child: Text("Skip".tr, style: urbanistSemiBold.copyWith(fontSize: 16, color: JobColor.appcolor)),
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              splashColor: JobColor.transparent,
              highlightColor: JobColor.transparent,
              onTap: () async {
                await userProvider.editUser(
                  userId: userProvider.user.id,
                  name: nameController.text,
                  email: userProvider.user.email,
                  //lastname: lastNameController.text,
                  phone: "+216"+phoneController.toString(),
                  birthdate: dobController.text,
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return  JobDashboard("0");
                },)); // Navigate back after saving
              },
              child: Container(
                height: height / 15,
                width: width / 2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: JobColor.appcolor,
                ),
                child: Center(
                  child: Text("Continue".tr, style: urbanistSemiBold.copyWith(fontSize: 16, color: JobColor.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
