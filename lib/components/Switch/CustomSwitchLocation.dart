import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/components/Sections/LocationsSection.dart';
import 'package:khedma/components/Sections/MyLocationsOffersSection.dart';
import 'package:khedma/entities/Location.dart';
import 'package:khedma/entities/User.dart';
import 'package:khedma/theme/AppTheme.dart';

import '../Card/CardItemHistorique.dart';
import '../Card/CardItemHistorique2.dart';
import '../Card/RentalItemCard.dart';

class CustomSwitchLocation extends StatefulWidget {
  final List<String> buttonLabels;

  CustomSwitchLocation({Key? key, required this.buttonLabels}) : super(key: key);


  @override
  State<CustomSwitchLocation> createState() => _CustomSwitchLocationState();
}

class _CustomSwitchLocationState extends State<CustomSwitchLocation> {
  List<bool> isSelected = [true, false];

  final LocationService locationService = LocationService();
  final SharedPrefService sharedPrefService = SharedPrefService();
  final UserService userService = UserService();



  @override
  Widget build(BuildContext context) {
    return Expanded( // Wrap the entire Column in Expanded to provide height constraint
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(9.0),
              borderColor: Colors.transparent,
              selectedBorderColor: Colors.transparent,
              fillColor: const Color(0xFFF7AA1E),
              selectedColor: Colors.white,
              color: Colors.grey,
              constraints: BoxConstraints(
                minWidth: 150.0.w,
                minHeight: 44.0.h,
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.buttonLabels[0],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected[0] ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.buttonLabels[1],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected[1] ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    isSelected[buttonIndex] = (buttonIndex == index);
                  }
                });
              },
              isSelected: isSelected,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return isSelected[0]
        ? OffersSection(context)
        : MyLocationsOffersSection(locationService: locationService, sharedPrefService: sharedPrefService,); // Placeholder for second tab content
  }


}



