import 'package:flutter/material.dart';
import '../Login.dart';
import 'CodePage.dart';
import 'EmailPage.dart';
import 'NewPassword.dart';
import 'ResetPasswordService.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({super.key});

  @override
  ResetPasswordWidgetState createState() => ResetPasswordWidgetState();
}

class ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isCodeSent = false;
  bool _isCodeVerified = false;

  final ResetPasswordService _resetPasswordService = ResetPasswordService();

  @override
  Widget build(BuildContext context) {
    return _isCodeSent
        ? _isCodeVerified
        ? NewPasswordPage(
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      onResetPassword: _resetPassword,
    )
        : CodePage(
      codeController: _codeController,
      onVerifyCode: _verifyCode,
    )
        : EmailPage(
      emailController: _emailController,
      onSendEmail: _sendEmail,
    );
  }

  Future<void> _sendEmail() async {
    bool success = await _resetPasswordService.sendEmail(_emailController.text, context);
    if (success) {
      setState(() {
        _isCodeSent = true; // Mettre à jour l'état uniquement en cas de succès
      });
    }
  }

  Future<void> _verifyCode() async {
    bool success = await _resetPasswordService.verifyCode(_emailController.text, _codeController.text, context);
    if (success) {
      setState(() {
        _isCodeVerified = true; // Mettre à jour l'état uniquement en cas de succès
      });
    }
  }

  Future<void> _resetPassword() async {
    bool success = await _resetPasswordService.resetPassword(
      _emailController.text,
      _codeController.text,
      _passwordController.text,
      _confirmPasswordController.text,
      context,
    );
    if (success) {
      // Rediriger vers la page de connexion uniquement en cas de succès
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }
}