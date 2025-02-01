import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/NotificationService.dart';
import 'ConfirmationNotficationCard.dart';
import 'SuccessNotificationCard.dart';

class NotificationTile extends StatelessWidget {
  final int notificationId;
  final String title;
  final String body;
  final String formattedTime;
  final String imageUrl;

  const NotificationTile({
    Key? key,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.formattedTime,
    required this.imageUrl,
  }) : super(key: key);

  Future<void> _deleteNotification(BuildContext parentContext) async {
    final notificationService = NotificationService();
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous supprimer cette notification ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop();
            try {
              await notificationService.deleteNotification(notificationId);
              showDialog(
                context: parentContext,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Notification supprimée avec succès!',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );

              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(parentContext).pop();
                Navigator.of(parentContext).pop();
              });
            } catch (e) {
              showDialog(
                context: parentContext,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Erreur lors de la suppression: $e',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );

              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(parentContext).pop();
              });
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        _deleteNotification(context);
        return false;
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                  Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: GoogleFonts.roboto(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                body,
                style: GoogleFonts.roboto(fontSize: 14.0, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}