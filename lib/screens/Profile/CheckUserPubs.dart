import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/components/Card/CheckedWorkCard.dart';

import '../../Services/TravailService.dart';
import '../../entities/Travail.dart';
import '../../entities/User.dart';

class CheckUserPubs extends StatefulWidget {
  final int userId;

  const CheckUserPubs({super.key, required this.userId});
  @override
  _CheckUserPubsState createState() => _CheckUserPubsState();
}

class _CheckUserPubsState extends State<CheckUserPubs> {
  int? pubId;
  List<Travail> travaux = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTravaux(widget.userId);
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
          // Titre "Espace Travaux"
          Center(
            child: Text(
              "Espace Travaux",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: 30),
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
                      return CheckedBlogCard(
                        travailId: travail.id ?? 0,
                        title: travail.titre ?? "",
                        date: travail.addedDate != null ? formatDate(travail.addedDate!) : "Date non disponible",
                        description: travail.description ?? "",
                        image: travail.image ?? "",
                        onEditPressed: () {
                          // Logique pour éditer le travail
                        },
                        onDeletePressed: (){
                        },
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