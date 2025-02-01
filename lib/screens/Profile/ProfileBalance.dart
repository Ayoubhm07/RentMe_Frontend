import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../entities/User.dart';
import '../../screens/AchatToken.dart';
import '../../screens/TokenConverter.dart';

class ProfileBalance extends StatelessWidget {
  final User user;

  const ProfileBalance({Key? key, required this.user}) : super(key: key);

  void _showModal(BuildContext context, Widget screen) {
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: screen,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0099D6),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset("assets/icons/tokenicon.png", width: 24),
              SizedBox(width: 10),
              Text(user.balance.toString(), style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          Row(
            children: [
              _buildButton(context, "Conversion", Icons.autorenew, Colors.orange, AchatTokenScreen()),
              SizedBox(width: 8),
              _buildButton(context, "Retrait", Icons.money_off, Colors.green, TokenConverterScreen()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, Color color, Widget screen) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showModal(context, screen),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}