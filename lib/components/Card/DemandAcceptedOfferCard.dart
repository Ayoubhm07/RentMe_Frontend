import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class DemandAcceptedOfferCard extends StatelessWidget {
  final String userName;
  final String userImage;
  final DateTime acceptedAt;
  final String duration;
  final int price;

  const DemandAcceptedOfferCard({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.acceptedAt,
    required this.duration,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userImage),
                radius: 25, // Reduced size
              ),
              SizedBox(width: 8), // Reduced spacing
              Expanded(
                child: Text(
                  userName,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Reduced spacing
          TextWithIcon(
            icon: Icons.calendar_today,
            text: 'Accepté le: ${DateFormat('dd MMM yyyy').format(acceptedAt)}',
            iconColor: Colors.blue,
            textColor: Colors.black87,
          ),
          TextWithIcon(
            icon: Icons.hourglass_bottom,
            text: 'Durée: $duration',
            iconColor: Colors.blue,
            textColor: Colors.black87,
          ),
          TextWithIcon(
            icon: Icons.euro,
            text: 'Prix: €$price',
            iconColor: Colors.green,
            textColor: Colors.black87,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ActionButton(
                title: 'Chat',
                icon: Icons.chat,
                color: Colors.green[300]!,
                onPressed: () {
                  // Implement chat functionality
                },
              ),
              SizedBox(width: 8), // Reduced spacing
              ActionButton(
                title: 'Payer',
                icon: Icons.payment,
                color: Colors.blue[300]!,
                onPressed: () {
                  // Implement payment functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;

  const TextWithIcon({
    Key? key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.blue,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(title, style: TextStyle(color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
