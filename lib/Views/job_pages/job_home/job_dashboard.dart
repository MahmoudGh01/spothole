import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/YoloVision/YoloVideo.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_color.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_fontstyle.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/Views/job_pages/job_application/job_application.dart';
import 'package:job_seeker/Views/job_pages/job_theme/job_themecontroller.dart';

//import '../../CameraScreen/camera_awesome.dart';
import '../../MapIntegration/splash_screen.dart';
import '../job_profile/job_profile.dart';
import 'job_home.dart';

// ignore: must_be_immutable
class JobDashboard extends StatefulWidget {
  String? index;

  JobDashboard(this.index, {super.key});

  @override
  State<JobDashboard> createState() => _JobDashboardState();
}

class _JobDashboardState extends State<JobDashboard> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());

  PageController pageController = PageController();
  int _selectedItemIndex = 0;

  final List<Widget> _pages =  const [
    JobHome(),
    MapSplash(),
    YoloVideo(),
    JobApplication(),
    JobProfile()
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget _bottomTabBar() {
    return BottomNavigationBar(
      currentIndex: _selectedItemIndex,
      onTap: _onTap,
      elevation: 0,
      backgroundColor:
          themedata.isdark ? JobColor.black : JobColor.white,
      selectedLabelStyle: urbanistBold.copyWith(fontSize: 10),
      unselectedLabelStyle: urbanistMedium.copyWith(fontSize: 10),
      selectedFontSize: 10,
      unselectedFontSize: 10,
      selectedItemColor: JobColor.appcolor,
      unselectedItemColor: JobColor.textgray,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            JobPngimage.home,
            height: height / 36,
            color: themedata.isdark
                ? JobColor.white
                : JobColor.grey,
          ),
          activeIcon: Image.asset(JobPngimage.homefill,
              height: height / 36,color: JobColor.appcolor),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            JobPngimage.save,
            height: height / 36,
            color: themedata.isdark
                ? JobColor.white
                : JobColor.grey,
          ),
          activeIcon: Image.asset(JobPngimage.savefill,
              height: height / 36, color: JobColor.appcolor),
          label: 'Maps',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            JobPngimage.camera,
            height: height / 36,
            color: themedata.isdark
                ? JobColor.white
                : JobColor.grey,
          ),
          activeIcon: Image.asset(JobPngimage.camera,
              height: height / 36,color: JobColor.appcolor),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            JobPngimage.chart,
            height: height / 36,
            color: themedata.isdark
                ? JobColor.white
                : JobColor.grey,
          ),
          activeIcon: Image.asset(JobPngimage.chart,
              height: height / 36,color: JobColor.appcolor),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            JobPngimage.profiles,
            height: height / 36,
            color: themedata.isdark
                ? JobColor.white
                : JobColor.grey,
          ),
          activeIcon: Image.asset(JobPngimage.profileicon,
            height: height / 36,color: JobColor.appcolor,),
          label: 'Profile',
        ),
      ],
    );
  }

  void _onTap(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return GetBuilder<JobThemecontroler>(builder: (controller) {
      return Scaffold(
        bottomNavigationBar: _bottomTabBar(),
        body: _pages[_selectedItemIndex],
      );
    });
  }
}
