import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/components/Stepper/ProfileStepper.dart';
import 'package:khedma/components/Stepper/stepperComplet.dart';
import 'package:khedma/entities/ProfileDetails.dart';
import 'package:khedma/screens/MainPages/Home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../entities/User.dart';
import '../../screens/SignUp/AjouterTel.dart';
import '../../screens/SignUp/verifMail.dart';
import '../../screens/SignUp/verificationTel.dart';
import '../../screens/SignUp/DoneePrincipale.dart';
import '../../theme/AppTheme.dart';

class CustomStepper extends StatefulWidget {
  const CustomStepper({super.key});

  @override
  CustomStepperState createState() => CustomStepperState();
}

class CustomStepperState extends State<CustomStepper> {
  int currentStep = 0;
  int totalSteps = 4;
  UserService userService = UserService();
  ProfileService profileService = ProfileService();
  SharedPrefService sharedPrefService = SharedPrefService();
  final SignUpFormController signUpFormController = SignUpFormController();
  final VerificationMailController verificationMailController =
  VerificationMailController();
  final PhoneInputController phoneInputController = PhoneInputController();
  final VerificationPageController verificationPageController =
  VerificationPageController();

  Map<String, dynamic> validationErrors = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> saveUser() async {
    User user = await sharedPrefService.getUser();
    print("2 - user from shared pref: $user");
    bool response = await userService.saveUser(user);
    print("2 - shared pref after save: ");
    await sharedPrefService.checkAllValues();
    return response;
  }

  Future<bool> authenticateUser() async {
    User user = await sharedPrefService.getUser();
    print(" 3 - user when authenticating :  $user");
    String password = await sharedPrefService.readStringFromPrefs('password');
    bool response = await userService.authenticate(user.email, password);
    print("3 - user after authenticate: ");
    await sharedPrefService.checkAllValues();
    await saveProfileDetails();
    return response;
  }

  Future<bool> updateUser() async {
    User user = await sharedPrefService.getUser();
    print("5- user before updating : $user");
    bool response = await userService.updateUser(user);
    print("5- user after updating : ");
    await sharedPrefService.checkAllValues();
    return response;
  }

  Future<String> sendSms() async {
    User user = await sharedPrefService.getUser();
    String response = await userService.sendSMS(user.email);
    return response;
  }

  Future<void> saveProfileDetails() async {
    User user = await sharedPrefService.getUser();
    ProfileDetails profileDetails = ProfileDetails(userId: user.id! ,
        profilePicture: 'images_default.png');
    await profileService.saveProfileDetails(profileDetails);
  }

  Widget _getPageForStep(int step) {
    switch (step) {
      case 0:
        print('case 0');
        return SignUpScreen(controller: signUpFormController);
      case 1:
        print('case  1');
        return VerificationMailPage(controller: verificationMailController);
      case 2:
        print('case  2');
        return PhoneInput(controller: phoneInputController);
      case 3:
        print('case  3');
        return VerificationPage(controller: verificationPageController);
      case 4:
        print('case  4');
        return Steppercomplet();
      default:
        return const Center(child: Text('Étape inconnue'));
    }
  }

  Future<Map<String, dynamic>> _validateStep(int step) async {
    switch (step) {
      case 0:
        setState(() {
          isLoading = true;
        });
        Map<String , dynamic> result = await signUpFormController.validate();
        if (result.isNotEmpty) {
          return signUpFormController.validate();
        }
        bool userSaved = await saveUser();

        if (userSaved == false) {
          return {'error': true, 'message': 'Failed to save user'};
        } else {
          bool userAuthenticated = await authenticateUser();
          if (userAuthenticated == false) {
            return {'error': true, 'message': 'Failed to authenticate user'};
          } else {
            return {};
          }
        }
      case 1:
        return verificationMailController.validate();
      case 2:
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> result = await phoneInputController.validate();
        if (result.isNotEmpty) {
          return phoneInputController.validate();
        }
        bool userUpdated = await updateUser();
        String smsSent = '';

        if (userUpdated == false) {
          return {'error': true, 'message': 'Failed to update user'};
        } else {
          smsSent = await sendSms();
        }
        if (smsSent == 'Error sending sms') {
          return {'error': true, 'message': 'Failed to send sms'};
        } else {
          return {};
        }
      case 3:
        return verificationPageController.validate();
      default:
        return signUpFormController.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep--;
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LinearProgressIndicator(
                        value: currentStep / totalSteps,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 4.h,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.r,
                      backgroundColor: currentStep >= totalSteps
                          ? Colors.green
                          : Colors.grey[200],
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        color: currentStep >= totalSteps
                            ? Colors.white
                            : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                ///////////houuni
                alignment: Alignment.topCenter,
                children: [_getPageForStep(currentStep)],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Center(
                // buttons continuer, ignorer
                child: _buildButtonsForStep(currentStep),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsForStep(int step) {
    if (step == totalSteps) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileStepper()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.33.r),
                ),
              ),
              child: Text(
                'Set Profile',
                style: TextStyle(
                  fontSize: 0.034.sw,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.33.r),
                ),
              ),
              child: Text(
                'Go Home',
                style: TextStyle(
                  fontSize: 0.034.sw,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Center(
          child: SizedBox(
            width: 0.4.sw,
            child: isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                try{
                  validationErrors = await _validateStep(currentStep);
                }catch(e){
                  print(e);
                  validationErrors = {'error': true, 'message': "une erreur s'est produite"};
                }
                setState(() {
                  isLoading = false;
                  if (validationErrors.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(validationErrors['message']),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  } else {
                    currentStep++;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.33.r),
                ),
              ),
              child: Text(
                'Continuer',
                style: TextStyle(
                  fontSize: 0.034.sw,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}