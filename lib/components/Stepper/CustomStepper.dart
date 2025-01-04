import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/components/Stepper/ProfileStepper.dart';
import 'package:khedma/components/Stepper/stepperComplet.dart';
import 'package:khedma/entities/ProfileDetails.dart';
import 'package:khedma/screens/MainPages/HomePage.dart';
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
  late UserService us;
  late ProfileService profileService;
  late SharedPrefService sharedPrefService;
  final SignUpFormController signUpFormController = SignUpFormController();
  Map<String, dynamic> validationErrors = {};

  @override
  void initState() {
    super.initState();
    us = UserService();
    profileService = ProfileService();
    sharedPrefService = SharedPrefService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> SaveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String day = prefs.getString('day') ?? '';
    String month = prefs.getString('month') ?? '';
    String year = prefs.getString('year') ?? '';
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';
    DateTime dob = DateTime(int.parse(year), int.parse(month), int.parse(day));
    User user = User(
        firstName: prefs.getString('firstName') ?? '',
        lastName: prefs.getString('lastName') ?? '',
        email: email,
        password: password,
        numTel: prefs.getString('numTel') ?? '',
        userName: prefs.getString('userName') ?? '',
        roles: '',
        dateNaissance: dob,
        isProfileCompleted: false,
        isAccountBanned: false);
    await sharedPrefService.clearAllUserData();
    bool gotUser = false ;
    bool connected = false ;
    gotUser =  await us.saveUser(user);
    if(gotUser == true ){
      connected = await us.authenticate(email,password);
      int userId = await us.sharedPrefService.getUser().then((value) => value.id!);
      if(connected == true){
        print('user and profile saved');

        ProfileDetails profileDetails = ProfileDetails(userId: userId);
        profileDetails.profilePicture = 'images_default.png';
        await profileService.saveProfileDetails(profileDetails);
      }
    }
  }

  Map<String, dynamic> _validateStep(int step) {
    switch (step) {
      case 0:
        return signUpFormController.validate();
      case 1:
        return signUpFormController.validate();
      case 2:
        // Add validation logic for step 2
        return signUpFormController.validate();
      case 3:
        // Add validation logic for step 3
        return signUpFormController.validate();
      default:
        return signUpFormController.validate();
    }
  }
  Widget _getPageForStep(int step) {
    switch (step) {
      case 0:
        print('case 0');
        return SignUpScreen(controller: signUpFormController);
      case 1:
        print('case  1');
        return VerificationMailPage();
      case 2:
        print('case  2');
        return PhoneInput();
      case 3:
        print('case  3');
        return VerificationPage();
      case 4:
        print('case  4');

        SaveUserData();
        return Steppercomplet();
      default:
        return const Center(child: Text('Étape inconnue'));
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
                    MaterialPageRoute(builder: (context) => ProfileStepper()),
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
                  // redirect to home

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  this.validationErrors = _validateStep(currentStep);
                  if (this.validationErrors.isNotEmpty) {
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
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
