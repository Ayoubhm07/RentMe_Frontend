import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/screens/Messages.dart';

import '../screens/ChatMessage.dart';
import '../screens/MainPages/Demandes/AjouterDemande.dart';
import '../screens/MainPages/Home/HomePage.dart';
import '../screens/MainPages/RequestsPage.dart';
import '../screens/NewProfile.dart';
import '../theme/AppTheme.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = PageStorage.of(context)?.readState(context) ?? 0;
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bientôt disponible',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue,
        ),
      );
      return; // Empêcher toute autre action
    }

    setState(() {
      _selectedIndex = index;
    });

    // Sauvegarder l'index sélectionné dans PageStorage
    PageStorage.of(context)?.writeState(context, index);

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        break;
      case 2:
        CustomBottomSheet.show(context);
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagePage(),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double iconSize = isLandscape ? 36.sp : 28.sp;

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/icons/Home.png",
            height: iconSize,
            width: iconSize,
            color: _selectedIndex == 0 ? AppTheme.primaryColor : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.5, // Rendre l'icône plus claire
                child: Image.asset(
                  "assets/icons/journal.png",
                  height: iconSize * 0.9,
                  width: iconSize * 0.9,
                  color: _selectedIndex == 1 ? AppTheme.primaryColor : Colors.grey,
                ),
              ),
              Positioned(
                top: -10.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: iconSize * 1.5,
            width: iconSize * 1.5,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(iconSize * 0.75),
            ),
            child: Center(
              child: Image.asset(
                "assets/icons/plus.png",
                height: iconSize * 0.8,
                width: iconSize * 0.8,
                color: _selectedIndex == 2 ? Colors.white : Colors.grey,
              ),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/icons/chat.png",
            height: iconSize,
            width: iconSize,
            color: _selectedIndex == 3 ? AppTheme.primaryColor : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/icons/profile.png",
            height: iconSize * 0.8,
            width: iconSize * 0.8,
            color: _selectedIndex == 4 ? AppTheme.primaryColor : Colors.grey,
          ),
          label: '',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}