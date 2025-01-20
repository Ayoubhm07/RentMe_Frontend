import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import '../../Services/UserService.dart';
import '../../entities/User.dart';
import '../../theme/AppTheme.dart';

class SignUpFormController {

  SharedPrefService sharedPrefService = SharedPrefService();
  String _selectedGender = 'Male';

  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Future<Map<String, dynamic>> validate() async {

    String errorMessage = '';
    Map<String, dynamic> result = {};

    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    if (_prenomController.text.isEmpty ||
        _nomController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      errorMessage = 'All fields are required';
      result = {'error': true, 'message': errorMessage};
    } else if (!RegExp(emailRegex).hasMatch(_emailController.text)) {
      errorMessage = 'Invalid email';
      result = {'error': true, 'message': errorMessage};
    } else if (_passwordController.text.length < 6) {
      errorMessage = 'Password must be at least 6 characters';
      result = {'error': true, 'message': errorMessage};
    } else if (_passwordController.text != _confirmPasswordController.text) {
      errorMessage = 'Passwords don\'t match';
      result = {'error': true, 'message': errorMessage};
    } else  if (_dateController.text.isEmpty) {
      errorMessage = 'Date is required';
      result = {'error': true, 'message': errorMessage};
    }
    await save();
    return result;
  }
  Future<void> save() async {
    User user = User(
      firstName: _nomController.text,
      lastName: _prenomController.text,
      email: _emailController.text,
      password: _passwordController.text,
      dateNaissance: DateTime.parse(_dateController.text),
      userName: "${_nomController.text} ${_prenomController.text}",
      roles: 'USER',
      sexe: _selectedGender,
    );
    print("1 - saveing user to shared prefs : $user ");
    await sharedPrefService.saveStringToPrefs("password", _passwordController.text);
    await sharedPrefService.saveUser(user);

    print("1 - after saving user to shared prefs : ") ;
    await sharedPrefService.checkAllValues();
  }
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
  }
}

class SignUpScreen extends StatefulWidget {
  final SignUpFormController controller;

  SignUpScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserService userService = UserService();
  SharedPrefService sharedPrefService = SharedPrefService();

  final List<Map<String, dynamic>> textFieldsData = [
    {'label': 'Prénom', 'hint': 'Nom'},
    {'label': 'Nom', 'hint': 'Prénom'},
    {'label': 'Email', 'hint': 'E-mail'},
    {'label': 'Password', 'hint': 'Password'},
    {'label': 'Confirm', 'hint': 'Confirm Password'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadUserData() async {
    User user = await sharedPrefService.getUser();
    String password = await sharedPrefService.readStringFromPrefs("password");
    setState(() {
      widget.controller._prenomController.text = user.lastName;
      widget.controller._nomController.text = user.firstName;
      widget.controller._emailController.text = user.email;
      widget.controller._selectedGender = user.sexe;
      widget.controller._dateController.text = user.dateNaissance.toLocal().toString().split(' ')[0];
      widget.controller._passwordController.text = password;
      widget.controller._confirmPasswordController.text = password;
    });
  }

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
                    child: Image.asset("assets/images/logo_rent_me-removebg-preview 2.png",
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
                  SizedBox(height: 18.h),
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
                  SizedBox(height: 30.h),
                  ...textFieldsData.map((data) => Column(
                        children: [
                          _buildTextField(data),
                          SizedBox(height: 30.h),
                        ],
                      )),
                  SizedBox(height: 20.h),
                  Text(
                    'Your gender',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGenderButton('Male', "assets/icons/img.png",
                          widget.controller._selectedGender == 'Male', () {
                        setState(() {
                          widget.controller._selectedGender = 'Male';
                        });
                      }),
                      SizedBox(width: 10.w),
                      _buildGenderButton('Female', "assets/icons/img_2.png",
                          widget.controller._selectedGender == 'Female', () {
                        setState(() {
                          widget.controller._selectedGender = 'Female';
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Your birthday',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // add a date picker here
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            // set the start Date to 2000
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                widget.controller._dateController.text = value.toLocal().toString().split(' ')[0];
                              });
                            }
                          });
                        },
                        child: Container(
                          height: 70.h,
                          width: 320.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              widget.controller._dateController.text.isEmpty ? 'Date de naissance' : widget.controller._dateController.text,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(Map<String, dynamic> textFieldData) {
    TextEditingController controller;
    bool isPassword = false;
    switch (textFieldData['label']) {
      case 'Prénom':
        controller = widget.controller._prenomController;
        break;
      case 'Nom':
        controller = widget.controller._nomController;
        break;
      case 'Email':
        controller = widget.controller._emailController;
        break;
      case 'Password':
        controller = widget.controller._passwordController;
        isPassword = true;
        break;
      case 'Confirm':
        controller = widget.controller._confirmPasswordController;
        isPassword = true;
        break;
      default:
        controller =
            TextEditingController(); // Un contrôleur par défaut si jamais
    }

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
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: textFieldData['hint'],
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (controller == widget.controller._prenomController)
              return 'Please enter your first name';
            if (controller == widget.controller._nomController)
              return 'Please enter your last name';
            if (controller == widget.controller._emailController)
              return 'Please enter your email';
            if (controller == widget.controller._passwordController)
              return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderButton(
      String label, String iconPath, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70.h, // Réduit la hauteur
          width: 70.w, // Réduit la largeur
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r), // Réduit le rayon du bord
            border: Border.all(color: isSelected ? Colors.green : Colors.grey),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w), // Réduit le padding
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(6.r), // Réduit le rayon du bord
                  ),
                  child: Image.asset(
                    iconPath,
                    width: 24.w, // Ajuste la largeur de l'image
                    height: 24.h,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp, // Ajuste la taille du texte
                    color: isSelected ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
