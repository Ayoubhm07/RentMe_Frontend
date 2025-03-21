import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/ProfileDetails.dart';
import 'package:khedma/screens/Login.dart';
import 'package:khedma/screens/MainPages/AboutUs.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../entities/User.dart';
import 'MainPages/Demandes/DemandeLocation.dart';
import 'MainPages/Demandes/MesLocation.dart';
import 'MainPages/Demandes/MesOffre.dart';
import 'MainPages/Demandes/OffreService.dart';
import 'Messages.dart';


class MyDrawer extends StatefulWidget {
  final VoidCallback toggleDrawer;
  const MyDrawer({required this.toggleDrawer});
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
      return Center(child: CircularProgressIndicator());
    }
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(-18, -8),
                    blurRadius: 9.5,
                  ),
                ],
              ),
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 37, 0, 51),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Row containing close icon, centered Menu text, and settings icon
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 40), // Réduire l'espace ici
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Stack(
                            alignment: Alignment.center, // Centre le texte
                            children: [
                            Align(
                            alignment: Alignment.centerLeft, // Place l'icône à gauche
                            child: IconButton(
                              icon: Icon(Icons.close, color: Color(0xFF0099D6)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text(
                            'Menu',
                            style: GoogleFonts.getFont(
                              'Roboto',
                              fontWeight: FontWeight.bold,  // Texte en gras
                              fontSize: 20,
                              color: Color(0xFF0099D6),
                            ),
                          ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: FileImage(File(profileDetails!.profilePicture!)),
                        ),
                        SizedBox(height: 8.0), // Reduced space here
                        Container(
                          margin: EdgeInsets.fromLTRB(8.6, 0, 0, 21),
                          child: Text(
                            user!.firstName + ' ' + user!.lastName,
                            style: GoogleFonts.getFont(
                              'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF525252),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(13.2, 0, 0, 42),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF0099D6), width: 5), // Blue border
                              color: Color(0xFFFFFFFF), // White inside
                              borderRadius: BorderRadius.circular(23),
                            ),
                            child: SizedBox(
                              width: 110,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 9),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0), // Adjust margin as needed
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF28A00),
                                          borderRadius: BorderRadius.circular(17.5),
                                        ),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          padding: EdgeInsets.all(3),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Image.asset(
                                              'assets/icons/tokenicon.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      user!.balance.toString() ,
                                      style: GoogleFonts.getFont(
                                        'Roboto',
                                        fontWeight: FontWeight.w500, // Medium Bold
                                        fontSize: 13.3,
                                        height: 1.6,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0), // Adjust margin as needed
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF28A00),
                                          borderRadius: BorderRadius.circular(7.5),
                                        ),
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          padding: EdgeInsets.all(3),
                                          child: SizedBox(
                                            width: 9,
                                            height: 9,
                                            child: Image.asset(
                                              'assets/icons/addtoken.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Drawer items
                        DrawerItem(
                          iconPath: 'assets/icons/img_12.png',
                          label: 'Mes Messages',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 68.2, 20.3),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MessagePage()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/locationnn.png',
                          label: 'Demandes de location',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 0, 20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DemandelocationtScreen()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/bag1.png',
                          label: 'Demandes de services',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 0, 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OffreservicetScreen()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/entreprise.png',
                          label: 'Mes offres de services',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 43.8, 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OffreScreen()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/paper1.png',
                          label: 'Mes offres de location',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 0, 100),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OffreLocationScreen()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/information.png',
                          label: 'À propos de nous',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 1.8, 14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AboutUsPage()),
                            );
                          },
                        ),

                        DrawerItem(
                          iconPath: 'assets/drawericons/logout1.png',
                          label: 'Déconnexion',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 29.8, 25),
                          onTap: () async {
                            ZegoUIKitPrebuiltCallInvitationService().uninit();
                            await this.sharedPrefService.clearAllUserData();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final EdgeInsetsGeometry margin;
  final VoidCallback onTap; // Ajoutez une fonction pour gérer la navigation

  const DrawerItem({
    required this.iconPath,
    required this.label,
    required this.margin,
    required this.onTap, // Ajoutez ici la fonction onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // Utilisez InkWell pour ajouter un effet de clic
      onTap: onTap, // Appelez onTap lorsque l'utilisateur clique
      child: Container(
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (iconPath.isNotEmpty)
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 17.4, 0),
                width: 24,
                height: 24,
                child: Image.asset(
                  iconPath,
                ),
              ),
            Text(
              label,
              style: GoogleFonts.getFont(
                'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsDrawer extends StatelessWidget {
    final VoidCallback toggleDrawer;

  const SettingsDrawer({required this.toggleDrawer});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(-18, -8),
                    blurRadius: 9.5,
                  ),
                ],
              ),
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 37, 0, 51),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Row containing close icon, centered Menu text, and settings icon
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 40), // Reduced space here
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             IconButton(
                                icon: Icon(Icons.close, color: Color(0xFF0099D6)),
                                onPressed: toggleDrawer,
                              ),
                                 Expanded(
        child: Center(
          child: Text(
            'Paramétre',
            style: GoogleFonts.getFont(
              'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF0099D6),
            ),
          ),
        ),
      ),
                                                     ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: AssetImage('assets/icons/imagee.png'),
                        ),
                        SizedBox(height: 8.0), // Reduced space here
                        Container(
                          margin: EdgeInsets.fromLTRB(8.6, 0, 0, 21),
                          child: Text(
                            'Jessica Virgolini',
                            style: GoogleFonts.getFont(
                              'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF525252),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(13.2, 0, 0, 42),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF0099D6), width: 5), // Blue border
                              color: Color(0xFFFFFFFF), // White inside
                              borderRadius: BorderRadius.circular(23),
                            ),
                            child: SizedBox(
                              width: 110,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 9),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0), // Adjust margin as needed
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF28A00),
                                          borderRadius: BorderRadius.circular(17.5),
                                        ),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          padding: EdgeInsets.all(3),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Image.asset(
                                              'assets/icons/tokenicon.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '99',
                                      style: GoogleFonts.getFont(
                                        'Roboto',
                                        fontWeight: FontWeight.w500, // Medium Bold
                                        fontSize: 13.3,
                                        height: 1.6,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0), // Adjust margin as needed
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF28A00),
                                          borderRadius: BorderRadius.circular(7.5),
                                        ),
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          padding: EdgeInsets.all(3),
                                          child: SizedBox(
                                            width: 9,
                                            height: 9,
                                            child: Image.asset(
                                              'assets/icons/addtoken.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Drawer items
                        DrawerItem(
                          iconPath: 'assets/drawericons/traduction.png',
                          label: 'Langue',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 68.2, 20.3),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DemandelocationtScreen()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/theme.png',
                          label: 'Théme sombre',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 0, 20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DemandelocationtScreen()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/editProfile.png',
                          label: 'Modifier mon profil',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 0, 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OffreservicetScreen()),
                            );
                          },
                        ),
                       
                       
                        DrawerItem(
                          iconPath: 'assets/drawericons/information.png',
                          label: 'À propos de nous',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 1.8, 14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DemandelocationtScreen()),
                            );
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/faq1.png',
                          label: 'Foire aux Questions',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 0, 16),
                          onTap: () {
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DemandeLocationScreen()),
                            );

                             */
                          },
                        ),
                        DrawerItem(
                          iconPath: 'assets/drawericons/logout1.png',
                          label: 'Déconnexion',
                          margin: EdgeInsets.fromLTRB(25.2, 0, 29.8, 25),
                          onTap: () {

                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsDrawerItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final EdgeInsetsGeometry margin;
  final VoidCallback onTap; // Ajoutez une fonction pour gérer la navigation

  const SettingsDrawerItem({
    required this.iconPath,
    required this.label,
    required this.margin,
    required this.onTap, // Ajoutez ici la fonction onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // Utilisez InkWell pour ajouter un effet de clic
      onTap: onTap, // Appelez onTap lorsque l'utilisateur clique
      child: Container(
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (iconPath.isNotEmpty)
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 17.4, 0),
                width: 24,
                height: 24,
                child: Image.asset(
                  iconPath,
                ),
              ),
            Text(
              label,
              style: GoogleFonts.getFont(
                'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}