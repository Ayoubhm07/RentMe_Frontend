import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/RateService.dart';
import '../../entities/ProfileDetails.dart';
import '../../entities/Rate.dart';
import '../../entities/User.dart';
import 'rateUser.dart'; // Importez le widget RateUser

class ProfileHeader extends StatefulWidget {
  final User user;
  final ProfileDetails profileDetails;
  const ProfileHeader({Key? key, required this.user, required this.profileDetails}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final ProfileService profileService = ProfileService();
  final MinIOService minIOService = MinIOService();
  final RateService rateService = RateService();
  String? userImage;

  Future<void> _fetchUserProfileImage() async {
    try {
      ProfileDetails profileDetails2 = widget.profileDetails;
      String objectName = profileDetails2.profilePicture!.replaceFirst('images_', '');
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
    _fetchUserProfileImage();
    print(widget.user.id);
  }

  void _showRateUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RateUser(
          onRateSubmitted: (double rating) async {
            print("Note soumise : $rating");

            AddRateRequest addRateRequest = AddRateRequest(
              userId: widget.user.id ?? 0,
              rate: rating,
            );

            try {
              String response = await rateService.addRate(addRateRequest);
              print('Réponse du serveur: $response');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Note enregistrée avec succès !'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              print('Erreur lors de l\'enregistrement de la note: $e');

              // Affichez un message d'erreur
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erreur lors de l\'enregistrement de la note : $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Photo de profil
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 30.r,
              backgroundImage: userImage != null
                  ? FileImage(File(userImage!))
                  : AssetImage("assets/images/default_avatar.png") as ImageProvider,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'utilisateur
                Text(
                  "${widget.user.firstName} ${widget.user.lastName}",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                // Rôle de l'utilisateur
                Text(
                  _getUserRole(widget.user.roles),
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                // Badges (Vérification et Note)
                Row(
                  children: [
                    // Badge "Identité vérifiée"
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
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
                    SizedBox(width: 10),
                    // Badge "Note"
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
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
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: _showRateUserDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1), // Fond légèrement coloré
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueAccent, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_border,
                          color: Colors.blueAccent,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Noter l'utilisateur",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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