import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final String logoPath;
  final String iconPath;

  const SuccessDialog({
    super.key,
    required this.message,
    required this.logoPath,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Bordures plus arrondies
      ),
      elevation: 10, // Ombre plus prononcée
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(25), // Espacement intérieur
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!], // Dégradé subtil
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30), // Bordures arrondies
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo principal (agrandi)
            Image.asset(
              logoPath,
              width: 120, // Taille agrandie
              height: 120,
            ),
            SizedBox(height: 20),

            // Icône de succès (agrandie)
            Image.asset(
              iconPath,
              width: 60, // Taille agrandie
              height: 60,
              color: Colors.green, // Couleur verte pour l'icône
            ),
            SizedBox(height: 20),

            // Message de succès
            Text(
              message,
              style: TextStyle(
                fontSize: 18, // Taille de police augmentée
                fontWeight: FontWeight.w600, // Police plus épaisse
                color: Colors.green[800], // Couleur plus foncée
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),

            // Bouton OK
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800], // Couleur plus foncée
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Taille du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Bordures arrondies
                ),
                elevation: 5, // Ombre pour le bouton
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // Police plus épaisse
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}