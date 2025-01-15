import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/components/Card/NotificationCard.dart';
import '../../components/appBar/appBar.dart';
import '../../components/navbara.dart';
import '../../theme/AppTheme.dart';
import '../SideMenu.dart';
import 'dart:io';

import 'package:khedma/Services/NotificationService.dart';
import 'package:khedma/entities/NotificationMesage.dart';


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isSettingsDrawer = false;
  final NotificationService notificationService = NotificationService();

  void _toggleDrawer(BuildContext context) {
    setState(() {
      _isSettingsDrawer = !_isSettingsDrawer;
    });
    Navigator.of(context).pop();
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 690));
    return Scaffold(
      backgroundColor: Color(0xFFC8D9FF),
      endDrawer: _isSettingsDrawer
          ? Builder(builder: (context) => SettingsDrawer(toggleDrawer: () => _toggleDrawer(context)))
          : Builder(builder: (context) => MyDrawer(toggleDrawer: () => _toggleDrawer(context))),
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Notifications',
        showSearchBar: false,
        backgroundColor: Color(0xFF0099D6),
      ),
      body: Container(
        padding: EdgeInsets.all(16.w),
        child: FutureBuilder<List<NotificationMessage>>(
          future: notificationService.getNotificationsByUserId(6),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.map((notification) {
                  return NotificationTile(
                    title: notification.title ?? "No title",
                    body: notification.body ?? "No content",
                    formattedTime: DateFormat('dd/MM/yyyy hh:mm a').format(notification.date),
                    imageUrl:  'https://www.elitesingles.com/wp-content/uploads/sites/85/2020/06/elite_singles_slide_6-350x264.png',
                  );
                }).toList(),
              );
            } else {
              return Center(child: Text("No notifications found"));
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}