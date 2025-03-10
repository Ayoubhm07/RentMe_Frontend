import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/ProfileService.dart';
import '../../entities/ProfileDetails.dart';
import '../../entities/User.dart';



class ProfileHeader extends StatefulWidget {
  final User user;
  final ProfileDetails profileDetails;
  const ProfileHeader({Key? key, required this.user, required this.profileDetails}) : super(key: key);


  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}


class _ProfileHeaderState extends State<ProfileHeader> {
  final ProfileService profileService = ProfileService();
  final MinIOService minIOService= MinIOService();
  String? userImage;

  Future<void> _fetchUserProfileImage() async {
    try {
      ProfileDetails profileDetails2 = widget.profileDetails;
      String objectName = profileDetails2.profilePicture!.replaceFirst('images_', '');
      String filePath = await minIOService.LoadFileFromServer('images', objectName);
      setState(() {
        userImage = filePath;
      });
      print("aaaaaaaaaaaaaaaaaaaaa{$objectName}");
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
    print(widget.profileDetails);
    print("aaaaaaaaaaaaaaaaaaaaaaaa{$userImage}");
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Photo de profil
          CircleAvatar(
            radius: 26.r,
            backgroundImage: userImage != null
                ? FileImage(File(userImage!))
                : AssetImage("assets/images/user1.png") as ImageProvider,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'utilisateur
                Text(
                  "${widget.user.firstName} ${widget.user.lastName}",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _getUserRole(widget.user.roles),
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Identité vérifiée",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Espace entre les badges
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            widget.user.note.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.amber[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour obtenir le rôle de l'utilisateur
  String _getUserRole(String role) {
    switch (role) {
      case 'USER':
        return 'Client';
      case 'amateur':
        return 'Amateur Certifié';
      case 'professionel':
        return 'Professionnel';
      case 'EXPERT':
        return 'Expert';
      default:
        return 'Client';
    }
  }
}