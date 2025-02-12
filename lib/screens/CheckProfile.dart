import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/components/Stepper/ProfileStepper.dart';
import 'package:khedma/components/navbara.dart';
import 'package:khedma/screens/Profile/CheckUserPubs.dart';
import 'package:khedma/screens/Profile/ContactUser.dart';
import '../Services/SharedPrefService.dart';
import '../entities/ProfileDetails.dart';
import '../entities/User.dart';
import 'Profile/ProfileBalance.dart';
import 'Profile/CheckedProfileHeader.dart';
import 'Profile/ProfileInfo.dart';
import 'Profile/ProfileBlogs.dart';
import 'SideMenu.dart'; // Importe le nouveau fichier

class CheckProfile extends StatefulWidget {
  final int userId;

  const CheckProfile({super.key, required this.userId});
  @override
  State<CheckProfile> createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  final MinIOService minIOService = MinIOService();
  final ProfileService profileService = ProfileService();
  final UserService userService = UserService();
  String? userImage;
  User? user,currentUser;
  ProfileDetails? profileDetails;
  bool _isSettingsDrawer = false;


  Future<void> loadUserAndDetails() async {
    user = await userService.findUserById(widget.userId);
    profileDetails = await profileService.getProfileDetails(widget.userId);
    setState(() {});
  }


  Future<void> loadCurrentUser() async {
    currentUser = await SharedPrefService().getUser();
    setState(() {});
  }




  Future<void> _fetchUserProfileImage() async {
    try {
      ProfileDetails profileDetails = await profileService.getProfileDetails(widget.userId);
      String objectName = profileDetails.profilePicture!.replaceFirst('images_', '');
      String filePath = await minIOService.LoadFileFromServer('images', objectName);
      setState(() {
        userImage = filePath;
      });
      print(userImage);
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    loadUserAndDetails();
    _fetchUserProfileImage();
  }

  void _toggleDrawer(BuildContext context) {
    setState(() {
      _isSettingsDrawer = !_isSettingsDrawer;
    });
    Navigator.of(context).pop();
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || profileDetails == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0099D6),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true, // Assure que le titre est bien centré
        title: Text(
          'User Profile',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ContactUser(senderId: currentUser!.id ?? 0, receiverId: widget.userId),
            ProfileHeader(user: user!, profileDetails: profileDetails!),
            ProfileInfo(profileDetails: profileDetails!, user: user!),
            CheckUserPubs(userId: user!.id ?? 0),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}