import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';

import '../../entities/User.dart';
import '../../theme/AppTheme.dart';

class VerificationPageController {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());

  SharedPrefService sharedPrefService = SharedPrefService();
  UserService userService = UserService();

  Future<Map<String, dynamic>> validate() async {
    String errorMessage = '';
    Map<String, dynamic> result = {};
    int code = 0;
    try {
      code = int.parse(_controllers.map((e) => e.text).join());
    } on FormatException {
      errorMessage = 'Veuillez entrer un code de 4 chiffres';
      result = {'error': true, 'message': errorMessage};
      return result;
    }
    if (code.toString().length < 4) {
      errorMessage = 'Veuillez entrer un code de 4 chiffres';
      result = {'error': true, 'message': errorMessage};
      return result;
    } else {
      await sharedPrefService.checkAllValues();
      User user = await sharedPrefService.getUser();
      String response = await userService.verifyNumber(
          user.id!, int.parse(_controllers.map((e) => e.text).join()));
      if (response != 'Code verified') {
        result = {'error': true, 'message': response};
        return result;
      }
    }
    return result;
  }
}

class VerificationPage extends StatefulWidget {
  final VerificationPageController controller;

  const VerificationPage({Key? key, required this.controller})
      : super(key: key);

  @override
  VerificationPageState createState() => VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  late UserService userService;
  late SharedPrefService sharedPrefService;

  @override
  void initState() {
    super.initState();
    sharedPrefService = SharedPrefService();
    userService = UserService();
  }
  resendVerificationCode() async {
    User user = await sharedPrefService.getUser();
    String response = await userService.sendSMS(user.email);
    print(response);
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize:
      Size(375, 812), // Taille de conception de base (largeur, hauteur)
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                        "assets/images/lock.png",
                        width: 191.w,
                        height: 191.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Vérification du numéro de téléphone',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Vous venez de recevoir un code sur votre numéro de téléphone:\n+216 26 ******',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppTheme.accentColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 0.12.sw,
                          // Adjusted to be proportional to screen width
                          height: 0.12.sw,
                          // Keeping it square by using same proportion
                          child: TextField(
                            controller: widget.controller._controllers[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.sp),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              fillColor: AppTheme.grisTextField,
                              // Background color of the text field
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        resendVerificationCode();
                      },
                      child: Text(
                        'Envoyer un autre code',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}