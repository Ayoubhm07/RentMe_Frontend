import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/components/navbara.dart';
import 'package:khedma/entities/User.dart';
import 'package:khedma/screens/SideMenu.dart';
import 'package:khedma/theme/AppTheme.dart';
import '../../components/Card/ServiceCard.dart';
import '../../components/Switch/CustomSwitch1.dart';
import '../../components/appBar/appBar.dart';
import '../../entities/Demand.dart';
import '../../entities/Offre.dart';

class MyRequestsPage extends StatefulWidget {
  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  bool _isSettingsDrawer = false;
  List<bool> showOffersBoools = [];

  Map<Demand, List<Offre>> demandOffers = {};
  Map<Offre, User> offreUser = {};
  Map<User, String> userImage = {};

  Future<void> loadDemands() async {
    DemandeService demandeService = DemandeService();
    OffreService offreService = OffreService();
    SharedPrefService sharedPrefService = SharedPrefService();
    UserService userService = UserService();
    ProfileService profileService = ProfileService();
    // load the demands
    User Currentuser = await sharedPrefService.getUser();
    List<Demand> demands = await demandeService.getDemandsByUserId(Currentuser.id!);
    for (int i = 0; i < demands.length; i++) {
      showOffersBoools.add(false);
    }
    for (Demand demand in demands) {
      List<Offre> offers = await offreService.getOffersByDemand(demand.id!);
      demandOffers[demand] = offers;
      for (Offre offre in offers) {
        User user = await userService.findUserById(offre.userId);
        offreUser[offre] = user;
        String? image = await profileService.getProfileImage(user.id!);
        userImage[user] = await MinIOService().LoadFileFromServer(image!.split('_')[0], image.split('_')[1]);
      }
    }
  }

  bool showOffers(int index) {
    return showOffersBoools[index];
  }

  @override
  void initState() {
    super.initState();
    loadDemands();

  }

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
      backgroundColor: Colors.white,
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
        notificationIcon: Icon(Icons.location_on_outlined, color: Colors.white),
        title: 'Mes Demandes',
        showSearchBar: false,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, true),
            SizedBox(height: 20.h),
            ListView.builder(
              itemCount: demandOffers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Demand demand = demandOffers.keys.elementAt(index);
                List<Offre> offers = demandOffers[demand]!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 250.h,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          // Keeping this primaryColor as per your design
                          borderRadius: BorderRadius.all(Radius.circular(30.h)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(2.h),
                                    child: DemandCard(demand, offers),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: TextButton(
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                    Size(200.w, 40.h),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    AppTheme.green,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showOffersBoools[index]= !showOffersBoools[index];
                                  });
                                },
                                child: Text(
                                  showOffers(index)
                                      ? 'Cacher les offres'
                                      : 'Voir les offres',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    showOffers(index) ? OffresCard(offers) : Container(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context, bool isPortrait) {
    return Container(
      width: double.infinity,
      height: 110.h,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        // Keeping this primaryColor as per your design
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.h)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: CustomSwitch(buttonLabels: ["en cours", "Terminés"]),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor,
      {bool hasIcon = false}) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(bgColor),
        side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.white, width: 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
      onPressed: () {},
      child: Container(
        width: 90.75.w,
        height: 20.87.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon)
              Image.asset("assets/images/edit.png",
                  width: 16.sp, height: 16.sp),
            if (hasIcon) SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget DemandCard(Demand demand, List<Offre> offers) {
    return Container(
      width: 303.39.w,
      height: 100.68.h,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 303.39.w,
              height: 100.68.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Domaine: ' + demand.domain,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF585858),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Budget: ' + demand.budget.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF585858),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      demand.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget OffresCard(List<Offre> offers) {
    // show a list of offers that contains the user image and name and the proposed price and two buttons that i already made their function accecpt and reject
    return Column(
      children: offers.map((offre) {
        User user = offreUser[offre]!;
        String image = userImage[user]!;
        return Container(
          width: 303.39.w,
          height: 100.68.h,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 300.39.w,
                  height: 70.90.h,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFAF1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.65),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: CircleAvatar(
                          radius: 20.sp,
                          backgroundImage: NetworkImage(image),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.firstName + ' ' + user.lastName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Prix proposé ' + offre.price.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF585858),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
