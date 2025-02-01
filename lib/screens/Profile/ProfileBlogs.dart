import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/Card/ConfirmationNotficationCard.dart';
import '../../components/Card/SuccessNotificationCard.dart';
import 'AddBlog.dart';

class ProfileBlogs extends StatefulWidget {
  @override
  _ProfileBlogsState createState() => _ProfileBlogsState();
}

class _ProfileBlogsState extends State<ProfileBlogs> {
  int? pubId;
  final List<Map<String, dynamic>> blogs = [
    {
      "title": "Projet de Design",
      "date": "12 Oct 2023",
      "description": "Un projet de design moderne pour une application mobile.",
      "image": "assets/images/menage.jpeg",
    },
    {
      "title": "Site Web E-commerce",
      "date": "5 Nov 2023",
      "description": "Développement d'un site web e-commerce avec Flutter et Node.js.",
      "image": "assets/images/menage.jpeg",
    },
    {
      "title": "Application de Gestion",
      "date": "20 Nov 2023",
      "description": "Application de gestion des tâches pour les entreprises.",
      "image": "assets/images/menage.jpeg",
    },
  ];

  final ScrollController _scrollController = ScrollController();

  void _scrollToLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 300, // Défilement de 300 pixels vers la gauche
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToRight() {
    _scrollController.animateTo(
      _scrollController.offset + 300, // Défilement de 300 pixels vers la droite
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showAddBlogModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: AddBlog(
            onSave: (newBlog) {
              setState(() {
                blogs.add(newBlog);
              });
            },
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, int pubId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous vraiment supprimer cette pub ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop();
            try {
              // await widget.offreService.deleteOffer(offerId);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Votre pub a été supprimée avec succès.',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );

              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop(); // Fermer SuccessDialog
              Navigator.of(context).pop();
            } catch (e) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Une erreur est survenue lors de la suppression de votre pub.',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );

              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop(); // Fermer ErrorDialog
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bouton "Ajouter un travail"
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddBlogModal(context);
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                "Ajouter un travail",
                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0099D6),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Conteneur pour la liste horizontale et les flèches
          Stack(
            alignment: Alignment.center,
            children: [
              // Liste horizontale des travaux
              Container(
                height: 320,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    final blog = blogs[index];
                    return Container(
                      width: 350,
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.white, Color(0xFFF2F8FF)], // Dégradé doux
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre et icônes (modifier/supprimer)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                blog["title"],
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 22, color: Colors.blueAccent),
                                    onPressed: () {
                                      //////ediit
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, size: 22, color: Colors.redAccent),
                                    onPressed: () => _showCancelDialog(context , pubId ?? 0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Date
                          Text(
                            blog["date"],
                            style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 10),
                          // Description
                          Text(
                            blog["description"],
                            style: GoogleFonts.roboto(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(height: 10),
                          // Image/Video
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              blog["image"],
                              width: double.infinity,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                child: GestureDetector(
                  onTap: _scrollToLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent, // Bleu pour modernité
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                  ),
                ),
              ),

              // Flèche droite
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: _scrollToRight,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}