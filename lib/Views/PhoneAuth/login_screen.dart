import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        title: Text("Phone Authentication".tr, style: urbanistBold.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(JobPngimage.forgotpassword, height: height / 4),
              ),
              SizedBox(height: height / 36),
              Text(
                "Please insert phone number to SignIn".tr,
                style: urbanistRegular.copyWith(fontSize: 14),
              ),
              SizedBox(height: height / 36),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.withOpacity(0.25),
                  filled: true,
                  hintText: "Enter Phone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              isloading
                  ? Center(child: CircularProgressIndicator())
                  : InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () async {
                  setState(() {
                    isloading = true;
                  });

                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                    verificationCompleted: (phoneAuthCredential) {},
                    verificationFailed: (error) {
                      log(error.toString());
                      showDialog(
                        context: context,
                        builder: (context) => GlobalAlertDialog(
                          imagePath: JobPngimage.applyfail,
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
                          builder: (context) => OTPScreen(verificationId: verificationId),
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
                      style: urbanistSemiBold.copyWith(fontSize: 16, color: JobColor.white),
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
