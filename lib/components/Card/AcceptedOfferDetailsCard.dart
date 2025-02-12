import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Services/ConversationAndMessageService.dart';
import '../../Services/OffreLocationService.dart';
import '../../Services/UserService.dart';
import '../../entities/Conversation.dart';
import '../../entities/OffreLocation.dart';
import '../../entities/User.dart';
import '../../screens/ChatMessage.dart';
import 'ConfirmationNotficationCard.dart';
import 'SuccessNotificationCard.dart';

class OfferDetailsCard extends StatelessWidget {
  final OffreLocation offer;
  final String username;
  final int userId;

  OfferDetailsCard({Key? key, required this.offer, required this.username, required this.userId}) : super(key: key);



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


  Future<void> terminerOffre(BuildContext context, int id) async {
    final offreLocationService = OffreLocationService();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous vraiment terminer cette offre ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop(); // Close the ConfirmationDialog
            try {
              await offreLocationService.terminerOffre(id);
              print('Offre terminée avec succès');
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return SuccessDialog(
                    message: 'Offre terminée avec succès!',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );
              Future.delayed(Duration(seconds: 2), () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop(); // Close SuccessDialog
                  Navigator.of(context).pop(); // Close SuccessDialog
                }
              });
            } catch (e) {
              print('Échec de la terminaison de l\'offre: $e');
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return SuccessDialog(
                    message: 'Échec de la terminaison de l\'offre: $e',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );

              // Close error dialog after 2 seconds
              Future.delayed(Duration(seconds: 2), () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              });
            }
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close the ConfirmationDialog if canceled
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: Colors.green[300],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails de l\'offre acceptée:',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 10.h),
            iconTextRow(Icons.person, "Postulé par: $username"),
            iconTextRow(Icons.attach_money, "Prix: ${offer.price}£"),
            iconTextRow(Icons.calendar_today, "Période: ${offer.periode}"),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await _handleMessageClick(context, senderId: userId, receiverId: offer.userId);
                  },
                  icon: Icon(Icons.chat, color: Colors.green[800]),
                  label: Text('Contacter le client'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green[800],
                    backgroundColor: Colors.white, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => terminerOffre(context,offer.id ?? 0),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green[800],
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text('Terminer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
