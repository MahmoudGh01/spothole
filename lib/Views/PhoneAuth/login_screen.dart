import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../Utils/alert_dialog.dart';
import '../job_gloabelclass/job_color.dart';
import '../job_gloabelclass/job_fontstyle.dart';
import '../job_gloabelclass/job_icons.dart';
import '../job_pages/job_theme/job_themecontroller.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Authentication".tr,
            style: urbanistBold.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 26, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:
                    Image.asset(JobPngimage.forgotpassword, height: height / 4),
              ),
              SizedBox(height: height / 36),
              Text(
                "Please insert phone number to SignIn".tr,
                style: urbanistRegular.copyWith(fontSize: 14),
              ),
              SizedBox(height: height / 36),
              IntlPhoneField(
                controller: phoneController,
                flagsButtonPadding: const EdgeInsets.all(8),
                dropdownIconPosition: IconPosition.trailing,
                style: urbanistSemiBold.copyWith(fontSize: 16),
                keyboardType: TextInputType.number,
                dropdownTextStyle: urbanistSemiBold.copyWith(
                  fontSize: 16,
                  color: themedata.isdark ? JobColor.white : JobColor.textgray,
                ),
                disableLengthCheck: true,
                decoration: InputDecoration(
                  hintText: "00000000000",
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
              const SizedBox(height: 20),
              isloading
                  ? const Center(child: CircularProgressIndicator())
                  : InkWell(
                      splashColor: JobColor.transparent,
                      highlightColor: JobColor.transparent,
                      onTap: () async {
                        setState(() {
                          isloading = true;
                        });

                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: "+216" + phoneController.text,
                          verificationCompleted: (phoneAuthCredential) {},
                          verificationFailed: (error) {
                            log(error.toString());
                            showDialog(
                              context: context,
                              builder: (context) => GlobalAlertDialog(
                                imagePath: 'fail.json',
                                title: 'Oops, Failed!',
                                titleColor: Colors.red,
                                message: error.toString(),
                                primaryButtonText: 'Try Again',
                                primaryButtonAction: () {
                                  // Retry action
                                },
                                secondaryButtonText: 'Cancel',
                                secondaryButtonAction: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                            setState(() {
                              isloading = false;
                            });
                          },
                          codeSent: (verificationId, forceResendingToken) {
                            setState(() {
                              isloading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OTPScreen(verificationId: verificationId),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (verificationId) {
                            log("Auto Retrieval timeout");
                            setState(() {
                              isloading = false;
                            });
                          },
                        );
                      },
                      child: Container(
                        height: height / 15,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: JobColor.appcolor,
                        ),
                        child: Center(
                          child: Text(
                            "Sign in".tr,
                            style: urbanistSemiBold.copyWith(
                                fontSize: 16, color: JobColor.white),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
