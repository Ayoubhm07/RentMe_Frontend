import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'NewProfile.dart';

class EchecTokenScreen extends StatefulWidget {
  @override
  State<EchecTokenScreen> createState() => _EchecTokenScreenState();
}

class _EchecTokenScreenState extends State<EchecTokenScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 9, 9),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Shrink-wrap the column
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          // Action to close the dialog
                        },
                      ),
                      Text(
                        'Achat de token',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 48), // To balance the space with the close button
                    ],
                  ),
                  
                  SizedBox(height: 20), 

                  // Centering the image
                  Center(
                    child: Image.asset(
                      "assets/icons/echec.png",
                      width: 100, // You can adjust the size
                      height: 100,
                    ),
                  ),
                  
                  SizedBox(height: 40), // Adding space between image and text

                  // Centering the text
                  Center(
                    child: Text(
                      'Votre achat est intérrompu.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        height: 1.3,
                        color: Color(0xFF1C1F1E),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20), // Adding space between text and button

                  // Centering the button and increasing its width
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()), // Replace 'ProfilePage' with your actual profile page widget
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.blue, // Use your theme color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.33),
                          ),
                        ),
                        child: Text(
                          'Continuer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
