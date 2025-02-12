import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/AppTheme.dart';

class NewPasswordPage extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Future<void> Function() onResetPassword;

  const NewPasswordPage({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.primaryColor.withOpacity(0.05),
                ],
              ),
            ),
          ),
          // Top left blob
          Positioned(
            top: -120.h,
            left: -50.w,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/vectorLogintop2.png',
                width: 300.w,
                height: 574.11.h,
              ),
            ),
          ),
          // Bottom right blob
          Positioned(
            bottom: -70.h,
            right: -70.w,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/VectorLogin.png',
                width: 200.w,
                height: 1000.h,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80.h),
                    // Logo with a subtle shadow
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 150.w,
                          height: 150.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Title with better typography
                    Text(
                      "Réinitialisation du mot de passe",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 24.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Veuillez entrer un nouveau mot de passe et le confirmer.",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    // Password input field with improved design
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Nouveau mot de passe',
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Confirm password input field with improved design
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Reset password button with gradient and shadow
                    GestureDetector(
                      onTap: onResetPassword,
                      child: Container(
                        width: 200.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Changer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
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