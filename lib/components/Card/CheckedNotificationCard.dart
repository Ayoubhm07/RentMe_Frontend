import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/MinIOService.dart';
import '../../Services/NotificationService.dart';
import '../../Services/ProfileService.dart';
import '../../entities/ProfileDetails.dart';
import 'ConfirmationNotficationCard.dart';
import 'SuccessNotificationCard.dart';

class NotificationTile extends StatefulWidget {
  final int notificationId;
  final String title;
  final String body;
  final String formattedTime;
  final String imageUrl;
  final int senderId;

  const NotificationTile({
    Key? key,
    required this.senderId,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.formattedTime,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {

  final NotificationService notificationService = NotificationService();
  bool _isUpdatingState = false;
  ProfileService profileService = ProfileService();
  MinIOService minIOService = MinIOService();
  String? userImage;


  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
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
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: userImage != null
                        ? FileImage(File(userImage!))
                        : AssetImage("assets/images/default_avatar.png") as ImageProvider,
                  ),
                  Text(
                    widget.formattedTime,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                widget.title,
                style: GoogleFonts.roboto(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                widget.body,
                style: GoogleFonts.roboto(fontSize: 14.0, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}