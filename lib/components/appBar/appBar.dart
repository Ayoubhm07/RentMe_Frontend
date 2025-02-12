import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../screens/MainPages/NotificationSpace.dart';
import '../../theme/AppTheme.dart';
import '../Switch/CustomSwitchRechereche.dart';
import '../../Services/NotificationService.dart';
import '../../Services/SharedPrefService.dart';
import '../../entities/User.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget notificationIcon;
  final String title;
  final bool showSearchBar;
  final Color backgroundColor;

  const CustomAppBar({
    Key? key,
    required this.notificationIcon,
    required this.title,
    this.showSearchBar = false,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(showSearchBar ? 130.h : 70.h);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int unreadCount = 0;
  late NotificationService notificationService;
  late SharedPrefService sharedPrefService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    sharedPrefService = SharedPrefService();
    _fetchUnreadNotifications();
  }

  Future<void> _fetchUnreadNotifications() async {
    try {
      User? user = await sharedPrefService.getUser();
      if (user != null) {
        int count = await notificationService.getUnreadCount(user.id!);
        setState(() {
          unreadCount = count;
          print("NOMBREEEEEEEES UNREAD:{$unreadCount}");
        });
      }
    } catch (e) {
      print('Error fetching unread notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.h)),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: widget.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                ).then((_) => _fetchUnreadNotifications());
              },
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: widget.notificationIcon,
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: 18.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        bottom: widget.showSearchBar
            ? PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 100.w, vertical: 25.h),
            child: Container(
              height: 40.h,
              width: 250.w,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Recherche',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.blue),
                    onPressed: () {
                      _showSearchCard(context);
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        )
            : null,
      ),
    );
  }

  void _showSearchCard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.all(40.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        color: AppTheme.secondaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: 90.0),
                    Text(
                      'Recherche',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Type de recherche',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomSwitchRecherche(
                  buttonLabels: ['Profile', 'Location'],
                ),
                SizedBox(height: 20.h),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
