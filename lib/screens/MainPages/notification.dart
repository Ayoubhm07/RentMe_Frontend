import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/appBar/appBar.dart';
import '../../components/navbara.dart';
import '../../theme/AppTheme.dart';
import '../SideMenu.dart'; // Assurez-vous que ce chemin est correct ou ajustez-le si nécessaire.
import 'dart:io'; // Pour manipuler le fichier

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isSettingsDrawer = false;

  void _toggleDrawer(BuildContext context) {
    setState(() {
      _isSettingsDrawer = !_isSettingsDrawer;
    });
    Navigator.of(context).pop(); // Close the current drawer
    Scaffold.of(context).openEndDrawer(); // Open the new drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8D9FF),
      // Set the background color

      endDrawer: _isSettingsDrawer
          ? Builder(
        builder: (context) =>
            SettingsDrawer(toggleDrawer: () => _toggleDrawer(context)),
      )
          : Builder(
        builder: (context) =>
            MyDrawer(toggleDrawer: () => _toggleDrawer(context)),
      ),

      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Notifications',
        showSearchBar: true,
        backgroundColor: Color(0xFF0099D6),
      ),
      // Use the new CustomAppBar

      body: Container(
        padding: EdgeInsets.all(16.w),
        color: Color(0xFFC8D9FF), // Light purple color for the container
        child: ListView(
          children: [
            _buildNotificationTile(
              context,
              'Savannah Nguyen',
              'Cliente',
              'Savannah a accepté votre offre de prix.',
              '8:01',
              'https://www.elitesingles.com/wp-content/uploads/sites/85/2020/06/elite_singles_slide_6-350x264.png',
            ),
            _buildNotificationTile(
              context,
              'Annette Black',
              'Developer',
              'Annette a répondu à votre demande.',
              '5 Mar',
              'https://www.elitesingles.com.au/wp-content/uploads/sites/77/2020/06/profileprotectionsnap-350x264.jpg',
            ),
            _buildNotificationTile(
              context,
              'Annette Black',
              'Cliente',
              'Annette a refusé votre offre de prix.',
              '5 Mar',
              'https://www.perfocal.com/blog/content/images/size/w1920/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
            ),
            _buildNotificationTile(
              context,
              'RentMe',
              '',
              'Vous avez reçu un paiement de 98€.',
              '3 Feb',
              null,
              icon: Icons.account_balance_wallet,
            ),
            _buildNotificationTile(
              context,
              'RentMe',
              '',
              'Vous avez transféré un montant de 102€ à Annette Black.',
              '3 Feb',
              null,
              icon: Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildNotificationTile(BuildContext context,
      String title,
      String subtitle,
      String message,
      String time,
      String? imageUrl, {
        IconData? icon,
      }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.w),
      ),
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: imageUrl != null
            ? CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        )
            : Icon(icon, size: 40.w),
        title: Text(title),
        subtitle: Text('$subtitle\n$message'),
        trailing: Text(time, style: TextStyle(color: Colors.grey)),
        isThreeLine: true,
        onTap: () {

        },
      ),
    );
  }

}
