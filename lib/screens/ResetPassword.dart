import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/screens/Login.dart';
import '../theme/AppTheme.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({super.key});

  @override
  ResetPasswordWidgetState createState() => ResetPasswordWidgetState();
}

class ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _isCodeSent = false;
  bool _isCodeVerified = false;

  UserService userService = UserService();

  Future<String> sendEmail() async
  {
    String email = _emailController.text;
    RegExp emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegEx.hasMatch(email)) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    try {
      String response = await userService.resetVerificationCode(email);
      return response ;
    } catch (e) {
      return 'Une erreur s\'est produite';
    }
  }

  Future<String> verifyCode() async
  {
    String email = _emailController.text;
    int code = 0 ;
    if(_codeController.text.isEmpty){
      return 'Veuillez entrer un code';
    }
    if(_codeController.text.length != 4){
      return 'Veuillez entrer un code de 4 chiffres';
    }
    try{
      code = int.parse(_codeController.text);
    }
    catch(e){
      return 'Veuillez entrer un code valide';
    }
    try {
      String response = await userService.resetVerifyEmail(email, code);
      return response ;
    } catch (e) {
      return 'Une erreur s\'est produite';
    }
  }

  Future<String> resetPassword() async
  {
    String email = _emailController.text;
    int code = 0 ;
    if(_codeController.text.isEmpty){
      return 'Veuillez entrer un code';
    }
    if(_codeController.text.length != 4){
      return 'Veuillez entrer un code de 4 chiffres';
    }
    try{
      code = int.parse(_codeController.text);
    }
    catch(e){
      return 'Veuillez entrer un code valide';
    }
    if(_passwordController.text.isEmpty){
      return 'Veuillez entrer un mot de passe';
    }
    if(_passwordController.text.length < 6){
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if(_passwordController.text != _confirmPasswordController.text){
      return 'Les mots de passe ne correspondent pas';
    }
    try {
      String response = await userService.resetPassword(email, code, _passwordController.text);
      return response ;
    } catch (e) {
      return 'Une erreur s\'est produite';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isCodeSent
        ? _isCodeVerified
        ? _buildNewPasswordPage()
        : _buildCodePage()
        : _buildEmailPage();
  }

  Widget _buildEmailPage() {
    return Scaffold(
      body: Stack(
        children: [
          // Top left blob
          Positioned(
            top: -120.h,
            left: -50.w,
            child: Image.asset(
              'assets/images/vectorLogintop2.png',
              width: 300.w, // Adjust width
              height: 574.11.h, // Adjust height
            ),
          ),
          // Bottom right blob
          Positioned(
            bottom: -70.h,
            right: -70.w,
            child: Image.asset(
              'assets/images/VectorLogin.png',
              width: 200.w, // Adjust width
              height: 1000.h, // Adjust height
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.h),
                    Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: SizedBox(
                        width: 361.w,
                        height: 189.h,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(height: 42.h),
                    Text("Veuillez entrer votre adresse e-mail",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 20.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        )),
                    SizedBox(height: 20.h),
                    Container(
                      width: 281.w,
                      height: 46.h,
                      margin: EdgeInsets.only(left: 10.w, top: 20.h),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Adresse E-Mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    GestureDetector(
                      onTap: () async {
                        String response = await sendEmail();
                        if(response == 'Code sent successfully'){
                          setState(() {
                            _isCodeSent = true;
                          });
                        }
                        else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response),
                          ));
                        }
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 133,
                            height: 46,
                            child: InkWell(
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 133,
                                      height: 46,
                                      decoration: ShapeDecoration(
                                        color: AppTheme.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'Envoyer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildCodePage() {
    return Scaffold(
      body: Stack(
        children: [
// Top left blob
          Positioned(
            top: -120.h,
            left: -50.w,
            child: Image.asset(
              'assets/images/vectorLogintop2.png',
              width: 300.w, // Adjust width
              height: 574.11.h, // Adjust height
            ),
          ),
// Bottom right blob
          Positioned(
            bottom: -70.h,
            right: -70.w,
            child: Image.asset(
              'assets/images/VectorLogin.png',
              width: 200.w, // Adjust width
              height: 1000.h, // Adjust height
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.h),
                    Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: SizedBox(
                        width: 361.w,
                        height: 189.h,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(height: 42.h),
                    Text("Veuillez entrer votre code",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 20.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        )),
                    SizedBox(height: 20.h),
                    Container(
                      width: 281.w,
                      height: 46.h,
                      margin: EdgeInsets.only(left: 10.w, top: 20.h),
                      child: TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'Code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    GestureDetector(
                      onTap: () {
                        // verify code
                        verifyCode().then((response) {
                          if(response == 'Code verified'){
                            setState(() {
                              _isCodeVerified = true;
                            });
                          }
                          else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response),
                            ));
                          }
                        });
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 133,
                            height: 46,
                            child: InkWell(
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 133,
                                      height: 46,
                                      decoration: ShapeDecoration(
                                        color: AppTheme.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'Valider',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildNewPasswordPage() {
    return Scaffold(
      body: Stack(
        children: [
          // Top left blob
          Positioned(
            top: -120.h,
            left: -50.w,
            child: Image.asset(
              'assets/images/vectorLogintop2.png',
              width: 300.w, // Adjust width
              height: 574.11.h, // Adjust height
            ),
          ),
          // Bottom right blob
          Positioned(
            bottom: -70.h,
            right: -70.w,
            child: Image.asset(
              'assets/images/VectorLogin.png',
              width: 200.w, // Adjust width
              height: 1000.h, // Adjust height
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.h),
                    Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: SizedBox(
                        width: 361.w,
                        height: 189.h,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(height: 42.h),
                    Text("Veuillez entrer votre mot de passe",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 20.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        )),
                    SizedBox(height: 20.h),
                    Container(
                      width: 281.w,
                      height: 46.h,
                      margin: EdgeInsets.only(left: 10.w, top: 20.h),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 281.w,
                      height: 46.h,
                      margin: EdgeInsets.only(left: 10.w, top: 20.h),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    GestureDetector(
                      onTap: () {
                        // reset password
                        resetPassword().then((response) {
                          if(response == 'Password reset successfully'){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response),
                            ));
                            // go to login page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          }
                          else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response),
                            ));
                          }
                        });
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 133,
                            height: 46,
                            child: InkWell(
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 133,
                                      height: 46,
                                      decoration: ShapeDecoration(
                                        color: AppTheme.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'Changer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
}