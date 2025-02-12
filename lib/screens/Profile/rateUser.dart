import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RateUser extends StatefulWidget {
  final Function(double) onRateSubmitted; // Changement de int à double

  const RateUser({Key? key, required this.onRateSubmitted}) : super(key: key);

  @override
  _RateUserState createState() => _RateUserState();
}

class _RateUserState extends State<RateUser> {
  double _selectedRating = 0.0; // Changement de int à double

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre
            Text(
              "Noter ce profil",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            // Description
            Text(
              "Votre avis nous intéresse ! Veuillez noter ce profil en fonction de votre expérience.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            // Étoiles de notation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Permet de sélectionner des demi-étoiles
                      _selectedRating = index + 1.0;
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      // Permet de sélectionner des demi-étoiles
                      _selectedRating = index + 0.5;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      // Affiche des demi-étoiles si nécessaire
                      (index + 1.0 <= _selectedRating)
                          ? Icons.star
                          : (index + 0.5 <= _selectedRating)
                          ? Icons.star_half
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            // Affichage de la note sélectionnée
            Text(
              "Note sélectionnée : $_selectedRating",
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            // Bouton de soumission
            ElevatedButton(
              onPressed: () {
                widget.onRateSubmitted(_selectedRating); // Envoie la note en double
                Navigator.of(context).pop(); // Fermer le widget
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: Text(
                "Soumettre",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Bouton pour fermer
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le widget
              },
              child: Text(
                "Fermer",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}