import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:khedma/components/Stepper/ProfileStepper.dart';
import 'package:khedma/screens/Login.dart';
import 'package:khedma/screens/MainPages/HomePage.dart';
import 'package:khedma/screens/onboardings/spalshScreen.dart';
import 'package:khedma/theme/AppTheme.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'components/Sections/MyDemandOffersSection.dart';

void main() async{
  Stripe.publishableKey = "pk_test_51QdfwMD8lq4eL7A05fvEscYdZrn6MfcCtTYjiXVpQCTpIDfOsKGe02C6fTnqDUYY2J0A8JdY1hc1b4WSyPiGb4JT00OlSUlnya";
  /// 1/5: define a navigator key
  final navigatorKey = GlobalKey<NavigatorState>();
  /// 2/5: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
  });
  await Firebase.initializeApp();
  runApp(MyApp(navigatorKey: navigatorKey));
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            //theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            title: "RentMe",
            // home: SplashPage());
            //home: HomeScreen());
            //home: ProfileStepper()
            home: LoginPage(),
        );
      },
    );
  }
}
