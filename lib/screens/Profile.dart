import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/components/Stepper/ProfileStepper.dart';
import 'package:khedma/components/navbara.dart';
import 'package:khedma/screens/AchatToken.dart';
import 'package:khedma/screens/SideMenu.dart';

import '../Services/SharedPrefService.dart';
import '../entities/ProfileDetails.dart';
import '../entities/User.dart';
import 'TokenConverter.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SharedPrefService sharedPrefService = SharedPrefService();
  User? user;
  ProfileDetails? profileDetails;
  Future<void> loadUserandDetails() async {
    user = await sharedPrefService.getUser();
    profileDetails = await sharedPrefService.getProfileDetails();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadUserandDetails();
  }
  @override
  Widget build(BuildContext context) {
    if (user == null || profileDetails == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0099D6),
        iconTheme: IconThemeData(
          color: Colors
              .white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileStepper()),
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
            SizedBox(width: 24), // Placeholder to balance space
          ],
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
              decoration: BoxDecoration(
                color: Color(0xFF0099D6),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(17, 29, 18.6, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 13),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8, 5, 8, 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      child: Image.asset(
                                        'assets/icons/tokenicon.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      user!.balance.toString(),
                                      style: GoogleFonts.getFont(
                                        'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                          return Container();
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                          'assets/icons/addtoken.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: AchatTokenScreen(),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF7AA1E),
                                  borderRadius: BorderRadius.circular(23),
                                ),
                                padding: EdgeInsets.fromLTRB(17.8, 7, 17.8, 8),
                                child: Text(
                                  'Convertion',
                                  style: GoogleFonts.getFont(
                                    'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.7,
                                    color: Color(0xFFF4F6F5),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: MediaQuery.of(context).size.height * 0.6,  // Adjust the multiplier to control the height
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: TokenConverterScreen(),  // Your custom widget for purchasing tokens
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(23),
                                ),
                                padding: EdgeInsets.fromLTRB(17.8, 7, 17.8, 8),
                                child: Text(
                                  'Retrait',
                                  style: GoogleFonts.getFont(
                                    'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.7,
                                    color: Color(0xFFF4F6F5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 5, 5),
                      margin: EdgeInsets.fromLTRB(6, 10, 6, 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFF7AA1E),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x21BEBEBE),
                            offset: Offset(3, 3),
                            blurRadius: 4.5,
                          ),
                        ],
                      ),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                  child : Text(
                                    user!.firstName + '\n' + user!.lastName,
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 32,
                                      color: Color(0xFF525252),
                                    ),
                                  ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Type',
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19,
                                      color: Color(0xFFB8C5D0),
                                    ),
                                  ),
                                  Text(
                                    user!.roles == 'USER'
                                        ? 'Client'
                                        : user!.roles == 'amateur'
                                            ? 'Amateur Certifié'
                                            : user!.roles == 'professionel'
                                                ? 'Professionnel'
                                                : user!.roles == 'EXPERT'
                                                    ? 'Expert'
                                                    : 'Client',
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Color(0xFF79838B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(23),
                                child: Image.file(
                                  File(profileDetails!.profilePicture!),
                                  width: 150,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
                              decoration: BoxDecoration(
                                color: Color(0xFFF7AA1E),
                                borderRadius: BorderRadius.circular(33.5),
                              ),
                              child: Container(
                                width: 23,
                                height: 23,
                                padding: EdgeInsets.all(3.4),
                                child: Image.asset(
                                  'assets/icons/Check.png',
                                  width: 16.2,
                                  height: 16.2,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: Text(
                                'Identité vérifiée',
                                style: GoogleFonts.getFont(
                                  'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Ajout des éléments adresse et icône en dessous du container bleu
            Container(
              margin: EdgeInsets.fromLTRB(10.5, 0, 0, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 13.5,
                    height: 16.9,
                    child: Image.asset(
                      'assets/icons/adresse.png',
                    ),
                  ),
                  SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF0C3469),
                      ),
                      children: [
                        TextSpan(
                          text: '${profileDetails!.rue}, ',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.3,
                            color: Color(0xFF0C3469),
                          ),
                        ),
                        TextSpan(
                          text: '${profileDetails!.ville}, ${profileDetails!.codePostal}, ${profileDetails!.pays}',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF0C3469),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Container(
              margin: EdgeInsets.fromLTRB(10.5, 0, 0, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 13.5,
                    height: 16.9,
                    child: Image.asset(
                      'assets/icons/phone.png',
                    ),
                  ),
                  SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF0C3469),
                      ),
                      children: [
                        TextSpan(
                          text: user!.numTel,
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF0C3469),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Container(
              margin: EdgeInsets.fromLTRB(10.5, 0, 0, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 13.5,
                    height: 16.9,
                    child: Image.asset(
                      'assets/icons/mail.png',
                    ),
                  ),
                  SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF0C3469),
                      ),
                      children: [
                        TextSpan(
                          text: user!.email,
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF0C3469),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
