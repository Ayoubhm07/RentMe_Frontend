import 'package:flutter/material.dart';
import 'package:khedma/components/appBar/appBar.dart';
import '../../../components/Switch/CustomSwitchLocation.dart';

import '../../../components/navbara.dart';
import '../../SideMenu.dart';

class DemandelocationtScreen extends StatefulWidget {
  @override
  _DemandelocationtScreenState createState() => _DemandelocationtScreenState();
}

class _DemandelocationtScreenState extends State<DemandelocationtScreen> {
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
      backgroundColor: Color(0xFFF7AA1E),
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
        title: 'Offres de Location',
        showSearchBar: false,
        backgroundColor: Color(0xFFF7AA1E),
      ),
      body: Column(
        children: [
          CustomSwitchLocation(
            buttonLabels: ['Disponible', 'Mes Offres'],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),

      // Add a button to trigger the drawer for testing purposes
    );
  }
}
