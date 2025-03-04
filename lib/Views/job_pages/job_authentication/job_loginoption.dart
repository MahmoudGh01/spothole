import 'dart:convert';
import 'dart:developer' as Log ;
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_seeker/Views/PhoneAuth/login_screen.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/Views/job_pages/job_home/job_dashboard.dart';
import '../../../Services/Auth.dart';
import '../../../Utils/alert_dialog.dart';
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
  final AuthService authService = AuthService();
  late GoogleSignIn googleSignIn;  // Use 'late' because we'll initialize this later.

  @override
  void initState() {
    super.initState();
    initializeGoogleSignIn();  // Initialize GoogleSignIn after client ID is set.
  }

  void initializeGoogleSignIn() {
    String clientId = getClientId();

    googleSignIn = GoogleSignIn(
      clientId: clientId,
      scopes: ['email'],
    );
  }

  String getClientId() {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_CLIENT_ID']!;
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_CLIENT_ID']!;
    } else {
      throw UnsupportedError("This platform is not supported");
    }
  }
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
        padding:
            EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
        child: Column(
          children: [
            SizedBox(
              height: height / 10,
            ),
            Image.asset(
              JobPngimage.loginoption,
              height: height / 4.5,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: height / 26,
            ),
            Text("Lets_you_in".tr, style: urbanistBold.copyWith(fontSize: 40)),
            SizedBox(
              height: height / 23,
            ),
            InkWell(
              onTap: () async {
                try {
                  await _signInWithFacebook();

                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return JobDashboard("0");
                    },
                  ));
                } catch (e) {
                  print(e.toString());
                  showDialog(
                    context: context,
                    builder: (context) => GlobalAlertDialog(
                      imagePath: 'fail.json',
                      title: 'Oops, Failed!',
                      titleColor: Colors.red,
                      message: e.toString(),
                      primaryButtonText: 'Try Again',
                      primaryButtonAction: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return const JobLoginoption();
                          },
                        ));
                      },
                      secondaryButtonText: 'Cancel',
                      secondaryButtonAction: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                }
                /*  Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return JobDashboard("0");
                  },
                ));*/
              },
              child: Container(
                height: height / 15,
                width: width / 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: themedata.isdark
                            ? JobColor.borderblack
                            : JobColor.bggray)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      JobPngimage.facebook,
                      height: height / 30,
                    ),
                    SizedBox(
                      width: width / 36,
                    ),
                    Text("Continue_with_Facebook".tr,
                        style: urbanistSemiBold.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height / 46,
            ),
            InkWell(
              onTap: () async {
   /*             try {
                  await _handleSignIn();
                } catch (error) {
                  print('Error during Google Sign-In: $error');
                }*/
                try {
                  final UserCredential userCredential =
                      await signInWithGoogle();

                  if (context.mounted) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return JobDashboard("0");
                      },
                    ));
                  }
                } catch (e) {
                  print(e.toString());
                  Log.log(e.toString());
                  showDialog(
                    context: context,
                    builder: (context) => GlobalAlertDialog(
                      imagePath: 'fail.json',
                      title: 'Oops, Failed!',
                      titleColor: Colors.red,
                      message: e.toString(),
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
                }
              },
              child: Container(
                height: height / 15,
                width: width / 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: themedata.isdark
                            ? JobColor.borderblack
                            : JobColor.bggray)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      JobPngimage.google,
                      height: height / 30,
                    ),
                    SizedBox(
                      width: width / 36,
                    ),
                    Text("Continue_with_Google".tr,
                        style: urbanistSemiBold.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height / 46,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return JobLogin();
                  },
                ));
              },
              child: Container(
                height: height / 15,
                width: width / 1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: themedata.isdark
                            ? JobColor.borderblack
                            : JobColor.bggray)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      JobPngimage.email,
                      height: height / 30,
                      color: themedata.isdark ? JobColor.white : JobColor.black,
                    ),
                    SizedBox(
                      width: width / 36,
                    ),
                    Text("Sign_in_with_password".tr,
                        style: urbanistSemiBold.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height / 26,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: height / 500,
                    width: width / 2.4,
                    color: themedata.isdark
                        ? JobColor.borderblack
                        : JobColor.bggray),
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
                    color: themedata.isdark
                        ? JobColor.borderblack
                        : JobColor.bggray),
              ],
            ),
            SizedBox(
              height: height / 26,
            ),
            const Spacer(),
            InkWell(
              splashColor: JobColor.transparent,
              highlightColor: JobColor.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ));
              },
              child: Container(
                height: height / 15,
                width: width / 1,
                decoration: BoxDecoration(
                  color: JobColor.appcolor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                    child: Text(
                  "Sign in with Phone".tr,
                  style: urbanistBold.copyWith(
                      fontSize: 16, color: JobColor.white),
                )),
              ),
            ),
            SizedBox(
              height: height / 36,
            ),
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

/*  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    print("Token: ${loginResult.accessToken?.tokenString}");
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }*/

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String generateNonce([int length = 32]) {
    // Define the character set to be used in the nonce
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-.';

    // Create a secure random number generator
    final random = Random.secure();

    // Generate a string of the specified length using random characters from the charset
    return String.fromCharCodes(List.generate(
        length, (index) => charset.codeUnitAt(random.nextInt(charset.length))));
  }

  Future<void> _signInWithFacebook() async {
    // Trigger the sign-in flow
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final result = await FacebookAuth.instance.login(
      loginTracking: LoginTracking.limited,
      nonce: nonce,
    );

    if (result.status == LoginStatus.success) {
      print("Access token : ${result.accessToken!.tokenString }");
      final token = result.accessToken ;
      // Create a credential from the access token
      OAuthCredential credential = OAuthCredential(
        providerId: 'facebook.com',
        signInMethod: 'oauth',
        accessToken: token!.tokenString,
        rawNonce: rawNonce,
      );
      await authService.sendFBSignInDataToBackend(token!.tokenString ,context);
     //await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }


  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final String? code = googleAuth?.idToken;

    if (code != null) {
      await authService.sendGoogleSignInDataToBackend(code, context);
    }
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

}
