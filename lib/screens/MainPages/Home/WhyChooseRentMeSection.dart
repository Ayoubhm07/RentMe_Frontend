import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';

class WhyChooseRentMeSection extends StatefulWidget {
  @override
  _WhyChooseRentMeSectionState createState() => _WhyChooseRentMeSectionState();
}

class _WhyChooseRentMeSectionState extends State<WhyChooseRentMeSection>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> reasons = [
    {
      "icon": Icons.thumb_up,
      "title": "Facile à utiliser",
      "description": "Une interface intuitive pour une expérience utilisateur fluide.",
      "color": Color(0xFF0099D5),
    },
    {
      "icon": Icons.security,
      "title": "Sécurisé",
      "description": "Transactions sécurisées et données protégées.",
      "color": Color(0xFF0AA655),
    },
    {
      "icon": Icons.access_time,
      "title": "Gain de temps",
      "description": "Trouvez rapidement des services ou des locations.",
      "color": Color(0xFFE72F49),
    },
  ];

  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    // Initialisation du contrôleur d'animation
    _logoAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Répéter l'animation en boucle

    // Initialisation de l'animation du logo
    _logoAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose(); // Libérer le contrôleur d'animation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      color: Colors.white,
      child: Column(
        children: [
          // Titre avec logo animé
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                'Pourquoi choisir RentMe ?',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),

            ],
          ),
          ScaleTransition(
            scale: _logoAnimation,
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
          ),
          SizedBox(height: 10),
          // Liste horizontale des raisons avec card_swiper
          Container(
            height: 140, // Hauteur fixe pour la liste
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                final reason = reasons[index];
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: reason["color"].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          reason["icon"],
                          size: 40,
                          color: reason["color"],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reason["title"],
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              reason["description"],
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: reasons.length,
              autoplay: true, // Défilement automatique
              autoplayDelay: 3000, // Délai entre chaque slide (3 secondes)
              duration: 1000, // Durée de l'animation de transition
              viewportFraction: 0.8, // Taille de chaque slide (80% de la largeur)
              scale: 0.9, // Effet de zoom entre les slides
              pagination: SwiperPagination(), // Ajouter des indicateurs de pagination
              control: SwiperControl(), // Ajouter des flèches de navigation
            ),
          ),
        ],
      ),
    );
  }
}