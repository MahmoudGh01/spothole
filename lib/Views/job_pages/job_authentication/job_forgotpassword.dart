import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import '../../../Services/Auth.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_otpverification.dart';

class JobForgotPassword extends StatefulWidget {
  const JobForgotPassword({Key? key}) : super(key: key);

  @override
  State<JobForgotPassword> createState() => _JobForgotPasswordState();
}

class _JobForgotPasswordState extends State<JobForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

  void submitEmail(BuildContext context) {
    final email = emailController.text;
    authService.forgotPassword(context: context, email: email);
    // Pass the email to the Verification Code screen
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const JobOtpverification(email: '',);
    },
    )
    );
  }
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  int selectindex = 0;
  List name = ["via SMS:","via Email:"];
  List subname = ["+1 111 ******99","and***ley@yourdomain.com"];
  List image = [
    JobPngimage.msg,
    JobPngimage.email
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
       title: Text("ForgotPassword".tr,style: urbanistBold.copyWith(fontSize: 22 )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(JobPngimage.forgotpassword,height: height/4,),
              ),
              SizedBox(height: height/36,),
              Text("Select_which_contact_details_should_we_use_to_reset_your_password".tr,style: urbanistRegular.copyWith(fontSize: 14,)),
              SizedBox(height: height/36,),
              ListView.builder(
                itemCount: name.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor:JobColor.transparent,
                    highlightColor:JobColor.transparent,
                    onTap: () {
                      setState(() {
                        selectindex  = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: height/46),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: selectindex == index ?JobColor.appcolor :themedata.isdark?JobColor.borderblack:JobColor.bggray)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/46),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: JobColor.lightblue,
                              child: Image.asset(image[index],height:height/36,),
                            ),
                            SizedBox(width: width/26),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name[index].toString(),style: urbanistMedium.copyWith(fontSize: 14,color:JobColor.textgray)),
                                SizedBox(height: height/200),
                                Text(subname[index].toString(),style: urbanistBold.copyWith(fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },),
              SizedBox(height: height/46),
              InkWell(
                splashColor:JobColor.transparent,
                highlightColor:JobColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const JobOtpverification(email: '',);
                  },));
                },
                child: Container(
                  height: height/15,
                  width: width/1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color:JobColor.appcolor,
                  ),
                  child: Center(
                    child: Text("Continue".tr,style: urbanistSemiBold.copyWith(fontSize: 16,color:JobColor.white)),
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

