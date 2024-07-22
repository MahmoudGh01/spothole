import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_login.dart';
import 'job_signup.dart';

class JobLoginoption extends StatefulWidget {
  const JobLoginoption({Key? key}) : super(key: key);

  @override
  State<JobLoginoption> createState() => _JobLoginoptionState();
}

class _JobLoginoptionState extends State<JobLoginoption> {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
        child: Column(
          children: [
            SizedBox(height: height/10,),
            Image.asset(JobPngimage.loginoption,height: height/4.5,fit: BoxFit.fitHeight,),
            SizedBox(height: height/26,),
            Text("Lets_you_in".tr,style: urbanistBold.copyWith(fontSize: 40)),
            SizedBox(height: height/23,),
            InkWell(
          onTap: () async {
            try {
              final UserCredential userCredential = await signInWithFacebook();
              if (context.mounted) {

              }
            } catch (e) {
print(e.toString());
            }
          },
              child: Container(
                height: height/15,
                width: width/1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(JobPngimage.facebook,height: height/30,),
                    SizedBox(width: width/36,),
                    Text("Continue_with_Facebook".tr,style: urbanistSemiBold.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ),
            SizedBox(height: height/46,),
            Container(
              height: height/15,
              width: width/1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(JobPngimage.google,height: height/30,),
                  SizedBox(width: width/36,),
                  Text("Continue_with_Google".tr,style: urbanistSemiBold.copyWith(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: height/46,),
            Container(
              height: height/15,
              width: width/1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(JobPngimage.apple,height: height/30,color: themedata.isdark?JobColor.white:JobColor.black,),
                  SizedBox(width: width/36,),
                  Text("Continue_with_Apple".tr,style: urbanistSemiBold.copyWith(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: height/26,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: height / 500,
                    width: width / 2.4,
                    color: themedata.isdark?JobColor.borderblack:JobColor.bggray),
                SizedBox(width: width / 56),
                Text(
                  "OR".tr,
                  style: urbanistSemiBold.copyWith(
                      fontSize: 15, color: JobColor.textgray),
                ),
                SizedBox(width: width / 56),
                Container(
                    height: height / 500,
                    width: width / 2.4,
                    color: themedata.isdark?JobColor.borderblack:JobColor.bggray),
              ],
            ),
            SizedBox(height: height/26,),
            const Spacer(),
            InkWell(
              splashColor: JobColor.transparent,
              highlightColor: JobColor.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const JobLogin();
                  },
                ));
              },
              child: Container(
                height: height/15,
                width: width/1,
                decoration: BoxDecoration(
                  color: JobColor.appcolor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(child: Text("Sign_in_with_password".tr,style: urbanistBold.copyWith(fontSize: 16,color: JobColor.white),)),
              ),
            ),
            SizedBox(height: height/36,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dont_have_an_account'.tr,
                    style: urbanistRegular.copyWith(
                        fontSize: 14, color: JobColor.textgray)),
                InkWell(
                  splashColor: JobColor.transparent,
                  highlightColor: JobColor.transparent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const JobSignup();
                      },
                    ));
                  },
                  child: Text('Sign_up'.tr,
                      style: urbanistSemiBold.copyWith(
                          fontSize: 14, color: JobColor.appcolor)),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
