import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/components/Stepper/ProfileStepper.dart';
import 'package:khedma/components/navbara.dart';
import '../Services/SharedPrefService.dart';
import '../entities/ProfileDetails.dart';
import '../entities/User.dart';
import 'Profile/ProfileBalance.dart';
import 'Profile/ProfileHeader.dart';
import 'Profile/ProfileInfo.dart';
import 'Profile/ProfileBlogs.dart'; // Importe le nouveau fichier

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SharedPrefService sharedPrefService = SharedPrefService();
  User? user;
  ProfileDetails? profileDetails;

  Future<void> loadUserAndDetails() async {
    user = await sharedPrefService.getUser();
    profileDetails = await sharedPrefService.getProfileDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUserAndDetails();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0099D6),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileStepper()),
                );
              },
              child: Container(
                width: 24,
                height: 24,
                child: Image.asset(
                  'assets/icons/edit.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            Text(
              'Mon Profile',
              style: GoogleFonts.getFont(
                'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 24),
          ],
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileBalance(user: user!),
            ProfileHeader(user: user!, profileDetails: profileDetails!),
            ProfileInfo(profileDetails: profileDetails!, user: user!),
            ProfileBlogs(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}