import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Services/SharedPrefService.dart';
import '../../theme/AppTheme.dart';

class DonneeadresseController {
  SharedPrefService sharedPrefService = SharedPrefService();
  String selectedCountryFlag = '🇺🇸'; // Default country flag (USA)
  final TextEditingController AdresseController = TextEditingController();
  final TextEditingController VilleController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController PaysController = TextEditingController();

  Map<String, dynamic> validate() {
    Map<String, dynamic> result = {};
    String errorMessage = '';
    if (AdresseController.text.isEmpty ||
        VilleController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        PaysController.text.isEmpty) {
      errorMessage = 'Veuillez remplir tous les champs';
      result = {'error': true, 'message': errorMessage};
    }

    return result;
  }

  void save() {
    sharedPrefService.saveStringToPrefs('Adresse', AdresseController.text);
    sharedPrefService.saveStringToPrefs('Ville', VilleController.text);
    sharedPrefService.saveStringToPrefs('CodePostal', postalCodeController.text);
    sharedPrefService.saveStringToPrefs('Pays', PaysController.text);
  }
}

class Donneeadresse extends StatefulWidget {
  final DonneeadresseController controller;

  const Donneeadresse({Key? key, required this.controller}) : super(key: key);

  @override
  _DonneeadresseState createState() => _DonneeadresseState();
}

class _DonneeadresseState extends State<Donneeadresse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Image.asset(
                      "assets/images/logo_rent_me-removebg-preview 2.png",
                      width: 50.w,
                      height: 50.h,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Vos données principales',
                        style: TextStyle(
                          fontSize: 0.06.sw,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                          fontFamily: 'Roboto',
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Nous souhaitons mieux vous connaître afin de finaliser votre profil.',
                        style: TextStyle(
                          fontSize: 0.04.sw,
                          color: AppTheme.accentColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 70.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                widget.controller.selectedCountryFlag =
                                    country.flagEmoji;
                              });
                              print('Select country: ${country.displayName}');
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Text(widget.controller.selectedCountryFlag,
                                  style: TextStyle(fontSize: 24.sp)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildTextField({
                          'label': '',
                          'hint': '',
                          'controller': widget.controller.PaysController,
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  _buildTextField({
                    'label': 'Ville',
                    'hint': 'Ville',
                    'controller': widget.controller.VilleController
                  }),
                  SizedBox(height: 30.h),
                  _buildTextField({
                    'label': 'Adresse',
                    'hint': 'Adresse',
                    'controller': widget.controller.AdresseController
                  }),
                  SizedBox(height: 30.h),
                  _buildTextField({
                    'label': 'Code Postal',
                    'hint': 'Code Postal',
                    'controller': widget.controller.postalCodeController
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(Map<String, dynamic> textFieldData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppTheme.grisTextField,
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
        controller: textFieldData['controller'],
        decoration: InputDecoration(
          hintText: textFieldData['hint'],
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          hintStyle: TextStyle(color: AppTheme.secondaryColor),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField),
          ),
        ),
      ),
    );
  }
}