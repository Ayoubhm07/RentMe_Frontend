import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/entities/User.dart';
import 'package:khedma/entities/ProfileDetails.dart';

import '../../CheckProfile.dart';

class BestOffers extends StatefulWidget {
  @override
  _BestOffersState createState() => _BestOffersState();
}

class _BestOffersState extends State<BestOffers> {
  List<User> _topContributers = [];
  UserService userService = UserService();
  final ProfileService profileService = ProfileService();
  final MinIOService minIOService = MinIOService();
  Map<int, String?> _userImages = {}; // Pour stocker les images des utilisateurs

  @override
  void initState() {
    super.initState();
    _loadTopContributers();
  }

  Future<void> _loadTopContributers() async {
    try {
      _topContributers = await userService.getTopFiveContributors();
      print("Top contributeurs: $_topContributers");
      setState(() {});
    } catch (e) {
      print("Erreur lors du chargement des top contributeurs: $e");
    }
  }

  Future<void> _fetchUserProfileImage(int userId) async {
    try {
      ProfileDetails profDetail = await profileService.getProfileDetails(userId);
      if (profDetail.profilePicture != null) {
        String objectName = profDetail.profilePicture!.replaceFirst('images_', '');
        String filePath = await minIOService.LoadFileFromServer('images', objectName);
        setState(() {
          _userImages[userId] = filePath;
        });
        print("Image chargée pour l'utilisateur $userId: ${_userImages[userId]}");
      }
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre "Top Contributeurs"
        Padding(
          padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 16.h),
          child: Text(
            'Top Contributeurs',
            style: GoogleFonts.roboto(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        // Liste des top contributeurs
        Container(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _topContributers.length,
            itemBuilder: (context, index) {
              return _buildContributorCard(context, index);
            },
          ),
        ),
      ],
    );
  }

  // Méthode pour construire une carte de contributeur
  Widget _buildContributorCard(BuildContext context, int index) {
    User contributor = _topContributers[index];
    if (_userImages[contributor.id] == null) {
      _fetchUserProfileImage(contributor.id!);
    }

    return GestureDetector(
      onTap: () {
        // Navigation vers le profil de l'utilisateur
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckProfile(userId: contributor.id ?? 0),
          ),
        );
      },
      child: Container(
        width: 200.w,
        height: 280.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.w),
            side: BorderSide(
              color: contributor.note != null && contributor.note! >= 4.5
                  ? Colors.orange
                  : Colors.green,
              width: 3.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.w),
            child: Stack(
              children: [
                // Image de fond (utiliser l'image de l'utilisateur si disponible)
                _userImages[contributor.id] != null
                    ? Image.file(
                  File(_userImages[contributor.id]!),
                  fit: BoxFit.cover,
                  width: 200.w,
                  height: 280.h,
                )
                    : Image.asset(
                  'assets/images/profile_placeholder.png',
                  fit: BoxFit.cover,
                  width: 200.w,
                  height: 280.h,
                ),
                // Dégradé pour améliorer la lisibilité du texte
                Container(
                  width: 200.w,
                  height: 280.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Icônes interactives en haut de la carte
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: CircleAvatar(
                    backgroundColor: contributor.note != null && contributor.note! >= 4.5
                        ? Colors.orange
                        : Colors.green,
                    radius: 16.sp,
                    child: Icon(
                      contributor.note != null && contributor.note! >= 4.5
                          ? Icons.verified
                          : Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
                // Note de l'utilisateur
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          contributor.note?.toStringAsFixed(1) ?? '0.0',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rôle du contributeur
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Text(
                          contributor.roles ?? 'Rôle non défini',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Nom de l'utilisateur
                      Text(
                        contributor.userName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Email de l'utilisateur
                      if (contributor.email != null)
                        Text(
                          contributor.email!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 4.h),
                      if (contributor.numTel != null)
                        Text(
                          contributor.numTel!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}