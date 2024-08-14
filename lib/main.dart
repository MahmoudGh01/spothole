import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/Views/job_pages/job_authentication/job_splash.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'Services/Auth.dart';
import 'Services/notifi_service.dart';
import 'ViewModels/authority_provider.dart';
import 'ViewModels/publicuser_provider.dart';
import 'ViewModels/report_provider.dart';
import 'ViewModels/userprovider.dart';
//import 'Views/YoloRealTime/yolo_realtime_view.dart';
import 'Views/job_pages/job_home/job_applyjob.dart';
import 'Views/job_pages/job_theme/job_theme.dart';
import 'Views/job_pages/job_theme/job_themecontroller.dart';
import 'Views/job_pages/job_translation/stringtranslation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  DartPluginRegistrant.ensureInitialized();
  Get.put(AuthService());
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    riverpod.ProviderScope(
      child: legacy_provider.MultiProvider(
        providers: [
          legacy_provider.ChangeNotifierProvider(create: (_) => UserProvider()),
          legacy_provider.ChangeNotifierProvider(create: (_) => AuthorityProvider()),
          legacy_provider.ChangeNotifierProvider(create: (_) => ReportProvider()),
          legacy_provider.ChangeNotifierProvider(create: (_) => PublicUserProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = Get.find();
  final themedata = Get.put(JobThemecontroler());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
            themedata.isdark ? JobMythemes.darkTheme : JobMythemes.lightTheme,
        fallbackLocale: const Locale('en', 'US'),
        translations: JobApptranslation(),
        locale: const Locale('en', 'US'),
        home: const JobSplash());
  }
}
