import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Pour formater les dates

import '../../components/Card/WorkCard.dart';
import '../../entities/Travail.dart';
import '../../entities/User.dart';
import '../../services/TravailService.dart'; // Importez votre service TravailService
import '../../services/SharedPrefService.dart'; // Importez votre service SharedPrefService
import '../../components/Card/ConfirmationNotficationCard.dart';
import '../../components/Card/SuccessNotificationCard.dart';
import 'AddBlog.dart';

class ProfileBlogs extends StatefulWidget {
  @override
  _ProfileBlogsState createState() => _ProfileBlogsState();
}

class _ProfileBlogsState extends State<ProfileBlogs> {
  int? pubId;
  List<Travail> travaux = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  User? user;
  SharedPrefService sharedPrefService = SharedPrefService();

  @override
  void initState() {
    super.initState();
    loadUser();
  }
  Future<void> loadUser() async {
    user = await sharedPrefService.getUser();
    print(user!.id);
    setState(() {});
    if (user != null) {
      _fetchTravaux(user!.id ?? 0);
    }
  }

  Future<void> _fetchTravaux(int userId) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Travail> fetchedTravaux = await TravailService().getTravaux(userId);
      setState(() {
        travaux = fetchedTravaux;
      });
    } catch (e) {
      print('Erreur lors de la récupération des travaux: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollToLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 300,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  void _scrollToRight() {
    _scrollController.animateTo(
      _scrollController.offset + 300,
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
                // Ajouter le nouveau blog à la liste (si nécessaire)
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
                await TravailService().deleteTravail(pubId);
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

  // Méthode pour formater la date
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date); // Exemple : "12 Oct 2023"
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // Afficher un indicateur de chargement si les données sont en cours de récupération
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (travaux.isEmpty)
            Center(child: Text("Aucun travail disponible."))
          else
          // Conteneur pour la liste horizontale et les flèches
            Stack(
              alignment: Alignment.center,
              children: [
                // Liste horizontale des travaux
                Container(
                  height: 300,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: travaux.length,
                    itemBuilder: (context, index) {
                      final travail = travaux[index];
                      return BlogCard(
                        travailId: travail.id ?? 0,
                        title: travail.titre ?? "",
                        date: travail.addedDate != null ? formatDate(travail.addedDate!) : "Date non disponible",
                        description: travail.description ?? "",
                        image: travail.image ?? "",
                        onEditPressed: () {
                          // Logique pour éditer le travail
                        },
                        onDeletePressed: () => _showCancelDialog(context, travail.id ?? 0),
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
                      child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                    ),
                  ),
                ),
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