import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_filter.dart';

class JobSearch extends StatefulWidget {
  const JobSearch({Key? key}) : super(key: key);

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  int selected2 = 0;

  List jobs = ["Sales & Marketing","Writing & Content","Quality Assurance","Community Officer"];
  //List jobs = [];
  List jobdesc = ["Paypal","Pinterest","Spotify","Reddit Company"];
  List icon = [
    JobPngimage.paypal,
    JobPngimage.printrest,
    JobPngimage.spotify,
    JobPngimage.reddit,
  ];
  List location = ["New York, United States","Paris, France","Canberra, Australia","Tokyo, Japan"];

  List name = ["Alphabetical (A to Z)","Most Relevant","Highest Salary","Newly Posted","Ending Soon"];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search".tr,style: urbanistBold.copyWith(fontSize: 22 )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/36),
          child: Column(
            children: [
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16,),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16,color:JobColor.textgray,),
                  hintText: "Search for a job or company".tr,
                 fillColor: themedata.isdark?JobColor.lightblack:JobColor.appgray,
                  filled: true,
                  prefixIcon:Icon(Icons.search_rounded,size: height/36,color: JobColor.textgray,),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      splashColor: JobColor.transparent,
                      highlightColor: JobColor.transparent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const JobFilter();
                          },));
                        },
                        child: Image.asset(JobPngimage.filter,height: height/36,)),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:const BorderSide(color: JobColor.appcolor)
                  ),
                ),
              ),
              SizedBox(height: height/36,),
              Row(
                children: [
                  Text("3,779 founds".tr,style: urbanistBold.copyWith(fontSize: 18 )),
                  const Spacer(),
                 // Image.asset(JobPngimage.swap,height: height/36,)
                  SizedBox(
                    height: height/22,
                    width: height/26,
                    child: PopupMenuButton<int>(itemBuilder: (context) =>[
                      PopupMenuItem(
                        value: 0,
                        child:  Text("Alphabetical (A to Z)",style: urbanistSemiBold.copyWith(fontSize: 14 )),
                      ),
                      PopupMenuItem(
                        value: 0,
                        child:  Text("Most Relevant",style: urbanistSemiBold.copyWith(fontSize: 14 )),
                      ),
                      PopupMenuItem(
                        value: 0,
                        child:  Text("Highest Salary",style: urbanistSemiBold.copyWith(fontSize: 14 )),
                      ),
                      PopupMenuItem(
                        value: 0,
                        child:  Text("Newly Posted",style: urbanistSemiBold.copyWith(fontSize: 14 )),
                      ),
                      PopupMenuItem(
                        value: 0,
                        child:  Text("Ending Soon",style: urbanistSemiBold.copyWith(fontSize: 14 )),
                      ),
                    ],
                      offset: const Offset(5, 50),
                      color:themedata.isdark?JobColor.lightblack:JobColor.white,
                      constraints: BoxConstraints(
                        maxWidth: width/2,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      icon: Image.asset(JobPngimage.swap,height: height/36,fit: BoxFit.fitHeight,color: JobColor.appcolor,),
                      elevation: 2,

                    ),
                  )
                ],
              ),
              SizedBox(height: height/36,),
              if(jobs.isEmpty)...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height/26,),
                    Image.asset(JobPngimage.notfound,height: height/3.8,fit: BoxFit.fitHeight,),
                    SizedBox(height: height/16,),
                    Text("Not_Found".tr,style: urbanistSemiBold.copyWith(fontSize: 24 ),),
                    SizedBox(height: height/46,),
                    Text("Sorry, the keyword you entered cannot be found, please check again or search with another keyword.".tr,style: urbanistRegular.copyWith(fontSize: 18 ),textAlign: TextAlign.center,),

                  ],
                )
              ]else...[
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

            ],
          ),
        ),
      ),
    );
  }
}
