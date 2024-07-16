import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_seeker/Views/job_pages/job_home/job_dashboard.dart';
import 'package:job_seeker/Utils/utils.dart';
import '../job_pages/job_theme/job_themecontroller.dart';
import 'home_screen.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import '../job_gloabelclass/job_fontstyle.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  final themedata = Get.put(JobThemecontroler());
  bool isLoading = false;
  bool isresend = false;
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        isresend = true;
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  dynamic size;
  double height = 0.00;
  double width = 0.00;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final minutes = strDigits(myDuration.inMinutes.remainder(2));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: Text("OTP_Code_Verification".tr,
            style: urbanistBold.copyWith(fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Code has been sent to your number".tr,
              style: urbanistMedium.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                fillColor: themedata.isdark
                    ? JobColor.lightblack
                    : JobColor.appgray,
                filled: true,
                hintText: "Enter OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: urbanistSemiBold.copyWith(fontSize: 20),
              cursorColor: JobColor.textgray,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : InkWell(
              splashColor: JobColor.transparent,
              highlightColor: JobColor.transparent,
              onTap: () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  final cred = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: otpController.text);

                  await FirebaseAuth.instance.signInWithCredential(cred);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  JobDashboard("0"),
                    ),
                  );
                } catch (e) {
                  log(e.toString());
                  showSnackBar(context, e.toString());
                }
                setState(() {
                  isLoading = false;
                });
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Resend_code_in".tr,
                    style: urbanistRegular.copyWith(fontSize: 16)),
                SizedBox(width: 10),
                Text("${minutes.toString()}:${seconds.toString()}s".tr,
                    style: urbanistMedium.copyWith(
                        fontSize: 16, color: JobColor.appcolor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
