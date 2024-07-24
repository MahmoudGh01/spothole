import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:job_seeker/Views/PhoneAuth/login_screen.dart';
import 'package:job_seeker/Views/job_pages/job_authentication/job_loginoption.dart';
import 'package:job_seeker/Views/job_pages/job_authentication/job_splash.dart';
import 'package:job_seeker/Views/job_pages/job_home/job_dashboard.dart';
import 'package:provider/provider.dart';
import 'Services/notifi_service.dart';
import 'ViewModels/authority_provider.dart';
import 'ViewModels/publicuser_provider.dart';
import 'ViewModels/report_provider.dart';
import 'ViewModels/userprovider.dart';
import 'Views/job_pages/job_theme/job_theme.dart';
import 'Views/job_pages/job_theme/job_themecontroller.dart';
import 'Views/job_pages/job_translation/stringtranslation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider()),
  ChangeNotifierProvider<AuthorityProvider>(create: (_) => AuthorityProvider()),
  ChangeNotifierProvider<ReportProvider>(create: (_) => ReportProvider()),
  ChangeNotifierProvider<PublicUserProvider>(create: (_) => PublicUserProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themedata = Get.put(JobThemecontroler());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themedata.isdark ? JobMythemes.darkTheme : JobMythemes.lightTheme,
      fallbackLocale: const Locale('en', 'US'),
      translations: JobApptranslation(),
      locale: const Locale('en', 'US'),
      home: JobDashboard("0")
    );
  }
}
