import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_fontstyle.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_details.dart';
import 'job_notification.dart';
import 'job_recentjobs.dart';
import 'job_search.dart';

class JobHome extends StatefulWidget {
  const JobHome({Key? key}) : super(key: key);

  @override
  State<JobHome> createState() => _JobHomeState();
}

class _JobHomeState extends State<JobHome> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  List text = ["All", "Design", "Technology", "Finance"];
  int selected1 = 0;
  int selected2 = 0;

  List jobs = ["Sales & Marketing","Writing & Content","Quality Assurance","Community Officer"];
  List jobdesc = ["Paypal","Pinterest","Spotify","Reddit Company"];
  List icon = [
    JobPngimage.paypal,
    JobPngimage.printrest,
    JobPngimage.spotify,
    JobPngimage.reddit,
  ];

  List location = ["New York, United States","Paris, France","Canberra, Australia","Tokyo, Japan"];

  @override
  Widget build(BuildContext context) {
  size = MediaQuery.of(context).size;
  height = size.height;
  width = size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: width/1,
        toolbarHeight: height/10,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage(JobPngimage.profile),
              ),
              SizedBox(width: width/26,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height/120,),
                  Text("Good Morning 👋".tr,style: urbanistRegular.copyWith(fontSize: 16 )),
                  SizedBox(height: height/120,),
                  Text("Mahmoud Gharbi".tr,style: urbanistBold.copyWith(fontSize: 19 )),
                ],
              ),
              const Spacer(),
              InkWell(
                splashColor: JobColor.transparent,
                highlightColor: JobColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const JobNotification();
                  },));
                },
                child: Container(
                  height: height/16,
                  width: height/16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(JobPngimage.notification,height: height/36,color: themedata.isdark?JobColor.white:JobColor.black,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            children: [
              TextField(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const JobSearch();
                  },));
                },
                style: urbanistSemiBold.copyWith(fontSize: 16,),
                readOnly: true,
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Search for a report".tr,
                 fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  prefixIcon:Icon(Icons.search_rounded,size: height/36,color: JobColor.textgray,),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(JobPngimage.filter,height: height/36,),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:BorderSide.none
                  ),
                ),
              ),
              SizedBox(height: height/45,),
              Text("Report Potholes around you     for a better city".tr,style: urbanistBold.copyWith(fontSize: 29 , color: Color(0xff2B3499) ),),
              //SizedBox(height: height/26,),
             /* Row(
                children: [
                  Text("Nearby reports".tr,style: urbanistBold.copyWith(fontSize: 20 )),
                  const Spacer(),
                  Text("See_All".tr,style: urbanistBold.copyWith(fontSize: 16,color: JobColor.appcolor)),
                ],
              ),
              SizedBox(height: height/36,),
              SizedBox(
                height: height/3.3,
                child: ListView.separated(
                  itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: width/1.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/56),
                          child: InkWell(
                            splashColor: JobColor.transparent,
                            highlightColor: JobColor.transparent,
                            onTap: () {
                              Navigator.push(context,  MaterialPageRoute(builder: (context) {
                                return const JobDetails();
                              },));
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: height/12,
                                      width: height/12,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Image.asset(JobPngimage.google,height: height/36,),
                                      ),
                                    ),
                                    SizedBox(width: width/26,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width/2,
                                                child: Text("UI/UX Designer".tr,style: urbanistSemiBold.copyWith(fontSize: 20 ),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                            SizedBox(width: width/56,),
                                            Image.asset(JobPngimage.save,height: height/36,color: JobColor.appcolor,),
                                          ],
                                        ),
                                        SizedBox(height: height/80,),
                                        Text("City Hall".tr,style: urbanistMedium.copyWith(fontSize: 16 ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),

                                  ],
                                ),
                                SizedBox(height: height/96,),
                                 Divider(color: themedata.isdark?JobColor.borderblack:JobColor.bggray),
                                SizedBox(height: height/96,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height/12,
                                      width: height/12,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    SizedBox(width: width/26,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("California, United States".tr,style: urbanistMedium.copyWith(fontSize: 18 ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                        SizedBox(height: height/66,),
                                        Text("\$10,000 - \$25,000 /month".tr,style: urbanistSemiBold.copyWith(fontSize: 18,color: JobColor.appcolor),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                        SizedBox(height: height/66,),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: JobColor.textgray)
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/96),
                                                child: Text("Full Time".tr,style: urbanistSemiBold.copyWith(fontSize: 10,color: JobColor.textgray)),
                                              ),
                                            ),
                                            SizedBox(width: width/26,),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: JobColor.textgray)
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/96),
                                                child: Text("Onsite".tr,style: urbanistSemiBold.copyWith(fontSize: 10,color: JobColor.textgray)),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(width: width/30,);
                    },
                    ),
              ),*/
              SizedBox(height: height/26,),
              Row(
                children: [
                  Text("Recent_Jobs".tr,style: urbanistBold.copyWith(fontSize: 20 )),
                  const Spacer(),
                  InkWell(
                    splashColor: JobColor.transparent,
                    highlightColor: JobColor.transparent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return  const JobRecentJobs();
                        },));
                      },
                      child: Text("See_All".tr,style: urbanistBold.copyWith(fontSize: 16,color: JobColor.appcolor))),
                ],
              ),
              SizedBox(height: height/36,),
              SizedBox(
                height: height / 20,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: JobColor.transparent,
                        highlightColor: JobColor.transparent,
                        onTap: () {
                          setState(() {
                            selected1 = index;
                          });
                        },
                        child: Container(
                          height: height / 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all( color: selected1 == index
                                  ? JobColor.transparent
                                  : JobColor.appcolor),
                              color: selected1 == index
                                  ? JobColor.appcolor
                                  : JobColor.transparent),
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: width / 16),
                            child: Center(
                              child: Text(text[index],
                                  style: urbanistMedium.copyWith(
                                      fontSize: 16,
                                      color: selected1 == index
                                          ? JobColor.white
                                          : JobColor.appcolor)),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        width: width / 36,
                      );
                    },
                    itemCount: text.length),
              ),
              SizedBox(height: height/36,),
              ListView.separated(
                itemCount: jobs.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    width: width/1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/46),
                      child: InkWell(
                        splashColor: JobColor.transparent,
                        highlightColor: JobColor.transparent,
                        onTap: () {
                          setState(() {
                            selected2 = index;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: height/12,
                                  width: height/12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: themedata.isdark?JobColor.borderblack:JobColor.bggray)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image.asset(icon[index],height: height/36,),
                                  ),
                                ),
                                SizedBox(width: width/26,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: width/1.8,
                                            child: Text(jobs[index],style: urbanistSemiBold.copyWith(fontSize: 20 ),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                        SizedBox(width: width/56,),
                                        Image.asset(selected2 == index?JobPngimage.savefill:JobPngimage.save,height: height/36,color: JobColor.appcolor,),
                                      ],
                                    ),
                                    SizedBox(height: height/80,),
                                    Text(jobdesc[index],style: urbanistMedium.copyWith(fontSize: 16 ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ],
                                ),

                              ],
                            ),
                            SizedBox(height: height/96,),
                             Divider(color: themedata.isdark?JobColor.borderblack:JobColor.bggray),
                            SizedBox(height: height/96,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: height/12,
                                  width: height/12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                SizedBox(width: width/26,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(location[index],style: urbanistMedium.copyWith(fontSize: 18 ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: height/66,),
                                    Text("\$10,000 - \$25,000 /month".tr,style: urbanistSemiBold.copyWith(fontSize: 18,color: JobColor.appcolor),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: height/66,),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: JobColor.textgray)
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/96),
                                            child: Text("Full Time".tr,style: urbanistSemiBold.copyWith(fontSize: 10,color: JobColor.textgray)),
                                          ),
                                        ),
                                        SizedBox(width: width/26,),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: JobColor.textgray)
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width/26,vertical: height/96),
                                            child: Text("Onsite".tr,style: urbanistSemiBold.copyWith(fontSize: 10,color: JobColor.textgray)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(height: height/46,);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
