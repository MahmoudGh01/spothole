import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/Utils/constants.dart';
import '../../../ViewModels/report_provider.dart';
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
  final TextEditingController dobController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<File?> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
    return _profileImage;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var reportProvider = Provider.of<ReportProvider>(context, listen: false);
    /*  fullNameController.text = userProvider.user.name;
    dobController.text = userProvider.user.birthdate;
    phoneController.text = userProvider.user.phone;*/
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile".tr, style: urbanistBold.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    InkWell(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : userProvider.user.profilePicturePath.isNotEmpty
                                ? NetworkImage(
                                    userProvider.user.profilePicturePath)
                                : AssetImage(JobPngimage.profile)
                                    as ImageProvider,
                      ),
                      onTap: () async {
                        final pickedFile = await _pickImage();
                        setState(() {
                          if (pickedFile != null) {
                            _profileImage = File(pickedFile.path);
                            // user.profilePicturePath = _profileImage!.path;
                          }
                        });
                      },
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: height / 26,
                          height: height / 26,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: JobColor.appcolor),
                          child: const Icon(
                            Icons.edit_sharp,
                            size: 22,
                            color: JobColor.white,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: height / 30,
              ),
              Text("Full_name".tr,
                  style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(
                height: height / 66,
              ),
              TextField(
                controller: fullNameController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(
                    fontSize: 16,
                    color: JobColor.textgray,
                  ),
                  hintText: userProvider.user.name,
                  fillColor:
                      themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)),
                ),
              ),
              SizedBox(
                height: height / 46,
              ),
              TextField(
                controller: dobController,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(
                    fontSize: 16,
                    color: JobColor.textgray,
                  ),
                  hintText: userProvider.user.birthdate,
                  fillColor:
                      themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.calendar_month_rounded,
                    size: height / 36,
                    color: JobColor.textgray,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)),
                ),
              ),
              SizedBox(
                height: height / 46,
              ),
              Text("Last_Name".tr,
                  style: urbanistMedium.copyWith(fontSize: 16)),
              SizedBox(
                height: height / 66,
              ),
              TextField(
                controller: lastNameController,
                style: urbanistSemiBold.copyWith(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(
                    fontSize: 16,
                    color: JobColor.textgray,
                  ),
                  hintText: "Last_Name".tr,
                  fillColor:
                      themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: JobColor.appcolor)),
                ),
              ),
              SizedBox(
                height: height / 46,
              ),
              IntlPhoneField(
                initialValue: userProvider.user.phone.toString(),
                controller: phoneController,
                flagsButtonPadding: const EdgeInsets.all(8),
                dropdownIconPosition: IconPosition.trailing,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                keyboardType: TextInputType.number,
                disableLengthCheck: true,
                dropdownTextStyle: urbanistSemiBold.copyWith(
                  fontSize: 16,
                  color: themedata.isdark ? JobColor.white : JobColor.textgray,
                ),
                decoration: InputDecoration(
                  hintText: userProvider.user.phone,
                  fillColor:
                      themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  hintStyle: urbanistRegular,
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: JobColor.appcolor)),
                ),
                initialCountryCode: 'TN',
                onChanged: (phone) {},
              ),
              SizedBox(
                height: height / 46,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 56),
        child: InkWell(
          splashColor: JobColor.transparent,
          highlightColor: JobColor.transparent,
          onTap: () async {
            String? fileUrl = await reportProvider.uploadFile(_profileImage!);
            await userProvider.editUser(
              profilePicturePath: fileUrl,
              userId: userProvider.user.id,
              name: fullNameController.text.isNotEmpty
                  ? fullNameController.text
                  : userProvider
                      .user.name, // Use provider's name if controller is empty
              email:
                  userProvider.user.email, // Email is fetched from the provider
              lastname: lastNameController.text.isNotEmpty
                  ? lastNameController.text
                  : userProvider.user.lastname, // Uncomment and adapt if needed
              phone: phoneController.text.isNotEmpty
                  ? "+216" + phoneController.text
                  : userProvider.user
                      .phone, // Use provider's phone if controller is empty
              birthdate: dobController.text.isNotEmpty
                  ? dobController.text
                  : userProvider.user
                      .birthdate, // Use provider's birthdate if controller is empty
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
              child: Text("Save".tr,
                  style: urbanistSemiBold.copyWith(
                      fontSize: 16, color: JobColor.white)),
            ),
          ),
        ),
      ),
    );
  }
}
