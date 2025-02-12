import 'package:flutter/material.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/NotificationService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:intl/intl.dart';
import 'package:khedma/components/Card/NotificationCard.dart';
import 'package:khedma/components/appBar/appBar.dart';
import 'package:khedma/components/navbara.dart';
import '../../components/Card/CheckedNotificationCard.dart';
import '../../components/Card/ConfirmationNotficationCard.dart';
import '../../components/Card/SuccessNotificationCard.dart';
import '../../entities/NotificationMesage.dart';
import '../../entities/ProfileDetails.dart';
import '../../entities/User.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationService notificationService = NotificationService();
  SharedPrefService sharedPrefService = SharedPrefService();
  ProfileService profileService = ProfileService();
  MinIOService minIOService = MinIOService();
  String? userImage;
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _fetchUserProfileImage();
  }

  Future<void> _fetchUserProfileImage() async {
    try {
      User user = await sharedPrefService.getUser();
      ProfileDetails profileDetails = await profileService.getProfileDetails(user.id ?? 0);
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

  // Initialize the user
  Future<void> _initializeUser() async {
    try {
      User? user = await sharedPrefService.getUser();
      setState(() {
        _userId = user?.id ?? 0;
      });
    } catch (e) {
      print('Error retrieving user: $e');
      setState(() {
        _userId = 0;
      });
    }
  }

  // Delete all notifications
  Future<void> _deleteAllNotifications() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous supprimer toutes les notifications ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop();
            try {
              String result = await notificationService.deleteAllNotificationsByUserId(_userId);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Toutes les notifications ont été supprimées avec succès!',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );

              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(); // Close SuccessDialog
              });
            } catch (e) {
              // Show error dialog in case of failure
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Erreur lors de la suppression: $e',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );

              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(); // Close ErrorDialog
              });
            }
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close the confirmation dialog
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Notifications',
        showSearchBar: false,
        backgroundColor: Color(0xFF0099D6),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<NotificationMessage>>(
          future: notificationService.getNotificationsByUserId(_userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.map((notification) {
                  // Display notifications based on their state
                  if (notification.state == NotificationState.unread) {
                    return UnreadNotificationTile(
                      senderId: notification.senderId ?? 0,
                      notificationId: notification.id ?? 0,
                      title: notification.title ?? "No title",
                      body: notification.body ?? "No content",
                      formattedTime: DateFormat('dd/MM/yyyy hh:mm a').format(notification.date),
                      imageUrl:userImage ?? "",
                    );
                  } else {
                    return NotificationTile(
                      senderId: notification.senderId ?? 0,
                      notificationId: notification.id ?? 0,
                      title: notification.title ?? "No title",
                      body: notification.body ?? "No content",
                      formattedTime: DateFormat('dd/MM/yyyy hh:mm a').format(notification.date),
                      imageUrl:userImage ?? "",
                    );
                  }
                }).toList(),
              );
            } else {
              return Center(child: Text("Aucune notification trouvée"));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _deleteAllNotifications,
        tooltip: 'Supprimer toutes les notifications',
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.delete_forever, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
