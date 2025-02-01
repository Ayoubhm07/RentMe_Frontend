import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../entities/ProfileDetails.dart';
import '../../entities/User.dart';

class ProfileInfo extends StatelessWidget {
  final ProfileDetails profileDetails;
  final User user;

  const ProfileInfo({Key? key, required this.profileDetails, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profileDetails.description!= null)
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                profileDetails.description ?? "",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[800],
                ),
              ),
            ),

          _buildInfoRow("assets/icons/adresse.png",
              "${profileDetails.rue}, ${profileDetails.ville}, ${profileDetails.codePostal}, ${profileDetails.pays}"),
          SizedBox(height: 8),
          _buildInfoRow("assets/icons/phone.png", user.numTel ?? ""),
          SizedBox(height: 8),
          _buildInfoRow("assets/icons/mail.png", user.email),
        ],
      ),
    );
  }
  Widget _buildInfoRow(String iconPath, String text) {
    return Row(
      children: [
        Image.asset(iconPath, width: 20),
        SizedBox(width: 10),
        Expanded(child: Text(text, style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold))),
      ],
    );
  }
}
