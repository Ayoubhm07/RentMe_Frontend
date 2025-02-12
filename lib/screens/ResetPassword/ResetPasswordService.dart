import 'package:flutter/material.dart';
import 'package:khedma/Services/UserService.dart';
import 'success_dialog.dart'; // Importez le dialogue de succès
import 'error_dialog.dart'; // Importez le dialogue d'erreur

class ResetPasswordService {
  final UserService _userService = UserService();

  Future<bool> sendEmail(String email, BuildContext context) async {
    RegExp emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegEx.hasMatch(email)) {
      _showErrorDialog(context, 'Veuillez entrer une adresse e-mail valide');
      return false; // Retourne false en cas d'erreur
    }
    try {
      String response = await _userService.resetVerificationCode(email);
      if (response == 'Code sent successfully') {
        _showSuccessDialog(
          context,
          'Un code de vérification a été envoyé à votre adresse e-mail.',
        );
        return true; // Retourne true en cas de succès
      } else {
        _showErrorDialog(context, response);
        return false; // Retourne false en cas d'erreur
      }
    } catch (e) {
      _showErrorDialog(context, 'Une erreur s\'est produite lors de l\'envoi du code.');
      return false; // Retourne false en cas d'erreur
    }
  }

  Future<bool> verifyCode(String email, String code, BuildContext context) async {
    if (code.isEmpty) {
      _showErrorDialog(context, 'Veuillez entrer un code');
      return false; // Retourne false en cas d'erreur
    }
    if (code.length != 4) {
      _showErrorDialog(context, 'Veuillez entrer un code de 4 chiffres');
      return false; // Retourne false en cas d'erreur
    }
    try {
      int parsedCode = int.parse(code);
      String response = await _userService.resetVerifyEmail(email, parsedCode);
      if (response == 'Code verified') {
        _showSuccessDialog(
          context,
          'Code vérifié avec succès. Vous pouvez maintenant réinitialiser votre mot de passe.',
        );
        return true; // Retourne true en cas de succès
      } else {
        _showErrorDialog(context, response);
        return false; // Retourne false en cas d'erreur
      }
    } catch (e) {
      _showErrorDialog(context, 'Veuillez entrer un code valide');
      return false; // Retourne false en cas d'erreur
    }
  }

  Future<bool> resetPassword(
      String email,
      String code,
      String password,
      String confirmPassword,
      BuildContext context,
      ) async {
    if (code.isEmpty) {
      _showErrorDialog(context, 'Veuillez entrer un code');
      return false; // Retourne false en cas d'erreur
    }
    if (code.length != 4) {
      _showErrorDialog(context, 'Veuillez entrer un code de 4 chiffres');
      return false; // Retourne false en cas d'erreur
    }
    if (password.isEmpty) {
      _showErrorDialog(context, 'Veuillez entrer un mot de passe');
      return false; // Retourne false en cas d'erreur
    }
    if (password.length < 6) {
      _showErrorDialog(context, 'Le mot de passe doit contenir au moins 6 caractères');
      return false; // Retourne false en cas d'erreur
    }
    if (password != confirmPassword) {
      _showErrorDialog(context, 'Les mots de passe ne correspondent pas');
      return false; // Retourne false en cas d'erreur
    }
    try {
      int parsedCode = int.parse(code);
      String response = await _userService.resetPassword(email, parsedCode, password);
      if (response == 'Password reset successfully') {
        _showSuccessDialog(
          context,
          'Votre mot de passe a été réinitialisé avec succès.',
        );
        return true; // Retourne true en cas de succès
      } else {
        _showErrorDialog(context, response);
        return false; // Retourne false en cas d'erreur
      }
    } catch (e) {
      _showErrorDialog(context, 'Une erreur s\'est produite lors de la réinitialisation du mot de passe.');
      return false; // Retourne false en cas d'erreur
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          message: message,
          logoPath: 'assets/images/logo.png',
          iconPath: 'assets/icons/check1.png',
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(message: message);
      },
    );
  }
}