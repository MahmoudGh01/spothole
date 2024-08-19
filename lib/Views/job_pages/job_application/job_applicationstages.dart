import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Models/Report.dart';
import 'package:provider/provider.dart';
import '../../../ViewModels/userprovider.dart';
import '../../job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';

class ReportDetail extends StatefulWidget {
  final Report report;

  const ReportDetail({Key? key, required this.report}) : super(key: key);

  @override
  _ReportDetailState createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserById(widget.report.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themedata = Get.put(JobThemecontroler());
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Access the user data
    var user = Provider.of<UserProvider>(context).getReportUser(widget.report.userId);

    return Scaffold(
      body: Column(
        children: [
          // Report Image filling the upper section of the screen
          Container(
            height: height * 0.4,  // 40% of the screen height
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              image: DecorationImage(
                image: widget.report.imageURL != null && widget.report.imageURL!.isNotEmpty
                    ? NetworkImage(widget.report.imageURL!)
                    : const AssetImage('assets/job_assets/job_pngimage/logo.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Back button on top of the image
                Positioned(
                  top: 40, // Adjust based on your app's design
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Expanded section below the image
          Expanded(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                color: themedata.isdark ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Report description and location in a styled container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/job_assets/job_pngimage/background_location.png'), // Use your background asset
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: JobColor.appcolor, size: 40),
                          const SizedBox(width: 25),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.report.address,
                                  style: urbanistMedium.copyWith(
                                    fontSize: 18,
                                    color: JobColor.appcolor, // Adjust color to contrast with the background image
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Icon Button for directions
                          IconButton(
                            color: JobColor.appcolor,
                            iconSize: 40,
                            icon: const Icon(Icons.directions, color: JobColor.appcolor),
                            onPressed: () {
                              // Handle navigation to map or directions functionality
                              print("Directions button pressed");
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 36),

                    // Severity with an icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          "Severity: ${widget.report.severity}",
                          style: urbanistSemiBold.copyWith(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        // Optional visual indicator for severity
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent.withOpacity(0.2),
                          ),
                          child: const Icon(Icons.priority_high, color: Colors.redAccent),
                        ),
                      ],
                    ),
                    SizedBox(height: height / 36),

                    // Report status container with an icon
                    Container(
                      height: height / 15,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: JobColor.lightblue,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.report, color: JobColor.appcolor, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              "Report Status: ${widget.report.status}".tr,
                              style: urbanistSemiBold.copyWith(fontSize: 16, color: JobColor.appcolor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height / 36),

                    // User Info
                    user!.id.isNotEmpty
                        ? Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user!.profilePicturePath.isNotEmpty
                              ? NetworkImage(user.profilePicturePath)
                              : const AssetImage('assets/job_assets/job_pngimage/logo.png') as ImageProvider,
                        ),
                        SizedBox(width: width / 36),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user.name}",
                              style: urbanistSemiBold.copyWith(fontSize: 18, color: themedata.isdark ? Colors.white : Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Posted on: ${widget.report.createdDate}",
                              style: urbanistSemiBold.copyWith(fontSize: 13, color: JobColor.textgray),
                            ),
                          ],
                        ),
                      ],
                    )
                        : const CircularProgressIndicator(),

                    const Divider(),
                    Text(
                      "Description",
                      style: urbanistSemiBold.copyWith(
                        fontSize: 15,
                        color: themedata.isdark ? Colors.white : JobColor.appcolor,
                      ),
                      maxLines: 10,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: height / 100),

                    Text(
                      widget.report.description,
                      style: urbanistSemiBold.copyWith(
                        fontSize: 15,
                        color: themedata.isdark ? Colors.white : Colors.black,
                      ),
                      maxLines: 10,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: height / 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
