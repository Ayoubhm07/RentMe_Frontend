import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/components/navbara.dart';
import '../../../Services/NotificationService.dart';
import '../../../components/appBar/appBar.dart';
import '../../../entities/ProfileDetails.dart';
import '../../../entities/User.dart';
import '../../../theme/AppTheme.dart';
import '../../SideMenu.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../BanierePub.dart';
import 'BestOffers.dart';
import 'HowItWorkSection.dart';
import 'OurServicesSection.dart';
import 'TestimonialsSection.dart';
import 'WhyChooseRentMeSection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPrefService sharedPrefService = SharedPrefService();
  ProfileService profileService = ProfileService();
  MinIOService minIOService = MinIOService();
  NotificationService notificationService = NotificationService();
  User? currentUser;
  ProfileDetails? profileDetails;
  bool _isSettingsDrawer = false;

  Future<void> SaveFcmToken() async {
    User user = await sharedPrefService.getUser();
    String token = await getToken();
    user.fcmToken = token;
    await sharedPrefService.saveUser(user);
    print("FIREBASEEEEEE TOKKEENNN $token");
    await notificationService.saveDeviceToken(user.id ?? 0, token);
  }

  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> getCurrentUser() async {
    User user = await sharedPrefService.getUser();
    _initializeZEGOVideo(user);
    currentUser = user;
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    ProfileDetails profileDetails = await profileService.getProfileDetails(currentUser!.id!);
    List<String> nameAndFileName = profileDetails.profilePicture!.split("_");
    String profileImageInAppPath = await minIOService.LoadFileFromServer(nameAndFileName[0], nameAndFileName[1]);
    profileDetails.profilePicture = profileImageInAppPath;
    await sharedPrefService.saveProfileDetails(profileDetails);
    sharedPrefService.checkAllValues();
  }

  Future<void> _initializeZEGOVideo(User user) async {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1201505839 /*input your AppID*/,
      appSign: "2088e16ac19fcc17fe9cc801e2bf1ad9021b2be2f9dfe0aae00f591d954d9a9f" /*input your AppSign*/,
      userID: user.id.toString(),
      userName: user.userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    FirebaseMessaging.instance.requestPermission();
    getCurrentUser();
    SaveFcmToken();
  }

  Future<String> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    return token ?? '';
  }

  final List<String> baniereAssets = [
    "assets/images/menage.jpeg",
    "assets/images/menage.jpeg",
    "assets/images/menage.jpeg",
    "assets/images/menage.jpeg",
  ];

  void _toggleDrawer(BuildContext context) {
    setState(() {
      _isSettingsDrawer = !_isSettingsDrawer;
    });
    Navigator.of(context).pop();
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _isSettingsDrawer
          ? Builder(
        builder: (context) =>
            SettingsDrawer(toggleDrawer: () => _toggleDrawer(context)),
      )
          : Builder(
        builder: (context) =>
            MyDrawer(toggleDrawer: () => _toggleDrawer(context)),
      ),
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Accueil',
        showSearchBar: true,
        backgroundColor: Color(0xFF0099D6),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            BanierePublicitaire(),
            HowItWorksSection(),
            WhyChooseRentMeSection(),
            OurServicesSection(),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BestOffers(),
            ),
            // TestimonialsSection(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}