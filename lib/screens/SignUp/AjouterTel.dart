import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart'; // Make sure you've added this import
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/SharedPrefService.dart';
import '../../entities/User.dart';
import '../../theme/AppTheme.dart';


class PhoneInputController{
  final TextEditingController _phoneController = TextEditingController();
  final SharedPrefService sharedPrefService = SharedPrefService();
  String selectedCountryCode = '+1';
  String selectedCountryFlag = '🇺🇸';

  Future<Map<String, dynamic>> validate() async {
    String errorMessage = '';
    Map<String, dynamic> result = {};

    Map<String, Map<String, int>> countryPhoneLengths = {
      '+1': {'min': 10, 'max': 10}, // Example for US
      '+33': {'min': 9, 'max': 9},  // Example for France
      '+216': {'min': 8, 'max': 8},  // Example for Tunisia
      // Add other countries here
    };
    if (_phoneController.text.isEmpty) {
      errorMessage = 'Veuillez entrer votre numéro de téléphone';
      result = {'error': true, 'message': errorMessage};
      return result;
    } else if (_phoneController.text.length < countryPhoneLengths[selectedCountryCode]!['min']! ||
        _phoneController.text.length > countryPhoneLengths[selectedCountryCode]!['max']!) {
      errorMessage = 'Veuillez entrer un numéro de téléphone valide';
      result = {'error': true, 'message': errorMessage};
      return result;

    }
    // verify its all numbers
    else if(!RegExp(r'^[0-9]*$').hasMatch(_phoneController.text)){
      errorMessage = 'Veuillez entrer un numéro de téléphone valide';
      result = {'error': true, 'message': errorMessage};
      return result;
    }

    await save();
    return result;
  }
  Future <void> save() async {
    User user = await sharedPrefService.getUser();
    user.numTel = selectedCountryCode + _phoneController.text ;
    await sharedPrefService.saveUser(user);
    await sharedPrefService.saveStringToPrefs('flag',  selectedCountryFlag);
    await sharedPrefService.saveStringToPrefs('code',  selectedCountryCode);
    await sharedPrefService.saveStringToPrefs('phone', _phoneController.text);
    print(" 4 - user after adding phone number : ");
    await sharedPrefService.checkAllValues();
  }
}

class PhoneInput extends StatefulWidget {
  final PhoneInputController controller;
  const PhoneInput({super.key, required this.controller});

  @override
  PhoneInputState createState() => PhoneInputState();
}

class PhoneInputState extends State<PhoneInput> {

  final SharedPrefService sharedPrefService = SharedPrefService();


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.controller.selectedCountryCode = prefs.getString('code') ?? '+1';
      widget.controller.selectedCountryFlag = prefs.getString('flag') ?? '🇺🇸';
      widget.controller._phoneController.text = prefs.getString('phone') ?? '';
    });
    }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Image.asset(
                  "assets/images/logo_rent_me-removebg-preview 2.png",
                  width: 50.w,
                  height: 50.h,
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/images/img_10.png",
                  width: 150.w,
                  height: 150.h,
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                'Votre numéro de téléphone',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,

                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                'Votre numéro de téléphone est nécessaire pour que nous puissions vous contacter.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.accentColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            widget.controller.selectedCountryCode = '+${country.phoneCode}';
                            widget.controller.selectedCountryFlag = country.flagEmoji;
                          });
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Text( widget.controller.selectedCountryFlag, style: TextStyle(fontSize: 24.sp)),
                          SizedBox(width: 8.w),
                          Text( widget.controller.selectedCountryCode, style: TextStyle(fontSize: 16.sp)),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildTextField({
                      'label': '',
                      'hint': '',
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTextField(Map<String, dynamic> textFieldData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppTheme.grisTextField, // Change this to your desired background color
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller._phoneController,
        decoration: InputDecoration(
          hintText: textFieldData['hint'],
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          hintStyle: TextStyle(color: AppTheme.secondaryColor), // Change hint text color here
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField), // Border color
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField), // Border color when inactive
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField), // Border color when active
          ),
        ),
      ),
    );
  }
}



