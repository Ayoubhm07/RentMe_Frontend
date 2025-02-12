import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Services/ConversationAndMessageService.dart';
import '../../Services/MinIOService.dart';
import '../../Services/ProfileService.dart';
import '../../Services/UserService.dart';
import '../../entities/Conversation.dart';
import '../../entities/ProfileDetails.dart';
import '../../entities/User.dart';
import '../../screens/ChatMessage.dart';
import 'PaymentConfirmation.dart';

class DemandAcceptedOfferCard extends StatefulWidget {
  final int userId;
  final int benifId;
  final String userName;
  final String userImage;
  final DateTime acceptedAt;
  final String duration;
  final int price;
  final int demandId;
  const DemandAcceptedOfferCard({
    Key? key,
    required this.userId,
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
  final ProfileService profileService = ProfileService();
  final MinIOService minIOService = MinIOService();
  String? userImage;

  Future<void> _fetchUserProfileImage() async {
    try {
      ProfileDetails profileDetails2 = await profileService.getProfileDetails(widget.benifId);
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
  }

  Future<void> _handleMessageClick(BuildContext context, {required int senderId, required int receiverId}) async {
    try {
      User currentUser = await UserService().findUserById(senderId);
      User receiver = await UserService().findUserById(receiverId);

      if (senderId == null || receiverId == null) {
        throw Exception("senderId ou receiverId est null");
      }

      ConversationAndMessageService service = ConversationAndMessageService();
      Conversation conversation = await service.createConversation(
        senderId,
        [receiverId],
      );

      int conversationId = conversation.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatMessagePage(
            conversationId: conversationId,
            receiver: receiver,
            currentUser: currentUser,
          ),
        ),
      );
    } catch (e) {
      print("Erreur lors de la création de la conversation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la création de la conversation: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



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
                radius: 20.r,
                backgroundImage: userImage != null
                    ? FileImage(File(userImage!))
                    : AssetImage("assets/images/default_avatar.png") as ImageProvider,
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
              _buildActionButton(
                'Chat', // Titre du bouton
                Icons.chat, // Icône du bouton
                Colors.green[700]!, // Couleur du bouton
                    () async {
                  print('Chat button pressed');
                  await _handleMessageClick(context, senderId: widget.userId, receiverId: widget.benifId);
                },
              ),
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
