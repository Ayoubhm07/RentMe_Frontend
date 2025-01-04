import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userImage),
                radius: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  userName,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          TextWithIcon(
            icon: Icons.calendar_today,
            text: 'Accepté le: ${DateFormat('dd MMM yyyy').format(acceptedAt)}',
            iconColor: Colors.blue,
            textColor: Colors.black,
          ),
          TextWithIcon(
            icon: Icons.hourglass_bottom,
            text: 'Durée: $duration',
            iconColor: Colors.blue,
            textColor: Colors.black,
          ),
          TextWithIcon(
            icon: Icons.euro,
            text: 'Prix: €$price',
            iconColor: Colors.green,
            textColor: Colors.black,
          ),
          SizedBox(height: 10),
          Text(
            "Status: Offre Acceptée",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.green,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ActionButton(
                title: 'Chat',
                icon: Icons.chat,
                color: Colors.green,
                onPressed: () {
                  // Chat functionality
                },
              ),
              SizedBox(width: 10),
              ActionButton(
                title: 'Payer',
                icon: Icons.payment,
                color: Colors.blue,
                onPressed: () {
                  // Payment functionality
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
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
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
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
