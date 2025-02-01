import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/components/Sections/AcceptedOffersSection.dart';
import 'package:khedma/components/Sections/DoneOffersSection.dart';
import 'package:khedma/components/Sections/PendingOffersSection.dart';
import 'package:khedma/components/Sections/RejectedOffersSection.dart';
import '../../Services/OffreService.dart';
import '../Card/CardOffre.dart';
import '../Card/CardOffreEnCours.dart';
import '../Sections/AcceptedLocationOffersSection.dart';
import '../Sections/DoneLocationOffersSection.dart';
import '../Sections/PendingLocationOffersSection.dart';
import '../Sections/RejectedLocationOffersSection.dart';

class CustomSwitchOffreLocation extends StatefulWidget {
  final List<String> buttonLabels;

  const CustomSwitchOffreLocation({Key? key, required this.buttonLabels}) : super(key: key);

  @override
  State<CustomSwitchOffreLocation> createState() => _CustomSwitchOffreLocationState();
}

class _CustomSwitchOffreLocationState extends State<CustomSwitchOffreLocation> {
  final OffreLocationService offreService = OffreLocationService();
  late List<bool> isSelected;
  final OffreService offreServicee = OffreService();


  @override
  void initState() {
    super.initState();
    isSelected = List.generate(widget.buttonLabels.length, (index) => index == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            fillColor: const Color(0xFF2DC4FF),
            selectedColor: Color(0xFFE7E6E6),
            color: Colors.white,
            constraints: BoxConstraints(
              minWidth: 75.0.w,
              minHeight: 44.0.h,
            ),
            children: <Widget>[
              for (int i = 0; i < widget.buttonLabels.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.buttonLabels[i],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected[i] ? Colors.white : Colors.grey,
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
    );
  }

  Widget _buildContent() {
    if (isSelected[0]) {
      return AcceptedLocationOffersSection(offreService: offreService);
    } else if (isSelected[1]) {
      return DoneLocationOffersSection(offreService: offreService);
    } else if (isSelected[2]) {
      return PendingLocationOffersSection(offreService: offreService);
    } else {
      return RejectedLocationOffersSection(offreService: offreService);
    }
  }

}


