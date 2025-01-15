import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'PaymentConfirmation.dart';

class DemandAcceptedOfferCard extends StatefulWidget {
  final int benifId;
  final String userName;
  final String userImage;
  final DateTime acceptedAt;
  final String duration;
  final int price;
  final int demandId;
  const DemandAcceptedOfferCard({
    Key? key,
    required this.benifId,
    required this.demandId,
    required this.userName,
    required this.userImage,
    required this.acceptedAt,
    required this.duration,
    required this.price,
  }) : super(key: key);

  @override
  _DemandAcceptedOfferCardState createState() => _DemandAcceptedOfferCardState();
}

class _DemandAcceptedOfferCardState extends State<DemandAcceptedOfferCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black87, Colors.grey[850]!], // Dark gradient
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
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
          Center(
            child: Text(
              "OFFRE ACCEPTÉE",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                foreground: Paint()..shader = LinearGradient(
                  colors: [Colors.green, Colors.green],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userImage),
                radius: 25,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.userName,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          _buildTextWithIcon(Icons.calendar_today, 'Accepté le: ${DateFormat('dd MMM yyyy').format(widget.acceptedAt)}', Colors.lightGreen),
          _buildTextWithIcon(Icons.hourglass_bottom, 'Durée: ${widget.duration}', Colors.cyan),
          _buildTextWithIcon(Icons.euro_symbol, 'Prix: €${widget.price}', Colors.lightGreen),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton('Chat', Icons.chat, Colors.green[700]!, () {
                print('Chat button pressed');
              }),
              _buildActionButton('Payer', Icons.payment, Colors.blue[800]!, () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return ConfirmPaymentWidget(benifId: widget.benifId, amount: widget.price, userName: widget.userName, demandId: widget.demandId,);
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextWithIcon(IconData icon, String text, Color iconColor) {
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
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
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
