import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MinIOService.dart';

import '../../Services/NotificationService.dart';
import '../../Services/ProfileService.dart';
import '../../entities/ProfileDetails.dart';
import 'ConfirmationNotficationCard.dart';
import 'SuccessNotificationCard.dart';

class UnreadNotificationTile extends StatefulWidget {
  final int notificationId;
  final String title;
  final String body;
  final String formattedTime;
  final String imageUrl;
  final int senderId;


  const UnreadNotificationTile({
    Key? key,
    required this.senderId,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.formattedTime,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _UnreadNotificationTileState createState() => _UnreadNotificationTileState();
}

class _UnreadNotificationTileState extends State<UnreadNotificationTile> {
  final NotificationService notificationService = NotificationService();
  bool _isUpdatingState = false;
  ProfileService profileService = ProfileService();
  MinIOService minIOService = MinIOService();
  String? userImage;


  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
    _markAsRead();
  }


  Future<void> _fetchUserProfileImage() async {
    try {
      ProfileDetails profileDetails = await profileService.getProfileDetails(widget.senderId);
      String objectName = profileDetails.profilePicture!.replaceFirst('images_', '');
      String filePath = await minIOService.LoadFileFromServer('images', objectName);
      setState(() {
        userImage = filePath;
      });
      print(userImage);
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  Future<void> _markAsRead() async {
    setState(() {
      _isUpdatingState = true;
    });
    try {
      await notificationService.updateNotificationState(widget.notificationId, 'READ');
      print("Notification ${widget.notificationId} marked as read");
    } catch (e) {
      print("Error marking notification as read: $e");
    } finally {
      setState(() {
        _isUpdatingState = false;
      });
    }
  }

  Future<void> _deleteNotification(BuildContext parentContext) async {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous supprimer cette notification ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop();
            try {
              await notificationService.deleteNotification(widget.notificationId);
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
                Navigator.of(parentContext).pop(); // Close ErrorDialog
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
        color: _isUpdatingState ? Colors.grey[200] : Color(0xFFE0F7FA), // Show a subtle color change while updating state
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: widget.imageUrl != null
                        ? FileImage(File(userImage!))
                        : AssetImage("assets/images/default_avatar.png") as ImageProvider,
                  ),
                  Text(
                    widget.formattedTime.isNotEmpty ? widget.formattedTime : 'Temps inconnu',
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Text(
                widget.title.isNotEmpty ? widget.title : 'Titre indisponible',
                style: GoogleFonts.roboto(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.body.isNotEmpty ? widget.body : 'Aucun contenu',
                style: GoogleFonts.roboto(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
